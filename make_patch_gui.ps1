#Requires -Version 5.1
<#
.SYNOPSIS
    GUI patch builder for AG-ISXPM-Made-Easy.
.DESCRIPTION
    Self-contained WinForms GUI — no extra installs. Launch via
    "Patch Builder.bat" or right-click → Run with PowerShell.
    Enter the two release name strings, click Build. The script
    writes settings.ini, runs isxpm.exe, and zips the output.
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
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

# ── Shared logic (mirrors make_patch.ps1) ──────────────────────────────────────
function Read-IniFile([string]$path) {
    $data = [ordered]@{}
    $section = "_"
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
    if ($release -match '^(.+?)\s+v(\S+?)(\s+.+)?$') {
        return @{
            GameName = $Matches[1].Trim()
            Build    = $Matches[2].Trim()
            Tag      = if ($Matches[3]) { $Matches[3].Trim() } else { "" }
        }
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

# ── Theme ──────────────────────────────────────────────────────────────────────
$cBg      = [System.Drawing.Color]::FromArgb(22,  22,  22)
$cPanel   = [System.Drawing.Color]::FromArgb(34,  34,  34)
$cInput   = [System.Drawing.Color]::FromArgb(44,  44,  44)
$cLog     = [System.Drawing.Color]::FromArgb(12,  12,  12)
$cAccent  = [System.Drawing.Color]::FromArgb(0,   191, 255)
$cText    = [System.Drawing.Color]::FromArgb(220, 220, 220)
$cMuted   = [System.Drawing.Color]::FromArgb(110, 110, 110)
$cSuccess = [System.Drawing.Color]::FromArgb(50,  220, 110)
$cWarn    = [System.Drawing.Color]::FromArgb(255, 165,  0)
$cError   = [System.Drawing.Color]::FromArgb(255,  75,  75)

$fUI    = New-Object System.Drawing.Font("Segoe UI",    9)
$fBold  = New-Object System.Drawing.Font("Segoe UI",   10, [System.Drawing.FontStyle]::Bold)
$fMono  = New-Object System.Drawing.Font("Consolas",    8.5)
$fHint  = New-Object System.Drawing.Font("Segoe UI",    8,  [System.Drawing.FontStyle]::Italic)

# ── Form ───────────────────────────────────────────────────────────────────────
$form = New-Object System.Windows.Forms.Form
$form.Text            = "ARMGDDN Patch Builder"
$form.ClientSize      = New-Object System.Drawing.Size(660, 520)
$form.MinimumSize     = New-Object System.Drawing.Size(660, 558)  # chrome + client
$form.MaximumSize     = $form.MinimumSize
$form.StartPosition   = "CenterScreen"
$form.BackColor       = $cBg
$form.ForeColor       = $cText
$form.Font            = $fUI
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox     = $false

# ── Helper: labelled text field row ───────────────────────────────────────────
function Add-Row {
    param($parent, [string]$labelText, [int]$y, [int]$labelW = 88)
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text      = $labelText
    $lbl.Location  = New-Object System.Drawing.Point(14, ($y + 3))
    $lbl.Size      = New-Object System.Drawing.Size($labelW, 18)
    $lbl.ForeColor = $cMuted
    $lbl.Font      = $fUI
    $parent.Controls.Add($lbl)

    $txt = New-Object System.Windows.Forms.TextBox
    $txt.Location    = New-Object System.Drawing.Point(($labelW + 18), $y)
    $txt.Size        = New-Object System.Drawing.Size((600 - $labelW - 4), 24)
    $txt.BackColor   = $cInput
    $txt.ForeColor   = $cText
    $txt.Font        = $fUI
    $txt.BorderStyle = "FixedSingle"
    $parent.Controls.Add($txt)
    return $txt
}

# ── Input panel ────────────────────────────────────────────────────────────────
$pTop = New-Object System.Windows.Forms.Panel
$pTop.Location  = New-Object System.Drawing.Point(10, 10)
$pTop.Size      = New-Object System.Drawing.Size(640, 152)
$pTop.BackColor = $cPanel
$form.Controls.Add($pTop)

$lblHead = New-Object System.Windows.Forms.Label
$lblHead.Text      = "ARMGDDN Patch Builder"
$lblHead.Location  = New-Object System.Drawing.Point(14, 12)
$lblHead.Size      = New-Object System.Drawing.Size(400, 22)
$lblHead.Font      = $fBold
$lblHead.ForeColor = $cAccent
$pTop.Controls.Add($lblHead)

# Profile dropdown
$lblProf = New-Object System.Windows.Forms.Label
$lblProf.Text      = "Profile:"
$lblProf.Location  = New-Object System.Drawing.Point(14, 47)
$lblProf.Size      = New-Object System.Drawing.Size(88, 18)
$lblProf.ForeColor = $cMuted
$pTop.Controls.Add($lblProf)

$cbProfile = New-Object System.Windows.Forms.ComboBox
$cbProfile.Location      = New-Object System.Drawing.Point(106, 44)
$cbProfile.Size          = New-Object System.Drawing.Size(200, 24)
$cbProfile.BackColor     = $cInput
$cbProfile.ForeColor     = $cText
$cbProfile.DropDownStyle = "DropDownList"
$cbProfile.FlatStyle     = "Flat"
$pTop.Controls.Add($cbProfile)

# Silent build checkbox
$chkSilent = New-Object System.Windows.Forms.CheckBox
$chkSilent.Text      = "Silent build  (isxpm auto-starts — uncheck if it doesn't work)"
$chkSilent.Location  = New-Object System.Drawing.Point(320, 46)
$chkSilent.Size      = New-Object System.Drawing.Size(310, 20)
$chkSilent.Checked   = $true
$chkSilent.ForeColor = $cMuted
$chkSilent.Font      = $fUI
$pTop.Controls.Add($chkSilent)

# Release name fields
$txtOld = Add-Row $pTop "Old release:" 78
$txtNew = Add-Row $pTop "New release:" 110

$lblHint = New-Object System.Windows.Forms.Label
$lblHint.Text      = "Format:  Game Name vBUILD_NUMBER -TAG   e.g.  S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340 -ARMGDDN"
$lblHint.Location  = New-Object System.Drawing.Point(14, 140)
$lblHint.Size      = New-Object System.Drawing.Size(618, 16)
$lblHint.ForeColor = $cMuted
$lblHint.Font      = $fHint
$pTop.Controls.Add($lblHint)

# ── Log / status area ──────────────────────────────────────────────────────────
$rtbLog = New-Object System.Windows.Forms.RichTextBox
$rtbLog.Location    = New-Object System.Drawing.Point(10, 172)
$rtbLog.Size        = New-Object System.Drawing.Size(640, 272)
$rtbLog.BackColor   = $cLog
$rtbLog.ForeColor   = $cText
$rtbLog.Font        = $fMono
$rtbLog.ReadOnly    = $true
$rtbLog.BorderStyle = "None"
$rtbLog.ScrollBars  = "Vertical"
$form.Controls.Add($rtbLog)

# ── Progress bar ──────────────────────────────────────────────────────────────
$pbar = New-Object System.Windows.Forms.ProgressBar
$pbar.Location = New-Object System.Drawing.Point(10, 452)
$pbar.Size     = New-Object System.Drawing.Size(640, 12)
$pbar.Style    = "Marquee"
$pbar.MarqueeAnimationSpeed = 0
$form.Controls.Add($pbar)

# ── Buttons ───────────────────────────────────────────────────────────────────
$btnBuild = New-Object System.Windows.Forms.Button
$btnBuild.Text      = "▶  Build Patch"
$btnBuild.Location  = New-Object System.Drawing.Point(430, 472)
$btnBuild.Size      = New-Object System.Drawing.Size(110, 36)
$btnBuild.BackColor = $cAccent
$btnBuild.ForeColor = [System.Drawing.Color]::Black
$btnBuild.Font      = $fBold
$btnBuild.FlatStyle = "Flat"
$btnBuild.FlatAppearance.BorderSize = 0
$form.Controls.Add($btnBuild)

$btnOpen = New-Object System.Windows.Forms.Button
$btnOpen.Text      = "Open Output"
$btnOpen.Location  = New-Object System.Drawing.Point(548, 472)
$btnOpen.Size      = New-Object System.Drawing.Size(102, 36)
$btnOpen.BackColor = $cPanel
$btnOpen.ForeColor = $cMuted
$btnOpen.Font      = $fUI
$btnOpen.FlatStyle = "Flat"
$btnOpen.FlatAppearance.BorderSize  = 1
$btnOpen.FlatAppearance.BorderColor = $cMuted
$btnOpen.Enabled   = $false
$form.Controls.Add($btnOpen)

# ── Log helper ─────────────────────────────────────────────────────────────────
function Log {
    param([string]$msg, [System.Drawing.Color]$color)
    if (-not $color) { $color = $cText }
    $rtbLog.SelectionStart  = $rtbLog.TextLength
    $rtbLog.SelectionLength = 0
    $rtbLog.SelectionColor  = $color
    $rtbLog.AppendText("$msg`n")
    $rtbLog.SelectionColor  = $cText
    $rtbLog.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

# ── Load profiles on startup ───────────────────────────────────────────────────
$script:iniData = $null

if (-not (Test-Path $ConfigIni)) {
    [System.Windows.Forms.MessageBox]::Show(
        "game_config.ini not found in:`n$Root",
        "Config Missing", "OK", "Warning")
} else {
    try {
        $script:iniData = Read-IniFile $ConfigIni
        $profiles = @($script:iniData.Keys | Where-Object { $_ -notin @('DEFAULT','_') })
        foreach ($p in $profiles) { [void]$cbProfile.Items.Add($p) }
        if ($cbProfile.Items.Count -gt 0) { $cbProfile.SelectedIndex = 0 }
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to load game_config.ini:`n$_",
            "Error", "OK", "Error")
    }
}

# ── Open Output button ────────────────────────────────────────────────────────
$btnOpen.Add_Click({
    if (Test-Path $UploadDir) { Start-Process explorer.exe $UploadDir }
})

# ── Build button ──────────────────────────────────────────────────────────────
$btnBuild.Add_Click({
    # ── Validate inputs ────────────────────────────────────────────────────
    if ($cbProfile.SelectedItem -eq $null) {
        [System.Windows.Forms.MessageBox]::Show("Select a game profile.", "Missing", "OK", "Warning"); return
    }
    if ([string]::IsNullOrWhiteSpace($txtOld.Text) -or [string]::IsNullOrWhiteSpace($txtNew.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Enter both release name strings.", "Missing", "OK", "Warning"); return
    }

    # ── Lock UI ────────────────────────────────────────────────────────────
    $btnBuild.Enabled = $false
    $btnOpen.Enabled  = $false
    $rtbLog.Clear()
    $pbar.MarqueeAnimationSpeed = 30

    try {
        # ── Parse release names ────────────────────────────────────────────
        Log "Parsing release names..." $cMuted
        $old = Parse-ReleaseName $txtOld.Text.Trim()
        $new = Parse-ReleaseName $txtNew.Text.Trim()
        if (-not $old) { throw "Cannot parse old release name.`nExpected:  Game Name vBUILD -TAG" }
        if (-not $new) { throw "Cannot parse new release name.`nExpected:  Game Name vBUILD -TAG" }

        $gameName = $old.GameName
        $oldBuild = $old.Build
        $newBuild = $new.Build

        Log "  Game:      $gameName" $cAccent
        Log "  Old build: $oldBuild"
        Log "  New build: $newBuild"

        # ── Merge config ───────────────────────────────────────────────────
        $profileKey = $cbProfile.SelectedItem.ToString()
        $cfg = [ordered]@{}
        if ($script:iniData.Contains('DEFAULT')) {
            foreach ($k in $script:iniData['DEFAULT'].Keys) { $cfg[$k] = $script:iniData['DEFAULT'][$k] }
        }
        if ($script:iniData.Contains($profileKey)) {
            foreach ($k in $script:iniData[$profileKey].Keys) { $cfg[$k] = $script:iniData[$profileKey][$k] }
        }

        # ── Detect game folders ────────────────────────────────────────────
        Log "`nDetecting game folders..." $cMuted
        $oldGamePath = Find-GameFolder $GamesOldDir $gameName
        $newGamePath = Find-GameFolder $GamesNewDir $gameName
        if (-not $oldGamePath) { throw "No folder found in Games\old\`nInstall the old game version there first." }
        if (-not $newGamePath) { throw "No folder found in Games\new\`nInstall the new game version there first." }
        Log "  Old: $oldGamePath" $cSuccess
        Log "  New: $newGamePath" $cSuccess

        # ── Build all values ───────────────────────────────────────────────
        $patchEngine = if ($cfg.Contains('PATCH_ENGINE'))      { $cfg['PATCH_ENGINE']      } else { "1" }
        $patchExt    = @("xdelta","diff","hdiff")[[int]$patchEngine]
        $genCores    = if ($cfg.Contains('GENERATING_CORES'))  { $cfg['GENERATING_CORES']  } else { "23" }
        $appCores    = if ($cfg.Contains('APPLYING_CORES'))    { $cfg['APPLYING_CORES']    } else { "3" }
        $copyright   = if ($cfg.Contains('COPYRIGHT'))         { $cfg['COPYRIGHT']         } else { "" }
        $contact     = if ($cfg.Contains('CONTACT'))           { $cfg['CONTACT']           } else { "" }
        $iconFile    = if ($cfg.Contains('ICON_FILE'))         { $cfg['ICON_FILE']         } else { "icon.ico" }
        $musicRaw    = if ($cfg.Contains('MUSIC_FILE'))        { $cfg['MUSIC_FILE']        } else { "" }
        $skinRaw     = if ($cfg.Contains('SKIN'))              { $cfg['SKIN']              } else { "" }
        $curBtnRaw   = if ($cfg.Contains('CURSOR_BTN'))        { $cfg['CURSOR_BTN']        } else { "" }
        $curFrmRaw   = if ($cfg.Contains('CURSOR_FRM'))        { $cfg['CURSOR_FRM']        } else { "" }

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
        Log "  Output:  $patchFilename.exe"
        Log "  Engine:  $(@('XDelta','JDiff','HDiff')[[int]$patchEngine]) ($patchExt)"
        Log "  Cores:   gen=$genCores  apply=$appCores"
        Log "  Silent:  $($chkSilent.Checked)"

        # ── Write settings.ini ─────────────────────────────────────────────
        Log "`nWriting settings.ini..." $cMuted
        if (-not (Test-Path $TemplateIni)) { throw "settings_template.ini not found." }

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
        Log "  Done: $SettingsIni" $cSuccess

        # ── Launch isxpm.exe ───────────────────────────────────────────────
        if (-not (Test-Path $IsxpmExe)) { throw "isxpm.exe not found at:`n$IsxpmExe" }
        New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

        if ($chkSilent.Checked) {
            Log "`nRunning isxpm.exe silently..." $cMuted
            Log "  (if a window opens anyway, build and close it)" $cWarn
            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName         = $IsxpmExe
            $psi.WorkingDirectory = $Root
            $psi.WindowStyle      = [System.Diagnostics.ProcessWindowStyle]::Hidden
            $proc = [System.Diagnostics.Process]::Start($psi)
        } else {
            Log "`nLaunching isxpm.exe — build the patch then close it." $cWarn
            $proc = Start-Process -FilePath $IsxpmExe -WorkingDirectory $Root -PassThru
        }

        # Wait without blocking the UI
        while (-not $proc.HasExited) {
            Start-Sleep -Milliseconds 400
            [System.Windows.Forms.Application]::DoEvents()
        }
        Log "  isxpm.exe finished (exit code $($proc.ExitCode))." $cSuccess

        # ── Zip output ────────────────────────────────────────────────────
        Log "`nPackaging output..." $cMuted
        New-Item -ItemType Directory -Force -Path $UploadDir | Out-Null

        $builtExe = Get-ChildItem $OutputDir -Filter "*.exe" -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending | Select-Object -First 1

        if (-not $builtExe) {
            Log "  No .exe found in $OutputDir" $cWarn
            Log "  The build may not have completed — check isxpm.exe output." $cWarn
        } else {
            Log "  Found: $($builtExe.Name)" $cSuccess
            $zipPath = Join-Path $UploadDir "$patchFilename.zip"
            Compress-Archive -Path $builtExe.FullName -DestinationPath $zipPath -Force
            $sizeMB  = [Math]::Round((Get-Item $zipPath).Length / 1MB, 2)
            Log "  Zipped: $zipPath ($sizeMB MB)" $cSuccess

            # Light up the Open Output button
            $btnOpen.BackColor = $cAccent
            $btnOpen.ForeColor = [System.Drawing.Color]::Black
            $btnOpen.FlatAppearance.BorderColor = $cAccent
            $btnOpen.Enabled   = $true
        }

        Log "`n✓ All done!" $cSuccess

    } catch {
        Log "`nERROR: $_" $cError
        [System.Windows.Forms.MessageBox]::Show($_.ToString(), "Build Failed", "OK", "Error")
    } finally {
        $pbar.MarqueeAnimationSpeed = 0
        $btnBuild.Enabled = $true
    }
})

# ── Show form ─────────────────────────────────────────────────────────────────
[void]$form.ShowDialog()
