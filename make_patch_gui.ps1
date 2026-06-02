#Requires -Version 5.1
<#
.SYNOPSIS
    GUI patch builder for AG-ISXPM-Made-Easy.
.DESCRIPTION
    Self-contained WinForms GUI. Enter the two release name strings,
    click Build Patch. Writes settings.ini, runs isxpm.exe, zips output.
    Launch via "Patch Builder.bat" or right-click -> Run with PowerShell.
#>

# Catch startup failures and show them as a message box instead of silently dying
try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
} catch {
    [System.Windows.Forms.MessageBox]::Show(
        "Failed to load Windows Forms:`n$_`n`nTry running as Administrator or check .NET Framework.",
        "Startup Error", "OK", "Error")
    exit 1
}

[System.Windows.Forms.Application]::EnableVisualStyles()

# ── Paths ──────────────────────────────────────────────────────────────────────
$Root        = $PSScriptRoot
$TemplateIni = Join-Path $Root "settings_template.ini"
$SettingsIni = Join-Path $Root "settings.ini"
$ConfigIni   = Join-Path $Root "game_config.ini"
$IsxpmExe    = Join-Path $Root "isxpm.exe"
$GamesOldDir = Join-Path $Root "Games\old"
$GamesNewDir = Join-Path $Root "Games\new"
$ResourceDir = Join-Path $Root "resources"
$OutputDir   = Join-Path $Root "ISXPMPatch"
$UploadDir   = Join-Path $Root "Output\Upload"

# ── Shared logic ───────────────────────────────────────────────────────────────
function Read-IniFile([string]$path) {
    $data = [ordered]@{}; $section = "_"
    foreach ($line in (Get-Content $path -Encoding UTF8)) {
        $line = $line.Trim()
        if ($line -match '^\[(.+)\]$') {
            $section = $Matches[1]
            if (-not $data.Contains($section)) { $data[$section] = [ordered]@{} }
        } elseif ($line -notmatch '^[;#]' -and $line -match '^(.+?)\s*=\s*(.*)$') {
            if (-not $data.Contains($section)) { $data[$section] = [ordered]@{} }
            $data[$section][$Matches[1].Trim()] = $Matches[2].Trim()
        }
    }
    return $data
}

function Parse-ReleaseName([string]$release) {
    if ($release -cmatch '^(.+?)\s+v([\d.]+)(\s+.+)?$') {
        return @{ GameName = $Matches[1].Trim(); Build = $Matches[2].Trim()
                  Tag = if ($Matches[3]) { $Matches[3].Trim() } else { "" } }
    }
    return $null
}

function Resolve-AssetPath([string]$value) {
    if ([string]::IsNullOrEmpty($value)) { return "" }
    if ([System.IO.Path]::IsPathRooted($value)) { return $value }
    return Join-Path $ResourceDir $value
}

function Find-GameFolder([string]$base, [string]$preferred) {
    $exact = Join-Path $base $preferred
    if (Test-Path $exact -PathType Container) { return $exact }
    $subs = @(Get-ChildItem $base -Directory -ErrorAction SilentlyContinue |
              Where-Object { $_.Name -notmatch '^\.' -and $_.Name -ne '.gitkeep' })
    if ($subs.Count -eq 1) { return $subs[0].FullName }
    return $null
}

# ── Load config ────────────────────────────────────────────────────────────────
$script:iniData  = $null
$script:profiles = @()   # only non-DEFAULT sections

if (Test-Path $ConfigIni) {
    try {
        $script:iniData  = Read-IniFile $ConfigIni
        $script:profiles = @($script:iniData.Keys | Where-Object { $_ -notin @('DEFAULT','_') })
    } catch { }
}

# ── Theme ──────────────────────────────────────────────────────────────────────
$cBg      = [System.Drawing.Color]::FromArgb(22,  22,  22)
$cPanel   = [System.Drawing.Color]::FromArgb(36,  36,  36)
$cInput   = [System.Drawing.Color]::FromArgb(48,  48,  48)
$cLog     = [System.Drawing.Color]::FromArgb(12,  12,  12)
$cAccent  = [System.Drawing.Color]::FromArgb(0,   191, 255)
$cText    = [System.Drawing.Color]::FromArgb(220, 220, 220)
$cMuted   = [System.Drawing.Color]::FromArgb(110, 110, 110)
$cSuccess = [System.Drawing.Color]::FromArgb(50,  210, 100)
$cWarn    = [System.Drawing.Color]::FromArgb(255, 165,   0)
$cError   = [System.Drawing.Color]::FromArgb(255,  75,  75)

$fNormal  = New-Object System.Drawing.Font("Segoe UI",  9)
$fBold    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fMono    = New-Object System.Drawing.Font("Consolas",  8.5)
$fSmall   = New-Object System.Drawing.Font("Segoe UI",  8, [System.Drawing.FontStyle]::Italic)

# ── Form — designed at 96 DPI, AutoScaleMode.Font scales it at higher DPI ─────
$form = New-Object System.Windows.Forms.Form
$form.AutoScaleDimensions = New-Object System.Drawing.SizeF(96, 96)
$form.AutoScaleMode       = [System.Windows.Forms.AutoScaleMode]::Font
$form.Text                = "ARMGDDN Patch Builder"
$form.ClientSize          = New-Object System.Drawing.Size(740, 520)
$form.StartPosition       = "CenterScreen"
$form.BackColor           = $cBg
$form.ForeColor           = $cText
$form.Font                = $fNormal
$form.FormBorderStyle     = "FixedSingle"
$form.MaximizeBox         = $false

# ── Input panel ────────────────────────────────────────────────────────────────
# Height depends on whether we need the profile row
$needsProfile = $script:profiles.Count -gt 0
$panelH = if ($needsProfile) { 184 } else { 154 }

$pTop = New-Object System.Windows.Forms.Panel
$pTop.Location  = New-Object System.Drawing.Point(10, 10)
$pTop.Size      = New-Object System.Drawing.Size(720, $panelH)
$pTop.BackColor = $cPanel
$form.Controls.Add($pTop)

# Title
$lblHead = New-Object System.Windows.Forms.Label
$lblHead.Text      = "ARMGDDN Patch Builder"
$lblHead.Location  = New-Object System.Drawing.Point(12, 10)
$lblHead.Size      = New-Object System.Drawing.Size(500, 22)
$lblHead.Font      = $fBold
$lblHead.ForeColor = $cAccent
$pTop.Controls.Add($lblHead)

$rowY = 40  # y of first interactive row

# Profile row — only shown when game-specific override sections exist
$script:cbProfile = $null
if ($needsProfile) {
    $lblProf = New-Object System.Windows.Forms.Label
    $lblProf.Text      = "Settings profile:"
    $lblProf.Location  = New-Object System.Drawing.Point(12, ($rowY + 3))
    $lblProf.Size      = New-Object System.Drawing.Size(112, 18)
    $lblProf.ForeColor = $cMuted
    $pTop.Controls.Add($lblProf)

    $script:cbProfile = New-Object System.Windows.Forms.ComboBox
    $script:cbProfile.Location      = New-Object System.Drawing.Point(128, $rowY)
    $script:cbProfile.Size          = New-Object System.Drawing.Size(220, 24)
    $script:cbProfile.BackColor     = $cInput
    $script:cbProfile.ForeColor     = $cText
    $script:cbProfile.DropDownStyle = "DropDownList"
    $script:cbProfile.FlatStyle     = "Flat"
    foreach ($p in $script:profiles) { [void]$script:cbProfile.Items.Add($p) }
    $script:cbProfile.SelectedIndex = 0
    $pTop.Controls.Add($script:cbProfile)

    $rowY += 32
}

# Silent build checkbox
$chkSilent = New-Object System.Windows.Forms.CheckBox
$chkSilent.Text      = "Silent build - isxpm starts and builds automatically (uncheck if it opens but does nothing)"
$chkSilent.Location  = New-Object System.Drawing.Point(12, $rowY)
$chkSilent.Size      = New-Object System.Drawing.Size(696, 20)
$chkSilent.Checked   = $true
$chkSilent.ForeColor = $cMuted
$chkSilent.Font      = $fNormal
$pTop.Controls.Add($chkSilent)
$rowY += 30

# Old release row
$lblOld = New-Object System.Windows.Forms.Label
$lblOld.Text      = "Old release:"
$lblOld.Location  = New-Object System.Drawing.Point(12, ($rowY + 4))
$lblOld.Size      = New-Object System.Drawing.Size(84, 18)
$lblOld.ForeColor = $cMuted
$pTop.Controls.Add($lblOld)

$txtOld = New-Object System.Windows.Forms.TextBox
$txtOld.Location    = New-Object System.Drawing.Point(100, $rowY)
$txtOld.Size        = New-Object System.Drawing.Size(608, 24)
$txtOld.BackColor   = $cInput
$txtOld.ForeColor   = $cText
$txtOld.BorderStyle = "FixedSingle"
$pTop.Controls.Add($txtOld)
$rowY += 32

# New release row
$lblNew = New-Object System.Windows.Forms.Label
$lblNew.Text      = "New release:"
$lblNew.Location  = New-Object System.Drawing.Point(12, ($rowY + 4))
$lblNew.Size      = New-Object System.Drawing.Size(84, 18)
$lblNew.ForeColor = $cMuted
$pTop.Controls.Add($lblNew)

$txtNew = New-Object System.Windows.Forms.TextBox
$txtNew.Location    = New-Object System.Drawing.Point(100, $rowY)
$txtNew.Size        = New-Object System.Drawing.Size(608, 24)
$txtNew.BackColor   = $cInput
$txtNew.ForeColor   = $cText
$txtNew.BorderStyle = "FixedSingle"
$pTop.Controls.Add($txtNew)
$rowY += 30

# Format hint
$lblHint = New-Object System.Windows.Forms.Label
$lblHint.Text      = "Format:  Game Name vBUILD_NUMBER -TAG     e.g.  S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340 -ARMGDDN"
$lblHint.Location  = New-Object System.Drawing.Point(12, $rowY)
$lblHint.Size      = New-Object System.Drawing.Size(696, 16)
$lblHint.ForeColor = $cMuted
$lblHint.Font      = $fSmall
$pTop.Controls.Add($lblHint)

# ── Log / status area ──────────────────────────────────────────────────────────
$logTop = 10 + $panelH + 8

$rtbLog = New-Object System.Windows.Forms.RichTextBox
$rtbLog.Location    = New-Object System.Drawing.Point(10, $logTop)
$rtbLog.Size        = New-Object System.Drawing.Size(720, 268)
$rtbLog.BackColor   = $cLog
$rtbLog.ForeColor   = $cText
$rtbLog.Font        = $fMono
$rtbLog.ReadOnly    = $true
$rtbLog.BorderStyle = "None"
$rtbLog.ScrollBars  = "Vertical"
$form.Controls.Add($rtbLog)

# ── Progress bar ───────────────────────────────────────────────────────────────
$pbarTop = $logTop + 268 + 6

$pbar = New-Object System.Windows.Forms.ProgressBar
$pbar.Location = New-Object System.Drawing.Point(10, $pbarTop)
$pbar.Size     = New-Object System.Drawing.Size(720, 12)
$pbar.Style    = "Marquee"
$pbar.MarqueeAnimationSpeed = 0
$form.Controls.Add($pbar)

# ── Buttons ────────────────────────────────────────────────────────────────────
$btnTop = $pbarTop + 12 + 10

$btnBuild = New-Object System.Windows.Forms.Button
$btnBuild.Text      = "Build Patch"
$btnBuild.Location  = New-Object System.Drawing.Point(506, $btnTop)
$btnBuild.Size      = New-Object System.Drawing.Size(110, 36)
$btnBuild.BackColor = $cAccent
$btnBuild.ForeColor = [System.Drawing.Color]::Black
$btnBuild.Font      = $fBold
$btnBuild.FlatStyle = "Flat"
$btnBuild.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnBuild)

$btnOpen = New-Object System.Windows.Forms.Button
$btnOpen.Text      = "Open Upload Folder"
$btnOpen.Location  = New-Object System.Drawing.Point(624, $btnTop)
$btnOpen.Size      = New-Object System.Drawing.Size(106, 36)
$btnOpen.BackColor = $cPanel
$btnOpen.ForeColor = $cMuted
$btnOpen.Font      = $fNormal
$btnOpen.FlatStyle = "Flat"
$btnOpen.FlatAppearance.BorderSize  = 1
$btnOpen.FlatAppearance.BorderColor = $cMuted
$btnOpen.Enabled   = $false
$form.Controls.Add($btnOpen)

$btnPreview = New-Object System.Windows.Forms.Button
$btnPreview.Text      = "Preview"
$btnPreview.Location  = New-Object System.Drawing.Point(376, $btnTop)
$btnPreview.Size      = New-Object System.Drawing.Size(122, 36)
$btnPreview.BackColor = $cPanel
$btnPreview.ForeColor = $cText
$btnPreview.Font      = $fNormal
$btnPreview.FlatStyle = "Flat"
$btnPreview.FlatAppearance.BorderSize  = 1
$btnPreview.FlatAppearance.BorderColor = $cMuted
$form.Controls.Add($btnPreview)

# Tooltips
$tip = New-Object System.Windows.Forms.ToolTip
$tip.SetToolTip($btnPreview, "Parse the release names and show what will be built before you commit")
$tip.SetToolTip($btnOpen,    "Opens Output\Upload - enabled after a successful build")
$tip.SetToolTip($chkSilent,  "When checked, isxpm.exe runs hidden and auto-starts the build.`nUncheck if silent mode isn't supported by your isxpm version.")

# Adjust form height to fit all controls
$form.ClientSize = New-Object System.Drawing.Size(740, ($btnTop + 36 + 12))

# ── Log helper ─────────────────────────────────────────────────────────────────
function Log([string]$msg, [System.Drawing.Color]$color) {
    if (-not $color) { $color = $cText }
    $rtbLog.SelectionStart  = $rtbLog.TextLength
    $rtbLog.SelectionLength = 0
    $rtbLog.SelectionColor  = $color
    $rtbLog.AppendText("$msg`n")
    $rtbLog.SelectionColor  = $cText
    $rtbLog.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

# ── Preview button ────────────────────────────────────────────────────────────
$btnPreview.Add_Click({
    if ([string]::IsNullOrWhiteSpace($txtOld.Text) -or [string]::IsNullOrWhiteSpace($txtNew.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Enter both release name strings first.", "Missing Input", "OK", "Warning")
        return
    }

    $old = Parse-ReleaseName $txtOld.Text.Trim()
    $new = Parse-ReleaseName $txtNew.Text.Trim()

    $rtbLog.Clear()

    if (-not $old) { Log "Cannot parse old release name. Expected:  Game Name vBUILD -TAG" $cError; return }
    if (-not $new) { Log "Cannot parse new release name. Expected:  Game Name vBUILD -TAG" $cError; return }

    $gameName      = $old.GameName
    $oldBuild      = $old.Build
    $newBuild      = $new.Build
    $patchFilename = "$gameName v$oldBuild-${newBuild}_Update_Patch"
    $uninstallKey  = "${gameName}_is1"
    $oldGamePath   = Join-Path $GamesOldDir $gameName
    $newGamePath   = Join-Path $GamesNewDir $gameName

    Log "Parsed values:" $cAccent
    Log "  Game name   : $gameName"
    Log "  Old build   : $oldBuild"
    Log "  New build   : $newBuild"
    Log "  Tag         : $($old.Tag)"
    Log ""
    Log "Output file:"
    Log "  $patchFilename.exe" $cSuccess
    Log ""
    Log "Registry key:"
    Log "  SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$uninstallKey"
    Log ""

    $oldExists = Test-Path $oldGamePath
    $newExists = Test-Path $newGamePath
    Log "Game folders:" $cMuted
    Log "  Old: $oldGamePath" $(if ($oldExists) { $cSuccess } else { $cWarn })
    if (-not $oldExists) { Log "       ^ NOT FOUND - install the old version to Games\old\" $cWarn }
    Log "  New: $newGamePath" $(if ($newExists) { $cSuccess } else { $cWarn })
    if (-not $newExists) { Log "       ^ NOT FOUND - install the new version to Games\new\" $cWarn }

    Log ""
    if ($oldExists -and $newExists) {
        Log "Everything looks good. Click Build Patch when ready." $cSuccess
    } else {
        Log "Install the missing game folders before building." $cWarn
    }
})

# ── Open Upload Folder button ──────────────────────────────────────────────────
$btnOpen.Add_Click({
    if (Test-Path $UploadDir) { Start-Process explorer.exe $UploadDir }
    else { [System.Windows.Forms.MessageBox]::Show("Upload folder not found yet.`nRun a build first.", "Not Found", "OK", "Information") }
})

# ── Build button ───────────────────────────────────────────────────────────────
$btnBuild.Add_Click({

    # Validate
    if ([string]::IsNullOrWhiteSpace($txtOld.Text) -or [string]::IsNullOrWhiteSpace($txtNew.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Enter both release name strings before building.", "Missing Input", "OK", "Warning")
        return
    }

    $btnBuild.Enabled = $false
    $btnOpen.Enabled  = $false
    $rtbLog.Clear()
    $pbar.MarqueeAnimationSpeed = 30

    try {
        # ── Parse release strings ──────────────────────────────────────────
        Log "Parsing release names..." $cMuted
        $old = Parse-ReleaseName $txtOld.Text.Trim()
        $new = Parse-ReleaseName $txtNew.Text.Trim()
        if (-not $old) { throw "Cannot parse old release name.`nExpected format:  Game Name vBUILD_NUMBER -TAG" }
        if (-not $new) { throw "Cannot parse new release name.`nExpected format:  Game Name vBUILD_NUMBER -TAG" }

        $gameName = $old.GameName
        $oldBuild = $old.Build
        $newBuild = $new.Build
        Log "  Game:       $gameName" $cAccent
        Log "  Old build:  $oldBuild"
        Log "  New build:  $newBuild"

        # ── Merge config ───────────────────────────────────────────────────
        $cfg = [ordered]@{}
        if ($script:iniData -and $script:iniData.Contains('DEFAULT')) {
            foreach ($k in $script:iniData['DEFAULT'].Keys) { $cfg[$k] = $script:iniData['DEFAULT'][$k] }
        }
        if ($script:cbProfile -and $script:cbProfile.SelectedItem) {
            $pk = $script:cbProfile.SelectedItem.ToString()
            if ($script:iniData.Contains($pk)) {
                foreach ($k in $script:iniData[$pk].Keys) { $cfg[$k] = $script:iniData[$pk][$k] }
            }
        }

        # ── Detect game folders ────────────────────────────────────────────
        Log "`nDetecting game folders..." $cMuted
        $oldGamePath = Find-GameFolder $GamesOldDir $gameName
        $newGamePath = Find-GameFolder $GamesNewDir $gameName
        if (-not $oldGamePath) { throw "No folder found in Games\old\`nInstall the old version there first." }
        if (-not $newGamePath) { throw "No folder found in Games\new\`nInstall the new version there first." }
        Log "  Old: $oldGamePath" $cSuccess
        Log "  New: $newGamePath" $cSuccess

        # ── Build all substitution values ──────────────────────────────────
        $patchEngine = if ($cfg.Contains('PATCH_ENGINE'))     { $cfg['PATCH_ENGINE']     } else { "1" }
        $patchExt    = @("xdelta","diff","hdiff")[[int]$patchEngine]
        $genCores    = if ($cfg.Contains('GENERATING_CORES')) { $cfg['GENERATING_CORES'] } else { "23" }
        $appCores    = if ($cfg.Contains('APPLYING_CORES'))   { $cfg['APPLYING_CORES']   } else { "3" }
        $copyright   = if ($cfg.Contains('COPYRIGHT'))        { $cfg['COPYRIGHT']        } else { "" }
        $contact     = if ($cfg.Contains('CONTACT'))          { $cfg['CONTACT']          } else { "" }
        $iconFile    = if ($cfg.Contains('ICON_FILE'))        { $cfg['ICON_FILE']        } else { "icon.ico" }
        $musicRaw    = if ($cfg.Contains('MUSIC_FILE'))       { $cfg['MUSIC_FILE']       } else { "" }
        $skinRaw     = if ($cfg.Contains('SKIN'))             { $cfg['SKIN']             } else { "" }
        $curBtnRaw   = if ($cfg.Contains('CURSOR_BTN'))       { $cfg['CURSOR_BTN']       } else { "" }
        $curFrmRaw   = if ($cfg.Contains('CURSOR_FRM'))       { $cfg['CURSOR_FRM']       } else { "" }

        $patchFilename = "$gameName v$oldBuild-${newBuild}_Update_Patch"
        $uninstallKey  = "${gameName}_is1"
        $silentBuild   = if ($chkSilent.Checked) { "1" } else { "0" }

        $iconPath = Join-Path $oldGamePath $iconFile
        if (-not (Test-Path $iconPath -EA SilentlyContinue)) { $iconPath = "" }

        function Resolve-Or([string]$raw, [string]$fallback) {
            if (-not $raw) { return $fallback }
            $p = Resolve-AssetPath $raw
            if (Test-Path $p -EA SilentlyContinue) { return $p }
            return $fallback
        }
        $skinPath  = Resolve-Or $skinRaw   "Skin disabled"
        $curBtn    = Resolve-Or $curBtnRaw "Cursor disabled"
        $curFrm    = Resolve-Or $curFrmRaw "Cursor disabled"
        $musicFile = if ($musicRaw -and (Test-Path $musicRaw -EA SilentlyContinue)) { $musicRaw } else { "Music disabled" }

        Log "`nSettings:" $cMuted
        Log "  Output:   $patchFilename.exe"
        Log "  Engine:   $(@('XDelta','JDiff','HDiff')[[int]$patchEngine]) ($patchExt)"
        Log "  Cores:    gen=$genCores  apply=$appCores"
        Log "  Silent:   $($chkSilent.Checked)"
        if ($iconPath)                    { Log "  Icon:     $iconPath" }
        if ($skinPath -ne "Skin disabled") { Log "  Skin:     $skinPath" }
        if ($musicFile -ne "Music disabled") { Log "  Music:    $musicFile" }

        # ── Write settings.ini ─────────────────────────────────────────────
        Log "`nWriting settings.ini..." $cMuted
        if (-not (Test-Path $TemplateIni)) { throw "settings_template.ini not found at:`n$TemplateIni" }

        $tpl = Get-Content $TemplateIni -Raw -Encoding UTF8
        $subs = [ordered]@{
            '%OLD_GAME_PATH%'    = $oldGamePath
            '%NEW_GAME_PATH%'    = $newGamePath
            '%GAME_NAME%'        = $gameName
            '%OLD_BUILD%'        = $oldBuild
            '%NEW_BUILD%'        = $newBuild
            '%OLD_RELEASE_NAME%' = $txtOld.Text.Trim()
            '%PATCH_FILENAME%'   = $patchFilename
            '%UNINSTALL_KEY%'    = $uninstallKey
            '%ICON_PATH%'        = $iconPath
            '%OUTPUT_DIR%'       = $OutputDir
            '%PATCH_ENGINE%'     = $patchEngine
            '%PATCH_EXT%'        = $patchExt
            '%GENERATING_CORES%' = $genCores
            '%APPLYING_CORES%'   = $appCores
            '%COPYRIGHT%'        = $copyright
            '%CONTACT%'          = $contact
            '%SKIN_PATH%'        = $skinPath
            '%CURSOR_BTN%'       = $curBtn
            '%CURSOR_FRM%'       = $curFrm
            '%MUSIC_FILE%'       = $musicFile
            '%SILENT_BUILD%'     = $silentBuild
        }
        foreach ($kv in $subs.GetEnumerator()) { $tpl = $tpl.Replace($kv.Key, $kv.Value) }

        $enc   = [System.Text.Encoding]::Unicode
        $bytes = $enc.GetPreamble() + $enc.GetBytes($tpl)
        [System.IO.File]::WriteAllBytes($SettingsIni, $bytes)
        Log "  Done." $cSuccess

        # ── Launch isxpm.exe ───────────────────────────────────────────────
        if (-not (Test-Path $IsxpmExe)) { throw "isxpm.exe not found at:`n$IsxpmExe" }
        New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

        if ($chkSilent.Checked) {
            Log "`nRunning isxpm.exe silently..." $cMuted
            Log "  (if nothing happens after a minute, uncheck Silent build and retry)" $cWarn
            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName         = $IsxpmExe
            $psi.WorkingDirectory = $Root
            $psi.WindowStyle      = [System.Diagnostics.ProcessWindowStyle]::Hidden
            $proc = [System.Diagnostics.Process]::Start($psi)
        } else {
            Log "`nOpening isxpm.exe - build the patch then close the window." $cWarn
            $proc = Start-Process -FilePath $IsxpmExe -WorkingDirectory $Root -PassThru
        }

        while (-not $proc.HasExited) {
            Start-Sleep -Milliseconds 400
            [System.Windows.Forms.Application]::DoEvents()
        }
        Log "  isxpm.exe done (exit $($proc.ExitCode))." $cSuccess

        # ── Zip output ─────────────────────────────────────────────────────
        Log "`nPackaging..." $cMuted
        New-Item -ItemType Directory -Force -Path $UploadDir | Out-Null

        $builtExe = Get-ChildItem $OutputDir -Filter "*.exe" -EA SilentlyContinue |
                    Sort-Object LastWriteTime -Descending | Select-Object -First 1

        if (-not $builtExe) {
            Log "  No .exe found in $OutputDir" $cWarn
            Log "  Build may not have completed - try unchecking Silent build." $cWarn
        } else {
            Log "  Found: $($builtExe.Name)" $cSuccess
            $zipPath = Join-Path $UploadDir "$patchFilename.zip"
            Compress-Archive -Path $builtExe.FullName -DestinationPath $zipPath -Force
            $sizeMB = [Math]::Round((Get-Item $zipPath).Length / 1MB, 2)
            Log "  Created: $zipPath ($sizeMB MB)" $cSuccess

            $btnOpen.BackColor = $cAccent
            $btnOpen.ForeColor = [System.Drawing.Color]::Black
            $btnOpen.FlatAppearance.BorderColor = $cAccent
            $btnOpen.Enabled   = $true
        }

        Log "`n  All done!" $cSuccess

    } catch {
        Log "`nERROR: $_" $cError
        [System.Windows.Forms.MessageBox]::Show($_.ToString(), "Build Failed", "OK", "Error")
    } finally {
        $pbar.MarqueeAnimationSpeed = 0
        $btnBuild.Enabled = $true
    }
})

[void]$form.ShowDialog()
