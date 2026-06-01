; BEGIN ISPPBUILTINS.ISS
; END ISPPBUILTINS.ISS
;Inno Setup XDELTA Patch Application 2.6.4.4
;Unicode version of Inno Setup 5.6.1 is required
;Maded by Kindly
[Setup]
AppName=S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340-22554680 Update Patch
AppVerName=1.0.0.0 
DefaultDirName={tmp}
AppCopyright=ARMGDDN Games ™
VersionInfoCompany=ARMGDDN Games ™
VersionInfoDescription=REQUIRES: S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340 -ARMGDDN
VersionInfoVersion=1.0.0.0
OutputBaseFilename=S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340-22554680_Update_Patch
OutputDir=D:\XDelta\ISXPMPatch\
WizardImageFile=Empty.bmp
WizardSmallImageFile=Empty.bmp
SetupIconFile=D:\XDelta\Games\old\S.T.A.L.K.E.R. 2 - Heart of Chornobyl\icon.ico
PrivilegesRequired=admin
SolidCompression=yes
Compression=lzma2/ultra64
DiskSpanning=yes
ArchitecturesInstallIn64BitMode=x64 ia64
[Messages]
SetupAppTitle=S.T.A.L.K.E.R. 2 - Heart of Chornobyl Update Patch
[LangOptions]
;Compatibled fonts
;Arial
;Courier New
;Lucida Console
;MS Sans Serif
;Tahoma
;Times New Roman
;Verdana
DialogFontName=Tahoma                                          
DialogFontSize=8               
[Files]
; always put checker file before all other files
Source: D:\XDelta\checker\8a6317b0\Checker.ini; DestDir: {tmp}; Flags: dontcopy; 
Source: InnoCallback.dll; DestDir: {tmp}; Flags: dontcopy;
Source: isproc.dll; DestDir: {tmp}; Flags: dontcopy;
  Source: wintb.dll; Flags: dontcopy;
  Source: C:\Users\SKYNET~1\AppData\Local\Temp\is-90QML.tmp\English.ini; DestDir: {tmp}; Flags: dontcopy;
  Source: VclStylesinno.dll; DestDir: {tmp}; Flags: dontcopy;
  Source: D:\XDelta\resources\styles\vcl\Carbon.vsf; DestDir: {tmp}; Flags: dontcopy;
  Source: D:\XDelta\resources\cursors\button\b7.ani; DestDir: {tmp}; Flags: dontcopy;
  Source: D:\XDelta\resources\cursors\form\f7.ani; DestDir: {tmp}; Flags: dontcopy;
  Source: bass.dll; DestDir: {tmp}; Flags: dontcopy;
  Source: D:\Repos\ARMGDDN Repacks\Setup\Music.mp3; DestDir: {tmp}; Flags: dontcopy;
Source: crc32c.dll; DestDir: {tmp}; Flags: dontcopy;
Source: jptch-x86.exe; DestDir: {tmp}; Flags: dontcopy;
Source: jptch-x64.exe; DestDir: {tmp}; Flags: dontcopy;
Source: D:\XDelta\xdata\8a6317b0\*; DestDir: PatchData; Flags: ignoreversion recursesubdirs createallsubdirs dontcopy;
[Code]
const
  GCL_HCURSOR   = (-12);
  OCR_NORMAL    = 32512;
  AW_SLIDE_IN_LEFT = $00040001;
  AW_SLIDE_IN_RIGHT = $00040002;
  AW_SLIDE_IN_TOP = $00040004;
  AW_SLIDE_IN_BOTTOM = $00040008;
  AW_DIAG_SLIDE_IN_TOPLEFT = $00040005;
  AW_DIAG_SLIDE_IN_TOPRIGHT = $00040006;
  AW_DIAG_SLIDE_IN_BOTTOMLEFT = $00040009;
  AW_DIAG_SLIDE_IN_BOTTOMRIGHT = $0004000a;
  AW_HOR_POSITIVE = $00000001;
  AW_VER_POSITIVE = $00000004;
  AW_EXPLODE = $00040010;
  AW_SLIDE_OUT_LEFT = $00050002;
  AW_SLIDE_OUT_RIGHT = $00050001;
  AW_SLIDE_OUT_TOP = $00050008;
  AW_SLIDE_OUT_BOTTOM = $00050004;
  AW_DIAG_SLIDE_OUT_TOPLEFT = $0005000a;
  AW_DIAG_SLIDE_OUT_TOPRIGHT = $00050009;
  AW_DIAG_SLIDE_OUT_BOTTOMLEFT = $00050006;
  AW_DIAG_SLIDE_OUT_BOTTOMRIGHT = $00050005;
  AW_HOR_NEGATIVE = $00000002;
  AW_VER_NEGATIVE = $00000008;
  AW_IMPLODE = $00050010;
  AW_BLEND = $00080000; 
  AW_ACTIVATE = $00020000;
  AW_HIDE = $00010000;
type
  TProc=procedure(HandleW, msg, idEvent, TimeSys: longword);
  TTimerProc=procedure(h:longword; msg:longword; idevent:longword; dwTime:longword);
function FindWindow(ClassName, WindowName: String): HWnd; 
external 'FindWindowW@user32.dll stdcall';
function ShowWindow(hWnd: HWND; uType: Integer): BOOL;
external 'ShowWindow@user32.dll stdcall';
function FlashWindow(hWnd: HWND; bInvert: Bool): Bool;
external 'FlashWindow@user32.dll stdcall';
procedure WintbStart(); 
external 'WintbStart@files:wintb.dll cdecl';
procedure WintbStop(); 
external 'WintbStop@files:wintb.dll cdecl';
procedure SetTaskBarProgressValue(Value: Longint); 
external 'SetTaskBarProgressValue@files:wintb.dll cdecl';
procedure SetTaskBarProgressState(Value: Longint); 
external 'SetTaskBarProgressState@files:wintb.dll cdecl';
function SetForegroundWindow(HW: HWND): Bool;
external 'SetForegroundWindow@user32.dll stdcall';
procedure LoadVCLStyle(VClStyleFile: String); 
external 'LoadVCLStyleW@files:VclStylesInno.dll stdcall';
procedure UnLoadVCLStyles; 
external 'UnLoadVCLStyles@files:VclStylesInno.dll stdcall';
function WrapTimerProc(callback:TTimerProc; paramcount:integer):longword;
external 'wrapcallback@files:innocallback.dll stdcall';
function WrapTProc(tcallback:TProc; paramcount:integer):longword;
external 'wrapcallback@files:innocallback.dll stdcall';
function SetTimer(hWnd: longword; nIDEvent, uElapse: longword; lpTimerFunc: longword): longword;
external 'SetTimer@user32.dll stdcall';
function KillTimer(hWnd: LongWord; nIDEvent: LongWord): LongWord;
external 'KillTimer@user32.dll stdcall';
function GetTickCount: Dword; 
external 'GetTickCount@kernel32.dll stdcall';
function LoadCursorFromFile(FileName: String): Longint;
external 'LoadCursorFromFileW@user32 stdcall';
function SetClassLong(hWnd: HWND; Index, NewLong: Longint): Longint;
external 'SetClassLongW@user32 stdcall';
function SetSystemCursor(Cursor, CurType: Longint): Longint;
external 'SetSystemCursor@user32 stdcall';
function BASS_Init(device: longint; freq, flags: DWORD; win: hwnd; CLSID: Longint): Boolean;
external 'BASS_Init@files:BASS.dll stdcall';
function BASS_Start(): Boolean;
external 'BASS_Start@files:BASS.dll stdcall';
function BASS_StreamCreateFile(mem: BOOL; f: PAnsiChar; offset, length: Int64; flags: DWORD): HWND;
external 'BASS_StreamCreateFile@files:BASS.dll stdcall';
function BASS_ChannelPlay(handle: DWORD; restart: BOOL): Boolean;
external 'BASS_ChannelPlay@files:BASS.dll stdcall';
function BASS_ChannelPause(handle: DWORD): BOOLEAN;
external 'BASS_ChannelPause@files:BASS.dll stdcall';
function  BASS_Stop(): Boolean;
external 'BASS_Stop@files:BASS.dll stdcall';
function  BASS_Free(): Boolean;
external 'BASS_Free@files:BASS.dll stdcall';
function BASS_ChannelSetAttribute(handle, attrib: DWORD; value: single): BOOL;
external 'BASS_ChannelSetAttribute@BASS.dll stdcall'; 
function BASS_ChannelGetAttribute(handle, attrib: DWORD; var value: single): BOOL;
external 'BASS_ChannelGetAttribute@BASS.dll stdcall'; 
const
  BAK_DIR = '\Backup';
  GENERIC_WRITE       = $40000000;
  GENERIC_EXECUTE     = $20000000;
  GENERIC_ALL         = $10000000;
  FILE_SHARE_READ     = 1;
  FILE_SHARE_WRITE    = 2;
  FILE_SHARE_DELETE   = 4;
  CREATE_NEW          = 1;
  CREATE_ALWAYS       = 2;
  OPEN_EXISTING       = 3;
  OPEN_ALWAYS         = 4;
  TRUNCATE_EXISTING   = 5;
  INVALID_HANDLE_VALUE = (-1);
  SW_RESTORE          = 9;
  PROGRESS_CONTINUE = 0;
  PROGRESS_CANCEL = 1;
  CALLBACK_CHUNK_FINISHED = $0;
{
  PAGE_READONLY = $0002;
  FILE_MAP_READ = $0004;
  HEAP_ZERO_MEMORY = $0008;
  FILE_FLAG_SEQUENTIAL_SCAN = $08000000;
}
type
  PLARGE_INTEGER = record
  QuadPart: Int64;
end; 
type 
  TMyMsg = record hWnd: HWND; msg, wParam: Word; lParam: LongWord; Time: TFileTime; pt: TPoint; end;
type 
  EnumCopyCallback=function(TotalFileSizeLo, TotalFileSizeHi, TotalBytesTransferredLo, TotalBytesTransferredHi, StreamSizeLo, StreamSizeHi, StreamBytesTransferredLo, StreamBytesTransferredHi: Longint; dwStreamNumber, dwCallbackReason: DWORD; hSourceFile, hDestinationFile: THandle; lpData: Longint): DWORD;
type
{ typedef struct _PROCESS_INFORMATION ... PROCESS_INFORMATION, *LPPROCESS_INFORMATION; }
TProcessInfo = record
  hProcess:DWORD;
  hThread:DWORD;
  dwProcessId:DWORD;
  dwThreadId:DWORD;
end;
  { typedef struct _STARTUPINFOA ... STARTUPINFOA, *LPSTARTUPINFOA; }
TStartupInfo = record
  cb:DWORD;
  lpReserved:DWORD; // not PChar; - need NULL pointer
  lpDesktop:DWORD;  // not PChar; - need NULL pointer
  lpTitle:DWORD;  // not PChar; - need NULL pointer
  dwX:DWORD;
  dwY:DWORD;
  dwXSize:DWORD;
  dwYSize:DWORD;
  dwXCountChars:DWORD;
  dwYCountChars:DWORD;
  dwFillAttribute:DWORD;
  dwFlags:DWORD;
  wShowWindow:WORD;
  cbReserved2:WORD;
  lpReserved2:DWORD;
  hStdInput:DWORD;
  hStdOutput:DWORD;
  hStdError:DWORD;
end;
function WrapMyCopyCallback(copycallback:EnumCopyCallback; paramcount:integer):longword;
external 'wrapcallback@files:innocallback.dll stdcall';
function CopyFileEx(lpExistingFileName, lpNewFileName: String; lpProgressRoutine, lpData: Longword; var pbCancel: BOOL; dwCopyFlags: DWORD): BOOL; 
external 'CopyFileExW@kernel32.dll stdcall';
function PathIsDirectory(pszPath: String): BOOL; 
external 'PathIsDirectoryW@shlwapi.dll stdcall';
function GetFileAttributes(lpFileName: String): DWORD;
external 'GetFileAttributesW@kernel32.dll stdcall';
function SetFileAttributes(lpFileName: String; dwFileAttributes: DWORD): BOOL;
external 'SetFileAttributesW@kernel32.dll stdcall';
function MoveFileEx(lpExistingFileName, lpNewFileName: String; dwFlags: DWORD): BOOL;
external 'MoveFileExW@kernel32.dll stdcall';
function CreateFile(lpFileName: String; dwDesiredAccess: DWORD; dwShareMode: DWORD; lpSecurityAttributes: DWORD; dwCreationDisposition: DWORD; dwFlagsAndAttributes: DWORD; hTemplateFile: THandle): THandle;
external 'CreateFileW@kernel32.dll stdcall';
function CloseHandle(hObject: THandle): BOOL;
external 'CloseHandle@kernel32.dll stdcall';
function CreateProcess(lpApplicationName: String; lpCommandLine: string; lpProcAttrib,lpThreadAttrib: DWORD; bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment:DWORD; lpCurrentDirectory: String; var lpStartupInfo:TStartupInfo; var lpProcessInfo:TProcessInfo): Integer;
external 'CreateProcessW@kernel32.dll stdcall';
function GetExitCodeProcess(hProcess:THandle; var lpExitCode:DWORD):Integer;
external 'GetExitCodeProcess@kernel32.dll stdcall';
function WaitForSingleObject(hHandle: THandle; dwMilliseconds: DWORD): DWORD; 
external 'WaitForSingleObject@kernel32.dll stdcall';
function WaitForInputIdle(hProcess: THandle; dwMilliseconds: DWORD): DWORD; 
external 'WaitForInputIdle@user32.dll stdcall';
function PeekMessage(var lpMsg: TMyMsg; hWnd: HWND; wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT): BOOL; 
external 'PeekMessageW@user32.dll stdcall';
function TranslateMessage(const lpMsg: TMyMsg): BOOL; 
external 'TranslateMessage@user32.dll stdcall';
function DispatchMessage(const lpMsg: TMyMsg): Longint; 
external 'DispatchMessageW@user32.dll stdcall';
function AnimateWindow(hWnd: HWND; dwTime: DWORD; dwFlags: DWORD): Bool;
external 'AnimateWindow@user32 stdcall';
function GetCRC32OfFile(FilePath: String): Cardinal;                    
external 'GetCRC32OfFile@files:crc32c.dll stdcall'; 
{
function RtlComputeCrc32(dwInitial: Cardinal; const pData: Longint; iLen: Integer): Cardinal; 
external 'RtlComputeCrc32@ntdll.dll stdcall';
function ReadFile(hFile: THandle; lpBuffer: Longint; nNumberOfBytesToRead: DWORD; var lpNumberOfBytesRead: DWORD; lpOverlapped: Longint): BOOL; 
external 'ReadFile@kernel32.dll stdcall';
function GetProcessHeap: THandle; 
external 'GetProcessHeap@kernel32.dll stdcall';
function HeapAlloc(hHeap: THandle; dwFlags, dwBytes: DWORD): Longint; 
external 'HeapAlloc@kernel32.dll stdcall';
function HeapSize(hHeap: THandle; dwFlags: DWORD; lpMem: Longint): DWORD; 
external 'HeapSize@kernel32.dll stdcall';
function HeapFree(hHeap: THandle; dwFlags: DWORD; lpMem: Longint): BOOL; 
external 'HeapFree@kernel32.dll stdcall';
}
{
function GetFileSizeEx(hFile: THANDLE; out lpFileSize: PLARGE_INTEGER): BOOL;
external 'GetFileSizeEx@kernel32.dll stdcall';
}
function IsProcessRunning(exename: ansistring): Integer; 
external 'IsProcessRunning@files:isproc.dll stdcall';
type
TSystemInfo = record
  wProcessorArchitecture: Word;
  wReserved: Word;
  dwPageSize: DWORD;
  lpMinimumApplicationAddress: Integer;
  lpMaximumApplicationAddress: Integer;
  dwActiveProcessorMask: DWORD;
  dwNumberOfProcessors: DWORD;
  dwProcessorType: DWORD;
  dwAllocationGranularity: DWORD;
  wProcessorLevel: Integer;
  wProcessorRevision: Word;
end;
procedure GetSystemInfo(var lpSystemInfo: TSystemInfo); 
external 'GetSystemInfo@kernel32.dll stdcall';
type
  FILETIME = record
    dwLowDateTime, dwHighDateTime: DWORD;
  end;
  WIN32_FILE_ATTRIBUTE_DATA = record
    dwFileAttributes: DWORD;
    ftCreationTime, ftLastAccessTime, ftLastWriteTime: FILETIME;
    nFileSizeHigh, nFileSizeLow: DWORD;
  end;
function GetFileAttributesEx(lpFileName: String; fInfoLevelId: DWORD; var lpFileInformation: WIN32_FILE_ATTRIBUTE_DATA): BOOL; 
external 'GetFileAttributesExW@kernel32.dll stdcall';
var
  m,z,pCount,oCount,iCount,v,t,j: Cardinal;
  tp,tc,dz: Cardinal;
  tf: String;
  pProcessInfo: Array of TProcessInfo;
  jCount: Cardinal;
  jdCount: Cardinal;
  PatchingError,bkp: ShortInt;
  bCancel: BOOL;  
  cores,corcnt,i: Integer;
  copycallback: LongWord;
  srcFile,destFile,ResultStr: String;
  basePath,t_basePath,b_basePath,ini,PatchEngine,EngineParam: string;
  BACKUP_DIR: String;
  key_cur: Int64;
  init_key_chk: shortint;
  sLang: String;
  ExitButton,StartButton,BrowseButton,InfoButton: TButton;
  MusicButton,MusicButton1,MusicButton2: TButton;
  Form: TSetupForm;
  cb_bak,cb_log,cb_vh: TCheckBox;
  oDir: TEdit;
  pLog,xInfo: TMemo;
  pInfo: TMemo;
  cStr,pStr,bStr,lStr,iStr,dStr,mStr,vStr,SiteLabel: TLabel;
  ProgressBar: TNewProgressBar;
  UserSelectDir,Lang,Lang2,Lang3,Lang4: String;
  Panel: TPanel;
  MouseLabel: TLabel;
  HW: HWND;
  OldCursor,NewCursor,NewCursorForm: Longint;
  Song: String;
  hMus: DWORD;
  fpfunc,fTimerID: LongWord;
  tfunc,tTimerID:longword;
  Elapsed,Start,Stop:int64;
  pfunc,sTimerID: LongWord;
  rStr: TLabel;
  X,RL: Integer;
  BitmapImage: TBitmapImage;
function FormatTime(time: int64): string;
 var
  Ms : Int64;
  H, M, S : Integer;
begin
  Ms := time;
  H := Ms div (60 * 60 * 1000);
  Ms := Ms mod (60 * 60 * 1000); 
  M := Ms div (60 * 1000);
  Ms := Ms mod (60 * 1000); 
  S := Ms div 1000;
  Ms := Ms mod 1000; 
  Result := Format('%.2dh:%.2dm:%.2ds:%.3dms',[H,M,S,Ms]);
end;  
procedure tTimer(h: Longword; msg: Longword; idevent: Longword; dwTime: Longword);
begin
  Stop:=GetTickCount;
  Elapsed:=Stop-Start;
  Lang := GetIniString('ISPATCH', 'PATCHING_PROCESS', 'Patching process, please wait...', sLang);
  xInfo.Text := Lang + #13#10 + FormatTime(Elapsed);
  xInfo.Update;
end;
procedure OnTimer(HandleW, msg, idEvent, TimeSys: LongWord);
begin
  X := X - 1;
  rStr.Left := X + Form.Width;  
  if X <= -Form.Width-rStr.Width then
  X := 0;
end;
procedure StringTimer;
begin
  pfunc:= WrapTimerProc(@OnTimer, 4);
  sTimerID:= SetTimer(0, 0, 28, pfunc);
end;
function GetCPUCores(): Integer;
var
  SysInfo: TSystemInfo;
begin
  GetSystemInfo(SysInfo);  	
  Result := SysInfo.dwNumberOfProcessors;
end;
procedure AppProcessMessage;
var
  Msg: TMyMsg;
begin
  while PeekMessage(Msg, 0, 0, 0, 1) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;
procedure Finish(HandleW, msg, idEvent, TimeSys: LongWord);
begin
  FlashWindow(HW, True); 
  FlashWindow(HW, False); 
  if Form.Active then
  begin
    KillTimer(0, fTimerID);
    SetForegroundWindow(HW);  
    FlashWindow(HW, False);
  end;  
end;
procedure FlashTimer;
begin
  HW := FindWindow('TApplication','S.T.A.L.K.E.R. 2 - Heart of Chornobyl Update Patch');
  fpfunc:= WrapTimerProc(@Finish, 4);
  fTimerID:= SetTimer(0, 0, 1000, fpfunc);
end;
procedure SiteLabelOnClick(Sender: TObject); var ErrorCode: Integer;
begin
  ShellExec('open', 't.me/ARMGDDNGames', '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode)
end;
procedure SiteLabelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;
procedure SiteLabelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  SiteLabel.Font.Style := SiteLabel.Font.Style - [fsUnderline];
end;
procedure SiteLabelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  SiteLabel.Font.Style := SiteLabel.Font.Style + [fsUnderline];
end;
procedure SiteLabelMouseMove2(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  SiteLabel.Font.Style := SiteLabel.Font.Style - [fsUnderline];
end;
{
function GetCRC32OfFile(FileName: string): Cardinal;
var
  hFile, hHeap: THandle;
  lpBuffer: Longint;
  dwBufferSize, dwRead: DWORD;
begin
  Result := 0;
  hFile := CreateFile(FileName, $80000000, FILE_SHARE_READ, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if hFile = INVALID_HANDLE_VALUE then Exit;
  try
    hHeap := GetProcessHeap;
    if hHeap = 0 then Exit;
    lpBuffer := HeapAlloc(hHeap, HEAP_ZERO_MEMORY, 32*1024);
    if lpBuffer = 0 then Exit;
    dwBufferSize := HeapSize(hHeap, 0, lpBuffer);
    if dwBufferSize = 0 then Exit;
    while ReadFile(hFile, lpBuffer, dwBufferSize, dwRead, 0) and BOOL(dwRead > 0) do
    begin
      AppProcessMessage;  
      Result := RtlComputeCrc32(Result, lpBuffer, dwRead);
    end;
  finally
    if hHeap <> 0 then
      HeapFree(hHeap, 0, lpBuffer);
    CloseHandle(hFile);
  end;
end;
}
function CreateAppProcess(appName, commandLine: String; var pProcessInfo:TProcessInfo):Boolean;
var 
  xStartInfo:TStartupInfo;
  bExecuted:Integer;
begin
  xStartInfo.dwFlags := $00000001;                    
  xStartInfo.wShowWindow:=SW_HIDE;
  xStartInfo.cb := sizeof(xStartInfo);
  bExecuted := CreateProcess('' , appName + ' ' + commandLine, 0, 0, True, 0, 0, '', xStartInfo, pProcessInfo);
  if bExecuted = 0 then
  Result := false else
  Result := true;
end;
{
function GetAppExitCodeProcess(ProcInfo:TProcessInfo):DWORD;
var 
  dwExitCode:DWORD;
begin
  if GetExitCodeProcess(ProcInfo.hProcess, dwExitCode) = 0 then
  RaiseException('Function GetExitCodeProcess returned FALSE. This indicates a bug in the script! Please report this error to the author!')
  else
  Result := dwExitCode;
end;
}
function CloseProcessHandles(ProcInfo:TProcessInfo):Bool;
begin
  Result := False;
  WaitForInputIdle(ProcInfo.hProcess, DWORD($FFFFFFFF));
  WaitforSingleObject(ProcInfo.hProcess, DWORD($FFFFFFFF));
  if CloseHandle(ProcInfo.hThread) and CloseHandle(ProcInfo.hProcess) then
  Result := True;
end;
function ExtendPath(exPath: String): String;
begin
  if Length(exPath) > 259 then
  if Pos('\\?\',exPath) = 0 then
  exPath := '\\?\' + exPath;
  Result := exPath;
end;
function Size64(LowPart: Longint; HighPart: DWORD): Extended;
begin
  Result := (HighPart + integer(LowPart < 0))*4.294967296E9 + LowPart;
end;
function FileSizeEx(Filename: String): Int64;
var
  lpFileInformation: WIN32_FILE_ATTRIBUTE_DATA;
begin
  Result:=0;
  if FileExists(ExpandConstant(Filename)) then
  begin
    if GetFileAttributesEx(ExpandConstant(Filename), $0, lpFileInformation) then
    Result := lpFileInformation.nFileSizeLow or (lpFileInformation.nFileSizeHigh shl 32);
  end;
end;
{
function FileSizeEx(FileName: String): Int64;
var
  hFile: THandle;  
  lpFileSize: PLARGE_INTEGER;
begin
  Result := 0;
    hFile := CreateFile(FileName,$80000000,FILE_SHARE_READ,0,OPEN_EXISTING,0,0);
    if (INVALID_HANDLE_VALUE = hFile) then
    begin
      CloseHandle(hFile);
      Exit;
    end;
    if GetFileSizeEx(hFile, lpFileSize) then
    Result := lpFileSize.QuadPart;
  CloseHandle(hFile); 
end;
}
procedure WriteUnicode(sFile,uText: String);
var
  Stream: TFileStream;
begin
  SaveStringToFile(sFile, Chr($FF)+Chr($FE),False); 
  Stream := TFileStream.Create(sFile, fmOpenWrite);
  try      
    Stream.Seek(2, soFromBeginning);
    Stream.WriteBuffer(uText,Length(uText)*2);
  finally
    Stream.Free;
  end;
end;
function CopyProgressRoutine(TotalFileSizeLo, TotalFileSizeHi, TotalBytesTransferredLo, TotalBytesTransferredHi, StreamSizeLo, StreamSizeHi, StreamBytesTransferredLo, StreamBytesTransferredHi: Longint; dwStreamNumber, dwCallbackReason: DWORD; hSourceFile, hDestinationFile: THandle; lpData: Longint): DWORD;
begin
  if bCancel then Result := PROGRESS_CANCEL else Result := PROGRESS_CONTINUE;
  case dwCallbackReason of
      CALLBACK_CHUNK_FINISHED: begin
      AppProcessMessage;
      ProgressBar.Position := Round(100*Size64(TotalBytesTransferredLo, TotalBytesTransferredHi)/Size64(TotalFileSizeLo, TotalFileSizeHi));
      SetTaskBarProgressValue(Round(100*Size64(TotalBytesTransferredLo, TotalBytesTransferredHi)/Size64(TotalFileSizeLo, TotalFileSizeHi))); 
    end;
  end;
end;
function FindFiles(const pFrom, pTo: String; const Recurse: Boolean; const szRootDir: String): Cardinal;
var
  FR: TFindRec;
  szFileName,BPath: String;
begin
  bCancel := False;
  if FindFirst(ExtendPath(pFrom), FR) then
  try
      repeat 
      AppProcessMessage;  
          if (FR.Attributes and FILE_ATTRIBUTE_DIRECTORY = 0) then
          begin
            pFrom := pFrom;
            while Pos('\\?\',pFrom) > 0 do
            Delete(pFrom,Pos('\\?\',pFrom),4);
            if not DirExists(ExtendPath(Format('%s\%s', [pTo, ExtractRelativePath(szRootDir, ExtractFilePath(pFrom))]))) then 
            ForceDirectories(ExtendPath(Format('%s\%s', [pTo, ExtractRelativePath(szRootDir, ExtractFilePath(pFrom))])));
            szFileName := ExtendPath(Format('%s\%s', [ExtractFileDir(pFrom), FR.Name]));
            BPath := szFileName;
            while Pos('\\?\',BPath) > 0 do
            Delete(BPath,Pos('\\?\',BPath),4);
              ProgressBar.Min := 0;
              ProgressBar.Max := 100;
            copycallback := WrapMyCopyCallback(@CopyProgressRoutine,13); //Our proc has 13 arguments
                Lang := GetIniString('ISPATCH', 'COPYING_EXTERNAL_FILE', '--> Copying file to: ', sLang); 
                pLog.Lines.Add(Lang + '"' + pTo +'\' +ExtractRelativePath(szRootDir, BPath)+'"');
            if FileExists(ExtendPath(ResultStr + '\' + ExtractRelativePath(szRootDir, BPath))) then
            SetFileAttributes(ExtendPath(ResultStr + '\' + ExtractRelativePath(szRootDir, BPath)),$80); 
            if not CopyFileEx(ExtendPath(Format('%s\%s', [ExtractFileDir(pFrom), FR.Name])), ExtendPath(Format('%s\%s%s', [pTo, ExtractRelativePath(szRootDir, ExtractFilePath(pFrom)), FR.Name])), copycallback, 0, bCancel, 0) then
            begin
              Lang := GetIniString('ISPATCH', 'COPYING_EXTERNAL_FILE_FAILED', '[!]  Some error ocurred while copying file: ', sLang); 
              pLog.Lines.Add(Lang + '"'+BPath+'"');
              inc(z); 
              bCancel := True;
              SetTaskBarProgressState(4);
              SetTaskBarProgressValue(100); 
              Exit; 
            end;
            Result := DLLGetLastError;
            if bCancel then Exit;
          end;
      until not FindNext(FR);
  finally
    FindClose(FR);
  end;
  if not Recurse then Exit;
  if FindFirst(ExtendPath(Format('%s\*', [ExtractFileDir(pFrom)])), FR) then
  try
    repeat
    AppProcessMessage;
      if (FR.Attributes and FILE_ATTRIBUTE_DIRECTORY <> 0) and (FR.Name <> '.') and (FR.Name <> '..') then
      FindFiles(ExtendPath(Format('%s\%s\%s', [ExtractFileDir(pFrom), FR.Name, ExtractFileName(pFrom)])), pTo, Recurse, szRootDir);
    until not FindNext(FR);
  finally
    FindClose(FR);
  end;
end;
function xcopy(const pFrom, pTo: String; const Recurse: Boolean): Cardinal;
begin
  if PathIsDirectory(pFrom) then
  begin
    if not DirExists(pFrom) then Exit;
    pFrom := Format('%s\*', [pFrom]);
  end else if not DirExists(ExtractFileDir(pFrom)) then Exit;
  Result := FindFiles(pFrom, pTo, Recurse, ExtractFilePath(pFrom));
end;
{
function IsProcessRunning(FileName: String): Boolean;
var
  objSWbemLocator, objSWbemServices: Variant;
begin
  try
    objSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  except
    ShowExceptionMessage;
    Exit;
  end;
  objSWbemServices := objSWbemLocator.ConnectServer();
  objSWbemServices.Security_.ImpersonationLevel := 3;
  Result := (objSWbemServices.ExecQuery('SELECT * FROM Win32_Process WHERE Name="' + FileName + '"').Count > 0);
end;
}
procedure RollBack;
begin
  if IniKeyExists('TOTALVER','VER',ExpandConstant('{tmp}') + '\Checker.ini') then
  begin
    t := 0;
    pLog.Lines.Add('');
    Lang := GetIniString('ISPATCH', 'PATCH_UNSUCCESS', 'Errors ocurred during patching!', sLang); 
    pLog.Lines.Add(Lang); 
    pLog.Lines.Add('');
    Lang := GetIniString('ISPATCH', 'ROLLBACK_STARTED', 'Rollback started!', sLang);
    pLog.Lines.Add(Lang); 
    ProgressBar.Min := 0;
    ProgressBar.Max := pCount;
    ProgressBar.Position := pCount;
    repeat
    AppProcessMessage;
    ini := GetIniString('VERIFIED', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
    if FileExists(ExtendPath(ResultStr + BACKUP_DIR + ini)) then
    begin
      ForceDirectories(ExtendPath(ExtractFilePath(ResultStr + ini))); 
      SetFileAttributes(ExtendPath(ResultStr + ini),$80);     
      if not FileCopy(ExtendPath(ResultStr + BACKUP_DIR + ini),ExtendPath(ResultStr + ini), False) then
      begin
        Lang := GetIniString('ISPATCH', 'FAILED_TO_ROLLBACK', 'Error: Failed to rollback from: ', sLang);
        Lang2 := GetIniString('ISPATCH', 'FAILED_TO_ROLLBACK2', ' file to: ', sLang);
        pLog.Lines.Add(Lang +'"'+ ResultStr + BACKUP_DIR + ini +'"'+ Lang2 +'"'+ ResultStr + ini +'"');   
      end else
      begin
            Lang := GetIniString('ISPATCH', 'ROLLBACK_SUCCESS', 'Rollback: ', sLang);
            Lang2 := GetIniString('ISPATCH', 'ROLLBACK_SUCCESS2', ' to: ', sLang);
            Lang3 := GetIniString('ISPATCH', 'ROLLBACK_SUCCESS3', ' success.', sLang);
            pLog.Lines.Add(Lang +'"'+ ResultStr + BACKUP_DIR + ini +'"'+ Lang2 +'"'+ ResultStr + ini +'"'+ Lang3);  
      end;
    end;
    inc(t);
    ProgressBar.Position := pCount - t;
    SetTaskBarProgressValue(100 - (t * 100 / pCount));
    until t >= pCount;
  end;
  if IniKeyExists('TOTALINC','INC',ExpandConstant('{tmp}') + '\Checker.ini') then
  begin
    t := 0;
    ProgressBar.Min := 0;
    ProgressBar.Max := iCount;
    ProgressBar.Position := iCount;
    repeat
    AppProcessMessage;
    ini := GetIniString('INCLUDED', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
    if FileExists(ExtendPath(ResultStr + ini)) then
    begin 
      SetFileAttributes(ExtendPath(ResultStr + ini),$80);   
      if not DeleteFile(ExtendPath(ResultStr + ini)) then
      begin
         Lang := GetIniString('ISPATCH', 'FAILED_TO_DELETE_INCLUDED', 'Error: Failed to delete included: ', sLang);
         pLog.Lines.Add(Lang +'"'+ ResultStr + ini +'"');  
      end else
      begin
        if FileExists(ExtendPath(ResultStr + BACKUP_DIR + ini)) then
        begin
          ForceDirectories(ExtendPath(ExtractFilePath(ResultStr + ini))); 
          MoveFileEx(ExtendPath(ResultStr + BACKUP_DIR + ini),ExtendPath(ResultStr + ini), $1 or $2);
        end;
              Lang := GetIniString('ISPATCH', 'INCLUDED_DELETED_SUCCESS', 'Included: ', sLang);
              Lang2 := GetIniString('ISPATCH', 'INCLUDED_DELETED_SUCCESS2', ' deleted success.', sLang);
              pLog.Lines.Add(Lang +'"'+ ResultStr + ini +'"'+ Lang2);  
        if DirExists(ExtendPath(ExtractFileDir(ResultStr + ini))) then
        begin
          if RemoveDir(ExtendPath(ExtractFileDir(ResultStr + ini))) then
          begin
              Lang := GetIniString('ISPATCH', 'INCLUDED_DIR_DELETED', 'Included dir: ', sLang);
              Lang2 := GetIniString('ISPATCH', 'INCLUDED_DIR_DELETED2', ' is empty and was deleted success.', sLang);
              pLog.Lines.Add(Lang +'"'+ ExtractFileDir(ResultStr + ini) +'"'+ Lang2); 
          end;
        end;
      end;
    end;
    inc(t);
    ProgressBar.Position := iCount - t;
    SetTaskBarProgressValue(100 - (t * 100 / iCount));
    until t >= iCount;
  end;
  if IniKeyExists('TOTALOLD','OLD',ExpandConstant('{tmp}') + '\Checker.ini') then
  begin
    t := 0;
    ProgressBar.Min := 0;
    ProgressBar.Max := jCount;
    ProgressBar.Position := jCount;
    repeat
    AppProcessMessage;
    ini := GetIniString('JUNKED', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
    if FileExists(ExtendPath(ResultStr + BACKUP_DIR + ini)) then
    begin
      ForceDirectories(ExtendPath(ExtractFilePath(ResultStr + ini))); 
      SetFileAttributes(ExtendPath(ResultStr + ini),$80);
      if not FileCopy(ExtendPath(ResultStr + BACKUP_DIR + ini), ExtendPath(ResultStr + ini), False) then
      begin
         Lang := GetIniString('ISPATCH', 'FAILED_TO_RESTORE', 'Error: Failed to restore junked file from: ', sLang);
         Lang2 := GetIniString('ISPATCH', 'FAILED_TO_RESTORE2', ' to: ', sLang);
         pLog.Lines.Add(Lang +'"'+ ResultStr + BACKUP_DIR + ini +'"'+ Lang2 +'"'+ ResultStr + ini +'"');   
      end else
      begin
            Lang := GetIniString('ISPATCH', 'JUNKED_RESTORED', 'Junked file: ', sLang);
            Lang2 := GetIniString('ISPATCH', 'JUNKED_RESTORED2', ' is restored successfull.', sLang);
            pLog.Lines.Add(Lang +'"'+ ResultStr + ini +'"'+ Lang2);  
      end;
    end;
    inc(t);
    ProgressBar.Position := jCount - t;
    SetTaskBarProgressValue(100 - (t * 100 / jCount));
    until t >= jCount;
    if IniKeyExists('TOTALOLD','OLD_DIRS',ExpandConstant('{tmp}') + '\Checker.ini') then
    begin
      t := 0;
      repeat
      AppProcessMessage;
      ini := GetIniString('JUNKED_DIRS', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
      if DirExists(ExtendPath(ResultStr + BACKUP_DIR + ini)) then
        ForceDirectories(ExtendPath(ResultStr + ini));
      inc(t);
      until t >= jdCount;
    end;
  end;
  SetTaskBarProgressValue(0);
  Lang := GetIniString('ISPATCH', 'ROLLBACK_ERROR', 'Error while patching was ocurred and Patch apply the rollback.', sLang);
  Lang2 := GetIniString('ISPATCH', 'ROLLBACK_ERROR2', 'Rollback of modified files is complete. Included files was deleted.', sLang); 
  Lang3 := GetIniString('ISPATCH', 'ROLLBACK_ERROR3', 'Remove backup dir: ', sLang);
  Lang4 := GetIniString('ISPATCH', 'ROLLBACK_ERROR4', 'totally with all included files and subdirs?', sLang);
  if MsgBox(Lang + #13#13 + Lang2 + #13#13 + Lang3 +'"'+ ResultStr + BACKUP_DIR +'"'+ #13#13 + Lang4, mbError, mb_yesno) = idyes then
  begin
    if DelTree(ExtendPath(ResultStr + BACKUP_DIR), True, True, True) then
    begin
      Lang := GetIniString('ISPATCH', 'BACKUP_DIR_DELETED', 'Backup dir: ', sLang);
      Lang2 := GetIniString('ISPATCH', 'BACKUP_DIR_DELETED2', ' was deleted.', sLang);
      pLog.Lines.Add(Lang +'"'+ResultStr +BACKUP_DIR +'"'+ Lang2); 
    end else
    begin
      Lang := GetIniString('ISPATCH', 'BACKUP_DIR_DELETED_NOT_FULLY', 'Backup dir: ', sLang);
      Lang2 := GetIniString('ISPATCH', 'BACKUP_DIR_DELETED_NOT_FULLY2', ' was cleared but some used files or folders unable to delete. Check this dir for details.', sLang);
      pLog.Lines.Add(Lang +'"'+ ResultStr +BACKUP_DIR +'"'+ Lang2); 
    end
  end;
  Lang := GetIniString('ISPATCH', 'ROLLBACK_FINISHED', 'Rollback finished!', sLang);
  pLog.Lines.Add(Lang); 
  pLog.Lines.Add('');
  Lang := GetIniString('ISPATCH', 'PATCHING_FINIFHED_WITH_ERRORS', 'Patching finished with errors!', sLang);
  pLog.Lines.Add(Lang);
  Lang := GetIniString('ISPATCH', 'PATCHING_ERROR', 'Patch was not applied!', sLang); 
  xInfo.Text := Lang;
  xInfo.Update;
  if cb_log.checked then
  begin
    pLog.Lines.Add(''); 
    Lang := GetIniString('ISPATCH', 'PATCHING_LOG', 'Patching log saved to: ', sLang + ' ' + GetDateTimeString('dd/mm/yyyy hh:nn:ss', '.', '-'));
    pLog.Lines.Add(Lang);
    pLog.Lines.Add('--> ' + '"'+ ResultStr + '\PatchLog '+GetDateTimeString('dd/mm/yyyy hh:nn:ss', '.', '-')+'.txt'+'"');
    WriteUnicode(ExtendPath(ResultStr + '\PatchLog '+GetDateTimeString('dd/mm/yyyy hh:nn:ss', '.', '-')+'.txt'),pLog.Text);
  end;
end;
procedure InsertCodeOnStartup;

begin

end;
procedure InsertCodeBeforeUpdate;

begin

end;
procedure InsertCodeAfterUpdate;

begin

end;
procedure InsertCodeOnFinish;

begin

end;
procedure GetInstallPathFromRegistry;
begin
  if RegQueryStringValue(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\S.T.A.L.K.E.R. 2 - Heart of Chornobyl_is1', 'InstallLocation', ResultStr) then
  if 1 = 0 then
  ResultStr := ExtendPath(ExtractFileDir(ResultStr));
  if ResultStr <> '' then
  ResultStr := ExtendPath(RemoveQuotes(ResultStr) + '');
  if ResultStr = '' then
  begin
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
  ExtractTemporaryFile('Checker.ini'); 
  if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    Exit;
  end else
  begin
    Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
  end;
  if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin
    Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin   
    Lang := GetIniString('ISPATCH', 'FOUNDED_VERSION2', 'Founded installed version! Ready to Patch!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
end;
procedure GetInstallPathFromIni;
begin
  ResultStr := GetIniString('', '', ExtendPath(ResultStr), ExpandConstant(ExtendPath('')));  
  if 1 = 0 then
  ResultStr := ExtendPath(ExtractFileDir(ResultStr)); 
  if ResultStr <> '' then 
  ResultStr := ExtendPath(RemoveQuotes(ResultStr) + '');
  if ResultStr = '' then
  begin
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
  ExtractTemporaryFile('Checker.ini'); 
  if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    Exit;
  end else
  begin
    Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
  end;
  if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin
    Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
  begin  
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin   
    Lang := GetIniString('ISPATCH', 'FOUNDED_VERSION2', 'Founded installed version! Ready to Patch!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  begin   
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
end;
procedure GetInstallPathFromXml;
var
  xml,currNode: Variant;
begin
  if not FileExists(ExtendPath(ExpandConstant(''))) then
  ResultStr := ''
  else
  begin
    try
      xml := CreateOleObject('MSXML2.DOMDocument');
      xml.async := false;
      xml.preserveWhiteSpace := true;
      xml.load(ExtendPath(ExpandConstant('')));
      currNode:= xml.selectSingleNode('')
      ResultStr := currNode.text;  
    except
    end;
    if 1 = 0 then
    begin
      ResultStr := ExtendPath(ExtractFileDir(ResultStr)); 
    end;
  end;
  if ResultStr <> '' then 
  ResultStr := ExtendPath(RemoveQuotes(ResultStr) + '');
  if ResultStr = '' then
  begin
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
  ExtractTemporaryFile('Checker.ini'); 
  if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    Exit;
  end else
  begin
    Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
  end;
  if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin
    Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
  begin  
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin   
    Lang := GetIniString('ISPATCH', 'FOUNDED_VERSION2', 'Founded installed version! Ready to Patch!', sLang);
    xInfo.Text := Lang;
  end else
  begin   
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
end;
procedure GetManualInstallPath;
begin
  ResultStr := ExtendPath(ExpandConstant(''));
  if ResultStr <> '' then
  ResultStr := ExtendPath(RemoveQuotes(ResultStr) + '');
  if ResultStr = '' then
  begin
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
  ExtractTemporaryFile('Checker.ini'); 
  if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    Exit;
  end else
  begin
    Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
  end;
  if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin
    Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
  begin  
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin   
    Lang := GetIniString('ISPATCH', 'FOUNDED_VERSION2', 'Founded installed version! Ready to Patch!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  begin   
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
end;
procedure GetInstallPathFromParameter;
begin
  ResultStr := ExtendPath(ExpandConstant('{param:}'));
  if ResultStr <> '' then 
  ResultStr := ExtendPath(RemoveQuotes(ResultStr) + '');
  if ResultStr = '' then
  begin
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
  ExtractTemporaryFile('Checker.ini'); 
  if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    Exit;
  end else
  begin
    Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
  end;
  if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin
    Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
  begin  
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin   
    Lang := GetIniString('ISPATCH', 'FOUNDED_VERSION2', 'Founded installed version! Ready to Patch!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  begin   
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
end;
procedure CheckApp;
begin
  ResultStr := oDir.Text;
  if ResultStr = '' then
  begin
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end;
  ExtractTemporaryFile('Checker.ini'); 
  if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
  begin 
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    Exit;
  end else
  begin
    Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
  end;
  if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin
    Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
  begin  
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
  begin   
    Lang := GetIniString('ISPATCH', 'FOUNDED_VERSION2', 'Founded installed version! Ready to Patch!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end else
  begin   
    Lang := GetIniString('ISPATCH', 'INSTALL_PATH_NOT_FOUND', 'Install path for required version was not found! Please select it!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
  end
end;
procedure CheckValidAppPath(Sender: TObject);
begin
  if init_key_chk = 0 then Exit else init_key_chk := 1;
  CheckApp; 
end;            
procedure BrowseOutput(Sender: TObject); 
begin
  UserSelectDir:= ExpandConstant('{pf}');
  Lang := GetIniString('ISPATCH', 'BROWSE_DIALOG', 'Please select path to the destination dir location:', sLang);
  if BrowseForFolder(Lang, UserSelectDir, False) then
  begin
    ResultStr:= UserSelectDir;
    oDir.Text := ResultStr;
    CheckApp;
  end;
end;
function CheckIni(): Boolean;
begin
  Result := True;
  DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
  ExtractTemporaryFile('Checker.ini'); 
  if IniKeyExists('KEY','FILE',ExpandConstant('{tmp}') + '\Checker.ini') then
  begin
    if not FileExists(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini'))) then
    begin
      Result:=False;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
      Lang := GetIniString('ISPATCH', 'ORIGINAL_NOT_FOUND', 'Original installation not found! Please select a valid path!', sLang);
      xInfo.Text := Lang;
      xInfo.Update;
      MsgBox(Lang, mbError, mb_OK);
      Exit;
    end else
    begin
      Lang := GetIniString('ISPATCH', 'VERSION_DETECTING', 'Detecting version... Please wait...', sLang);
      xInfo.Text := Lang;
      xInfo.Update;
      key_cur := GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('KEY','FILE','',ExpandConstant('{tmp}') + '\Checker.ini')));
    end;
    if StrToInt64(GetIniString('KEY','HASH_NEW','',ExpandConstant('{tmp}') + '\Checker.ini')) = key_cur then
    begin
      Result:=False;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini'); 
      Lang := GetIniString('ISPATCH', 'ALLREADY_UPDATED', 'Application in this location is allready updated!', sLang);
      xInfo.Text := Lang;
      xInfo.Update;
      MsgBox(Lang, mbInformation, mb_OK);
    end else
    if StrToInt64(GetIniString('KEY','HASH','',ExpandConstant('{tmp}') + '\Checker.ini')) <> key_cur then
    begin
      Result:=False;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini'); 
      Lang := GetIniString('ISPATCH', 'INCORRECT_HASH', 'Checksum hash is a not from original file!', sLang);
      Lang2 := GetIniString('ISPATCH', 'INCORRECT_HASH2', 'Please check your program version!', sLang);
      xInfo.Text := Lang + ' ' + Lang2;
      xInfo.Update;
      MsgBox(Lang + #13#13 + Lang2, mbCriticalError, mb_OK);
    end;
  end else
  begin
    Result:=False;
    DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
    Lang := GetIniString('ISPATCH', 'ORIGINAL_NOT_FOUND', 'Original installation not found! Please select a valid path!', sLang);
    xInfo.Text := Lang;
    xInfo.Update;
    MsgBox(Lang, mbError, mb_OK);
    Exit;
  end;
end;
function GetApplyingCores: Integer;
begin
    cores := GetCPUCores;
  if 75 = 1 then
    Result := 1 else
  if 75 = 25 then
    Result := cores / 2 / 2 else
  if 75 = 50 then
    Result := cores / 2 else
  if 75 = 75 then
    Result := cores / 2 + cores / 4 else
  if 75 = 100 then
    Result := cores;
  if Result < 1 then Result := 1;
end;
procedure ApplyPatchData;
begin 
  ResultStr := oDir.Text; 
  ExtractTemporaryFile('Checker.ini'); 
  ResultStr := RemoveBackslash(ResultStr);
  if not DirExists(ExtendPath(ResultStr)) then // if exist detected or selected path
  begin
    Lang := GetIniString('ISPATCH', 'INCORRECR_PATH_ENTERED', 'Incorrect path entered! Please select installation dir!', sLang);
    MsgBox(Lang, mbError, mb_OK);
    DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
    Exit;
  end;
  if CheckIni = False then                       
  Exit;  
  PatchingError := 0; 
  z := 0;
    pInfo.SendToBack;
    pLog.BringToFront;  
    InfoButton.Enabled := True;
    pLog.Text := '';
    pLog.Refresh;
  InsertCodeBeforeUpdate;
      ProgressBar.Position := 0;
      ExitButton.Enabled := False;   
      StartButton.Enabled := False;                             
      BrowseButton.Enabled := False;   
        Lang := GetIniString('ISPATCH', 'EXTRACT_TEMP_PATCH_DATA', 'Extracting patch-data to the temporary dir...', sLang);
        pLog.Lines.Add(Lang);
        pLog.Lines.Add('');
        xInfo.Text := Lang;
        xInfo.Update;
        tc := StrToInt(GetIniString('TOTAL_TMP_PATCH_DATA', 'TMP_PD', '0', ExpandConstant('{tmp}') + '\Checker.ini')); 
        ProgressBar.Position := 0;
        ProgressBar.Min := 0;
        ProgressBar.Max := tc;
        for tp:=0 to tc-1 do
        begin
          AppProcessMessage;
          tf := GetIniString('TMP_PATCH_DATA', IntToStr(tp),'0', ExpandConstant('{tmp}') + '\Checker.ini');
            Lang := GetIniString('ISPATCH', 'S_EXTRACTING', '--> Extracting file: ', sLang);
            pLog.Lines.Add(Lang + '"'+tf+'"');
          ExtractTemporaryFiles(tf); 
          ProgressBar.Position := tp+1;
          SetTaskBarProgressValue((tp+1) * 100 / tc);
        end;
        pLog.Lines.Add('');
    if PatchingError = 1 then
    begin
      ExitButton.Enabled := True;                          
      StartButton.Enabled := True;   
      BrowseButton.Enabled := True; 
      Exit;
    end;
        oDir.ReadOnly := True;
        oDir.Refresh;
        Lang := GetIniString('ISPATCH', 'PATCHING_PROCESS', 'Patching process, please wait...', sLang);
        Elapsed := 0;
        Start:=GetTickCount;
        tfunc:= WrapTimerProc(@tTimer, 4);
        tTimerID:= SetTimer(0, 0, 100, tfunc);
        xInfo.Text := Lang + #13#10 + FormatTime(Elapsed);
        xInfo.Update;
        pCount := StrToInt(GetIniString('TOTALVER', 'VER', '', ExpandConstant('{tmp}') + '\Checker.ini')); // get the included files count
    begin
      Lang := GetIniString('ISPATCH', 'START_PATCHING', '[Starting patching session]', sLang);
      pLog.Lines.Add(Lang);
      m := 0;
      ProgressBar.Position := 0;
      ProgressBar.Min := 0;
      ProgressBar.Max := pCount;
      SetTaskBarProgressValue(0);
          EngineParam := '';
          if not IsWin64 then
          begin
            ExtractTemporaryFile('jptch-x86.exe');
            PatchEngine := 'jptch-x86.exe';
          end else
          begin
            ExtractTemporaryFile('jptch-x64.exe');
            PatchEngine := 'jptch-x64.exe';
          end;
       BACKUP_DIR := BAK_DIR;
    bkp := 0;
    if DirExists(ExtendPath(ResultStr + BACKUP_DIR)) then
    begin
      while DirExists(ExtendPath(ResultStr + BACKUP_DIR)) do
      begin
        inc(bkp);
        if not DirExists(ExtendPath(ResultStr + BACKUP_DIR + '-' + IntToStr(bkp))) then
        begin
          BACKUP_DIR := BACKUP_DIR + '-' + IntToStr(bkp);
          Break;
        end;
      end;
    end;
    corcnt := GetApplyingCores;
    SetLength(pProcessInfo, pCount);
    repeat 
      AppProcessMessage;
          basePath := ExpandConstant('{tmp}') + '\PatchData';
        srcFile := GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini');
      destFile := srcFile;    
      srcFile := basePath + srcFile + '.diff';
      t_basePath := ResultStr + destFile;
      if FileExists(ExtendPath(t_basePath)) then
      begin
        b_basePath := t_basePath; 
        Delete(b_basePath,1,Length(ResultStr));    
        ForceDirectories(ExtendPath(ExtractFilePath(ResultStr + BACKUP_DIR + b_basePath))); 
        MoveFileEx(ExtendPath(t_basePath),ExtendPath(ResultStr + BACKUP_DIR + b_basePath), $1 or $2);
        if FileExists(ExtendPath(srcFile)) and FileExists(ExtendPath(ResultStr + BACKUP_DIR + b_basePath)) then // check if patch-data and same original file is exists
        begin  
                Lang := GetIniString('ISPATCH', 'TARGET_FILE', 'Target file: ', sLang);
                pLog.Lines.Add(Lang +'"'+ t_basePath +'"');
                Lang := GetIniString('ISPATCH', 'PATCH_DATA_FILE', 'Patch-data file: ', sLang);
                pLog.Lines.Add(Lang +'"'+srcFile+'"');
          CreateAppProcess(ExpandConstant('{tmp}\') + PatchEngine, EngineParam + '"'+ExtendPath(ResultStr + BACKUP_DIR + b_basePath)+'" "'+ExtendPath(srcFile)+'" "'+ExtendPath(t_basePath)+'"', pProcessInfo[m]);
          while IsProcessRunning(PatchEngine) > (corcnt-1) do
          begin 
            AppProcessMessage; 
            Sleep(50);
          end; 
          begin   
              Lang := GetIniString('ISPATCH', 'OUTPUT_PATCHED', 'Output patched: ', sLang);                   
              pLog.Lines.Add(Lang +'"'+t_basePath+'"');
          end;
        end else
        begin
          Lang := GetIniString('ISPATCH', 'UNKNOWN_PATCHING_ERROR', 'Some error was ocurred while appling patch-data to: ', sLang); 
          pLog.Lines.Add(Lang +'"'+t_basePath+'"');
          inc(z);   
        end;
      end else
      begin // if files between patch-data and original dirs is missmatch, get the critical error and exit from the procedure
        Lang := GetIniString('ISPATCH', 'NOT_EXISTS_OR_MISSMATCH', 'Error: Files for patching in the selected dir are not exists or missmatch.', sLang); 
        pLog.Lines.Add(Lang);
        Lang := GetIniString('ISPATCH', 'CORRECT_PROBLEM', 'Please correct the problem and apply Patch again.', sLang);  
        pLog.Lines.Add(Lang);   
        ProgressBar.Position := pCount;
        KillTimer(0, tTimerID);
        SetTaskBarProgressState(4);
        SetTaskBarProgressValue(100);
        StartButton.Enabled := false;
        BrowseButton.Enabled := false; 
        ExitButton.Enabled := True; 
        oDir.ReadOnly := True;
        Lang := GetIniString('ISPATCH', 'NOTHING_TO_PATCH', 'Error! In installation dir not exists required files for patching!', sLang); 
        Lang2 := GetIniString('ISPATCH', 'NOTHING_TO_PATCH2', 'Please check the original files or it filenames in selected dir!', sLang); 
        MsgBox(Lang + #13 + Lang2, mbCriticalError, mb_OK);
        RollBack;
        DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini'); 
        PatchingError := 1;
        Exit;
      end;
      inc(m); 
      ProgressBar.Position := m;
      SetTaskBarProgressValue(m * 100 / pCount);
    until m >= pCount   
    Lang := GetIniString('ISPATCH', 'PATCHING_END', '[Ending patching session]', sLang); 
    pLog.Lines.Add(Lang); 
        pLog.Lines.Add(''); 
        Lang := GetIniString('ISPATCH', 'PREPARING_TO_OPERATIONS', 'Preparing to the next operations, waiting for unloading patching engine...', sLang); 
        pLog.Lines.Add(Lang);
        pLog.Lines.Add('');  
        while IsProcessRunning(PatchEngine) > 0 do
        begin 
          AppProcessMessage; 
          Sleep(50);
        end;                              
        for i:=0 to pCount-1 do
          CloseProcessHandles(pProcessInfo[i]);
        Lang := GetIniString('ISPATCH', 'VERIFICATION_START', 'Starting verification process...', sLang); 
        pLog.Lines.Add('::> ' + Lang);
        oCount := StrToInt(GetIniString('TOTALVER', 'VER', '0', ExpandConstant('{tmp}') + '\Checker.ini'));
        for i:=0 to oCount-1 do
        begin   
          AppProcessMessage; 
          if not FileExists(ResultStr + GetIniString('VERIFIED', IntToStr(i), '', ExpandConstant('{tmp}') + '\Checker.ini')) then
          begin
            Lang := GetIniString('ISPATCH', 'VERIFICATION_UNSUCCESS', '[!]  Some files do not exist or have incorrect hash!', sLang); 
            pLog.Lines.Add(Lang + ' > '+ExtendPath(GetIniString('VERIFIED', IntToStr(i), '', ExpandConstant('{tmp}') + '\Checker.ini')));
            inc(z);
          end;
        end;
      (*
      *)
    if (z > 0) or (v > 0) or (j > 0) then // if Error Code was happened, show additional warning
    begin                      
      PatchingError := 1;
      KillTimer(0, tTimerID);
      SetTaskBarProgressState(4);
      SetTaskBarProgressValue(100);
      RollBack;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
      Lang := GetIniString('ISPATCH', 'FINISHED_WITH_ERRORS', 'Patch finished with errors! Check the log for details!', sLang); 
      MsgBox(Lang, mbError, mb_OK);
      Exit;
    end;
    pLog.Lines.Delete(pLog.Lines.Count-1);
    Lang := GetIniString('ISPATCH', 'VERIFICATION_START', 'Starting verification process... OK!', sLang); 
    pLog.Lines.Add('::> ' + Lang + ' OK!');
    t := 0; 
    v := 0; 
    if IniKeyExists('INCLUDED','0',ExpandConstant('{tmp}') + '\Checker.ini') then
    begin
      pLog.Lines.Add(''); 
      Lang := GetIniString('ISPATCH', 'COPYING_START', '[Copying session start]', sLang); 
      pLog.Lines.Add(Lang);  
      iCount := StrToInt(GetIniString('TOTALINC', 'INC', '', ExpandConstant('{tmp}') + '\Checker.ini')); // get the included files count
      ProgressBar.Position := 0;
      SetTaskBarProgressValue(0);
      ProgressBar.Min := 0;
      ProgressBar.Max := iCount;  
      repeat
        AppProcessMessage;
        ini := GetIniString('INCLUDED', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
        if FileExists(ExpandConstant('{tmp}') + '\PatchData' + ini) then
        begin
           ForceDirectories(ExtendPath(ExtractFilePath(ResultStr + ini))); 
           if FileExists(ExtendPath(ResultStr + ini)) then
           begin
             ForceDirectories(ExtendPath(ExtractFilePath(ResultStr + BACKUP_DIR + ini))); 
             MoveFileEx(ExtendPath(ResultStr + ini),ExtendPath(ResultStr + BACKUP_DIR + ini), $1 or $2);
           end;
           if not FileCopy(ExpandConstant('{tmp}') + '\PatchData' + ini, ExtendPath(ResultStr + ini), False) then
           begin
              inc(v);
              Lang := GetIniString('ISPATCH', 'COPY_FAILED', 'Error: Failed to copy included file: ', sLang); 
              Lang2 := GetIniString('ISPATCH', 'COPY_FAILED2', ' to: ', sLang); 
              pLog.Lines.Add(Lang +'"'+ ExpandConstant('{tmp}') + '\PatchData' + ini +'"'+ Lang2 +'"'+ ResultStr + ini+'"'); 
              Lang := GetIniString('ISPATCH', 'COPY_IN_USE', 'Maybe ', sLang);   
              Lang2 := GetIniString('ISPATCH', 'COPY_IN_USE2', ' in use!', sLang);  
              pLog.Lines.Add(Lang +'"'+ ResultStr + ini +'"'+ Lang2);
           end else
           begin    
                  Lang := GetIniString('ISPATCH', 'INCLUDED_COPYIED', 'Included file: ', sLang); 
                  Lang2 := GetIniString('ISPATCH', 'INCLUDED_COPYIED2', ' is copied to: ', sLang);
                  pLog.Lines.Add(Lang +'"'+ ExpandConstant('{tmp}') + '\PatchData' + ini +'"'+ Lang2 +'"'+ ResultStr + ini+'"'); 
           end;
        end;
      inc(t);
      ProgressBar.Position := t;
      SetTaskBarProgressValue(t * 100 / iCount);
      until t >= iCount;
      Lang := GetIniString('ISPATCH', 'COPYING_END', '[Copying session end]', sLang); 
      pLog.Lines.Add(Lang);
    end;
      pLog.Lines.Add(''); 
      if IniKeyExists('TOTAL_HIDDEN', 'TH', ExpandConstant('{tmp}') + '\Checker.ini') then
      begin
        tc := StrToInt(GetIniString('TOTAL_HIDDEN', 'TH', '0', ExpandConstant('{tmp}') + '\Checker.ini')); 
        for tp:=0 to tc-1 do
        begin
          AppProcessMessage;
          if not SetFileAttributes(ExtendPath(ResultStr + GetIniString('HIDDEN_FILES', IntToStr(tp),'0', ExpandConstant('{tmp}') + '\Checker.ini')),StrToInt64(GetIniString('HIDDEN_ATTRS', IntToStr(tp),'0', ExpandConstant('{tmp}') + '\Checker.ini'))) then
          begin
            Lang := GetIniString('ISPATCH', 'SET_ATTRIBUTES_FAILED', '[!]  Failed to set original attributes to file: ', sLang); 
            pLog.Lines.Add(Lang + '"' + ResultStr + GetIniString('HIDDEN_FILES', IntToStr(tp), '', ExpandConstant('{tmp}') + '\Checker.ini') + '"'); 
            inc(z);
          end;
        end;
      end;
    if cb_vh.checked then
    begin
      Lang := GetIniString('ISPATCH', 'VERIFICATION_START', 'Starting files verification process...', sLang); 
      pLog.Lines.Add(Lang); 
    end;
       m := 0;
       repeat
       AppProcessMessage;
       if FileExists(ExtendPath(ResultStr + BACKUP_DIR + GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini'))) and FileExists(ExtendPath(ResultStr + GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini'))) then // check if patch-data and same original file is exists
       begin 
          if cb_vh.checked then
          begin
            if StrToInt64(GetIniString('MODIFIED_HASH', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini')) <> GetCRC32OfFile(ExtendPath(ResultStr + GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini'))) then
            begin
                  Lang := GetIniString('ISPATCH', 'INVALID_HASH', '[!]  Invalid checksum hash for updated file: ', sLang); 
                  pLog.Lines.Add(Lang +'"'+ResultStr + GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini')+'"');
              Inc(z);  
            end else
            begin
                  Lang := GetIniString('ISPATCH', 'VALID_HASH', 'Valid checksum hash for updated file: ', sLang); 
                  pLog.Lines.Add(Lang +'"'+ResultStr + GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini')+'"');
            end;
          end;
      end else
      begin
        Lang := GetIniString('ISPATCH', 'FILE_NOT_EXISTS', '[!]  Required to process file not exists: ', sLang); 
        pLog.Lines.Add(Lang + '"' + ResultStr + GetIniString('VERIFIED', IntToStr(m), '', ExpandConstant('{tmp}') + '\Checker.ini') + '"'); 
        Inc(z);
      end;
      inc(m);  
      until m >= pCount;
      dz := 0;
      if cb_vh.checked then
      begin
        if (z > 0) then
        begin
          pLog.Lines.Add(''); 
          Lang := GetIniString('ISPATCH', 'VERIFICATION_UNSUCCESS', '[!]  Some files not exists or have incorrect checksum!', sLang); 
          pLog.Lines.Add(Lang); 
        end else
        begin
          Lang := GetIniString('ISPATCH', 'VERIFICATION_FINISH', 'All files verification checksums is correct!', sLang); 
          pLog.Lines.Add(Lang); 
        end;
      end;
      if (dz = 1) then
      begin
        pLog.Lines.Add(''); 
        Lang := GetIniString('ISPATCH', 'SET_ATTRIBUTES_SUCCESS', 'Files attributes was set successfully!', sLang); 
        pLog.Lines.Add(Lang); 
      end;
    if (z > 0) or (v > 0) or (j > 0) then // if Error Code was happened, show additional warning
    begin                      
      PatchingError := 1;
      KillTimer(0, tTimerID);
      SetTaskBarProgressState(4);
      SetTaskBarProgressValue(100);
      RollBack;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
      Lang := GetIniString('ISPATCH', 'FINISHED_WITH_ERRORS', 'Patch finished with errors! Check the log for details!', sLang); 
      MsgBox(Lang, mbError, mb_OK);
      Exit;
    end;
       if cb_vh.checked then
       pLog.Lines.Add('');
       Lang := GetIniString('ISPATCH', 'TOTAL_PATCHED_FILES', 'Total processed files: ', sLang); 
       pLog.Lines.Add(Lang + IntToStr(m));
    if (z > 0) or (v > 0) or (j > 0) then // if Error Code was happened, show additional warning
    begin                      
      PatchingError := 1;
      KillTimer(0, tTimerID);
      SetTaskBarProgressState(4);
      SetTaskBarProgressValue(100);
      RollBack;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
      Lang := GetIniString('ISPATCH', 'FINISHED_WITH_ERRORS', 'Patch finished with errors! Check the log for details!', sLang); 
      MsgBox(Lang, mbError, mb_OK);
      Exit;
    end;
    t := 0; 
    if IniKeyExists('JUNKED','0',ExpandConstant('{tmp}') + '\Checker.ini') then
    begin
      pLog.Lines.Add(''); 
      Lang := GetIniString('ISPATCH', 'DELETING_JUNKED', '[Junked files deleting session start]', sLang); 
      pLog.Lines.Add(Lang);  
      jCount := StrToInt(GetIniString('TOTALOLD', 'OLD', '', ExpandConstant('{tmp}') + '\Checker.ini')); // get the included files count
      ProgressBar.Position := 0;
      SetTaskBarProgressValue(0);
      ProgressBar.Min := 0;
      ProgressBar.Max := jCount; 
      repeat
        AppProcessMessage;
        ini := GetIniString('JUNKED', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
        if FileExists(ExtendPath(ResultStr + ini)) then
        begin
          ForceDirectories(ExtendPath(ResultStr + BACKUP_DIR + ExtractFileDir(ini)));
          if MoveFileEx(ExtendPath(ResultStr + ini),ExtendPath(ResultStr + BACKUP_DIR + ini), $1 or $2) then
          begin
                  Lang := GetIniString('ISPATCH', 'JUNKED_REMOVED', 'Removed junked file: ', sLang);   
                  pLog.Lines.Add(Lang +'"'+ ResultStr + ini +'"');
          end else
          begin
            Lang := GetIniString('ISPATCH', 'JUNKED_REM_FAILED', 'Failed to remove junked file: ', sLang);   
            pLog.Lines.Add(Lang +'"'+ ResultStr + ini +'"');
          end;
        end;
      inc(t);
      ProgressBar.Position := t;
      SetTaskBarProgressValue(t * 100 / jCount);
      until t >= jCount;
        t := 0; 
        if IniKeyExists('JUNKED_DIRS','0',ExpandConstant('{tmp}') + '\Checker.ini') then
        begin
          jCount := StrToInt(GetIniString('TOTALOLD', 'OLD_DIRS', '', ExpandConstant('{tmp}') + '\Checker.ini')); // get the included files count
          repeat
            AppProcessMessage;
            ini := GetIniString('JUNKED_DIRS', IntToStr(t), '', ExpandConstant('{tmp}') + '\Checker.ini');
            if DirExists(ExtendPath(ResultStr + ini)) then
            begin
              ForceDirectories(ExtendPath(ResultStr + BACKUP_DIR + ini));
              RemoveDir(ExtendPath(ResultStr + ini));
            end;
          inc(t);
          until t >= jCount;
        end;
      Lang := GetIniString('ISPATCH', 'COMPLETING_JUNKED', '[Junked files deleting session end]', sLang); 
      pLog.Lines.Add(Lang);
    end;
      if (z > 0) or (v > 0) or (j > 0) then // if Error Code was happened, show additional warning
      begin                      
        PatchingError := 1;
        KillTimer(0, tTimerID);
        SetTaskBarProgressState(4);
        SetTaskBarProgressValue(100);
        RollBack;
        DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
        Lang := GetIniString('ISPATCH', 'FINISHED_WITH_ERRORS', 'Patch finished with errors! Check the log for details!', sLang); 
        MsgBox(Lang, mbError, mb_OK);
        Exit;
      end;
    end;
    if (z > 0) or (v > 0) or (j > 0) then // if Error Code was happened, show additional warning
    begin                      
      PatchingError := 1;
      KillTimer(0, tTimerID);
      SetTaskBarProgressState(4);
      SetTaskBarProgressValue(100);
      RollBack;
      DeleteFile(ExpandConstant('{tmp}') + '\Checker.ini');
      Lang := GetIniString('ISPATCH', 'FINISHED_WITH_ERRORS', 'Patch finished with errors! Check the log for details!', sLang); 
      MsgBox(Lang, mbError, mb_OK);
      Exit;
    end;
    InsertCodeAfterUpdate;
    StartButton.Enabled := false;
    BrowseButton.Enabled := false; 
    oDir.ReadOnly := True; 
    KillTimer(0, tTimerID);
    Lang := GetIniString('ISPATCH', 'PATCH_APPLIED', 'Patch was applied!', sLang); 
    xInfo.Text := Lang + #13#10 + FormatTime(Elapsed);
    xInfo.Update;
    PatchingError := 0;
    if not cb_bak.checked then
    begin 
      if DelTree(ExtendPath(ResultStr + BACKUP_DIR), True, True, True) then
      begin
        pLog.Lines.Add(''); 
        Lang := GetIniString('ISPATCH', 'TEMP_ROLLBACK_DELETED', 'Temporary files for rollback was deleted in: ', sLang);
        pLog.Lines.Add(Lang); 
        pLog.Lines.Add('--> ' + '"'+ ResultStr + BACKUP_DIR +'"'); 
      end else
      begin
        Lang := GetIniString('ISPATCH', 'TEMP_ROLLBACK_DELETED_IN_USE', 'Temporary rollback dir: ', sLang);
        Lang2 := GetIniString('ISPATCH', 'TEMP_ROLLBACK_DELETED_IN_USE2', ' was cleared but some used files or folders unable to delete. Check this dir for details.', sLang);
        pLog.Lines.Add(Lang +'"'+ ResultStr + BACKUP_DIR +'"'+ Lang2); 
      end;
    end;
    if cb_bak.checked then
    begin
      pLog.Lines.Add(''); 
      Lang := GetIniString('ISPATCH', 'STORED_BACKUP', 'Backup files stored in:  ', sLang);
      pLog.Lines.Add(Lang);
      pLog.Lines.Add('--> ' + '"'+ ResultStr + BACKUP_DIR+'"');
    end;
    if cb_log.checked then
    begin
      pLog.Lines.Add(''); 
      Lang := GetIniString('ISPATCH', 'PATCHING_LOG', 'Patching log saved to: ', sLang);
      pLog.Lines.Add(Lang);
      pLog.Lines.Add('--> ' + '"'+ ResultStr + '\PatchLog '+GetDateTimeString('dd/mm/yyyy hh:nn:ss', '.', '-')+'.txt'+'"'); 
    end;
    pLog.Lines.Add(''); 
    Lang := GetIniString('ISPATCH', 'OPERATION_SUCCESS', 'The operation completed successfully!', sLang);
    pLog.Lines.Add(Lang);
    SetTaskBarProgressValue(0);
    SetTaskBarProgressState(0); 
    ExitButton.Enabled := True;
    FlashTimer;
    if cb_log.checked then 
    WriteUnicode(ExtendPath(ResultStr + '\PatchLog '+GetDateTimeString('dd/mm/yyyy hh:nn:ss', '.', '-')+'.txt'),pLog.Text);
end;
procedure PatchStart (Sender: TObject);
begin
  Form.Refresh;
  ApplyPatchData;
  ExitButton.Enabled := True;
end;  
procedure ShowInfo (Sender: TObject);
begin
  Lang := GetIniString('ISPATCH', 'INFO_BUTTON', 'Info', sLang);
  if InfoButton.Caption = Lang then
  begin
    Lang := GetIniString('ISPATCH', 'LOG_BTN_STATE', 'Log', sLang);
    InfoButton.Caption := Lang;
    pLog.SendToBack;
    pInfo.BringToFront;
          pInfo.Text := '';
  end else
  begin
    Lang := GetIniString('ISPATCH', 'INFO_BUTTON', 'Info', sLang);
    InfoButton.Caption := Lang;
    pLog.BringToFront;
    pInfo.SendToBack;
  end;
end; 
procedure MusicPause (Sender: TObject);
begin
  if not BASS_ChannelPause(hMus) then  
  begin
    Lang := GetIniString('ISPATCH', 'MUSIC_BUTTON_PLAY', 'Music', sLang);
    MusicButton.Caption := Lang + ' |>';
    BASS_ChannelPlay(hMus , False);
  end else
  begin
    Lang := GetIniString('ISPATCH', 'MUSIC_BUTTON_PAUSE', 'Music ||', sLang);
    MusicButton.Caption := Lang + ' ||';
  end;
end; 
procedure PlayMusic;
begin
  if BASS_Init(-1, 44100, 0, 0, 0) then
  begin
    BASS_Start();
    ExtractTemporaryFile(ExtractFileName('D:\Repos\ARMGDDN Repacks\Setup\Music.mp3'));
    Song := ExpandConstant(ExpandConstant('{tmp}\') + ExtractFileName('D:\Repos\ARMGDDN Repacks\Setup\Music.mp3'));
    hMus := BASS_StreamCreateFile(False, PAnsiChar(Song), 0, 0, 4);
    if hMus <> 0 then
    begin
      BASS_ChannelSetAttribute(hMus, 2, 1);
      BASS_ChannelPlay(hMus, True);
    end;
  end;
end;
procedure CheckAppPath(Sender: TObject);
begin
  GetInstallPathFromRegistry;
  oDir.Text := ResultStr; 
end;
procedure TransparentAndAnimation(Sender: TObject);
begin
    AnimateWindow(Form.Handle,500,AW_SLIDE_IN_LEFT or AW_ACTIVATE);
    Form.ActiveControl := oDir; 
    Form.ActiveControl := xInfo;
    Form.ActiveControl := pInfo; 
    Form.ActiveControl := ExitButton; 
    oDir.Refresh; 
    xInfo.Refresh;
    pInfo.Refresh; 
    ExitButton.Refresh;
end;
procedure AnimationOnClose(Sender: TObject; var Action: TCloseAction);
begin
  AnimateWindow(Form.Handle,500,AW_SLIDE_OUT_LEFT or AW_HIDE);
  Action := caFree;
end;
function ShowUpdaterForm(): Boolean;
begin
   Result := True;
   Form := CreateCustomForm();
try
   Form.ClientWidth := ScaleX(438);                                                                                                                                                                                                                                                  
   Form.ClientHeight := ScaleY(468);
   Form.Caption := 'S.T.A.L.K.E.R. 2 - Heart of Chornobyl Update Patch';
   Form.Center;
   Form.OnShow := @TransparentAndAnimation;
   Form.OnActivate := @CheckAppPath;
   Form.OnClose := @AnimationOnClose;
   rStr := TLabel.Create(Form);               
   rStr.Top := ScaleY(3);
   rStr.Left := Form.Width;
   rStr.Width := Form.Width;
   rStr.Parent := Form;
   rStr.Font.Style:= [fsBold];
   rStr.Transparent := True;
   rStr.Caption := '    S.T.A.L.K.E.R. 2 - Heart of Chornobyl Update Patch  ';
   StringTimer;
   cStr := TLabel.Create(Form);
   cStr.Top := ScaleY(17);
   cStr.Left := ScaleX(0);
   cStr.Font.Style:=cStr.Font.Style;
   cStr.Font.Size:= Form.Font.Size + 3;
   cStr.Font.Name:= Form.Font.Name;
   cStr.Caption := 'S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340-22554680 Update Patch' + ' ' + 'UpdatePatch';
   cStr.ClientWidth := Form.ClientWidth;
   cStr.Alignment := taCenter;
   cStr.Transparent := True;
   cStr.Parent := Form;
   Lang := GetIniString('ISPATCH', 'DESCRIPTION', 'Description:', sLang);
   Lang2 := GetIniString('ISPATCH', 'COPYRIGHT', 'Copyright:', sLang);
   Lang3 := GetIniString('ISPATCH', 'CONTACT', 'Contact:', sLang);
   Lang4 := GetIniString('ISPATCH', 'INSTALLATION', 'Installation:', sLang);
   dStr := TLabel.Create(Form);               
   dStr.Top := ScaleY(38);
   dStr.Left := ScaleX(0);
   dStr.Font.Style:=dStr.Font.Style;
   dStr.Caption := Lang +' REQUIRES: S.T.A.L.K.E.R. 2 - Heart of Chornobyl v21222340 -ARMGDDN';
   dStr.Transparent := True;
   dStr.Parent := Form;
   dStr.ClientWidth := Form.ClientWidth;
   dStr.Alignment := taCenter;
   pStr := TLabel.Create(Form);               
   pStr.Top := ScaleY(56);
   pStr.Left := ScaleX(0);
   pStr.Font.Style:=pStr.Font.Style;
   pStr.Caption := Lang2 +' ARMGDDN Games ™';
   pStr.Transparent := True;
   pStr.Parent := Form;
   pStr.ClientWidth := Form.ClientWidth;
   pStr.Alignment := taCenter;
   iStr := TLabel.Create(Form);
   iStr.Width:= ScaleX(38);                   
   iStr.Top := ScaleY(74);
   iStr.Left := ScaleX(0);
   iStr.Font.Style:=iStr.Font.Style;
   iStr.Caption := Lang3;
   iStr.Transparent := True;
   iStr.Parent := Form;
   iStr.ClientWidth := Form.ClientWidth;
   iStr.Alignment := taCenter;
   Panel:=TPanel.Create(Form)
   Panel.Left:=ScaleX(7);
   Panel.Top:=ScaleY(111);                                     
   Panel.Width:=ScaleX(90);
   Panel.Height:=ScaleY(21);
   Panel.BevelInner:=bvNone;
   Panel.BevelOuter:=bvNone
   Panel.Parent:=Form;
   Panel.Visible:=False;
   mStr := TLabel.Create(Form);               
   mStr.Top := ScaleY(114);
   mStr.Left := ScaleX(7);
   mStr.Caption := Lang4;
   mStr.Transparent := True;
   mStr.Parent := Form;
   mStr.ClientWidth := Panel.ClientWidth;
   mStr.Alignment := taCenter;
   MouseLabel:=TLabel.Create(Form);
   MouseLabel.Width:=Form.Width;
   MouseLabel.Height:=Form.Height;
   MouseLabel.Autosize:=False;
   MouseLabel.Transparent:=True;
   MouseLabel.OnMouseMove:=@SiteLabelMouseMove2;
   MouseLabel.Parent:=Form;
   SiteLabel:=TLabel.Create(Form);
   SiteLabel.Caption:='t.me/ARMGDDNGames';
   SiteLabel.Font.Style:=SiteLabel.Font.Style;
   SiteLabel.Cursor:=crHand; 
   SiteLabel.OnClick:=@SiteLabelOnClick;
   SiteLabel.OnMouseDown:=@SiteLabelMouseDown;
   SiteLabel.OnMouseUp:=@SiteLabelMouseUp;
   SiteLabel.OnMouseMove:=@SiteLabelMouseMove;
   SiteLabel.Transparent:=True
   SiteLabel.Parent:=Form;
   SiteLabel.Top:=ScaleY(90);
   SiteLabel.Left := (Form.ClientWidth - SiteLabel.Width) / 2;
   pInfo := TMemo.Create(Form);
   pInfo.Parent := Form;
   pInfo.Width := ScaleX(424);          
   pInfo.Height := ScaleY(195);
   pInfo.Left := ScaleX(7);
   pInfo.Top := ScaleY(178);
   pInfo.ReadOnly:=True;
   pInfo.ScrollBars:=ssVertical;
   pInfo.WordWrap:=True;
   pInfo.Text := '';
   pInfo.Alignment := taLeftJustify;
   pInfo.Parent := Form;
   pInfo.BringToFront;
   pLog := TMemo.Create(Form);
   pLog.Parent := Form;
   pLog.Width := ScaleX(424);          
   pLog.Height := ScaleY(195);
   pLog.Left := ScaleX(7);
   pLog.Top := ScaleY(178);
   pLog.ReadOnly:=True;
   pLog.ScrollBars:=ssBoth;
   pLog.Text := '';
   pLog.Alignment := taLeftJustify;
   pLog.Parent := Form;
   pLog.SendToBack;
   StartButton := TButton.Create(Form);                    
   StartButton.Width := ScaleX(84);
   StartButton.Height := ScaleY(22);
   StartButton.Left := ScaleX(7);
   StartButton.Top := ScaleY(410);
   Lang := GetIniString('ISPATCH', 'START_BUTTON', 'Start', sLang);
   StartButton.Caption := Lang;
   StartButton.OnClick := @PatchStart;
   StartButton.Parent := Form;  
   BrowseButton := TButton.Create(Form);                    
   BrowseButton.Width := ScaleX(84);
   BrowseButton.Height := ScaleY(22);
   BrowseButton.Left := ScaleX(347);
   BrowseButton.Top := ScaleY(110);
   Lang := GetIniString('ISPATCH', 'BROWSE_BUTTON', 'Browse', sLang);
   BrowseButton.Caption := Lang;
   BrowseButton.OnClick := @BrowseOutput;
   BrowseButton.Parent := Form; 
   InfoButton := TButton.Create(Form);                                         
   InfoButton.Width := ScaleX(84);
   InfoButton.Height := ScaleY(22);
   InfoButton.Left := ScaleX(256);
   InfoButton.Top := ScaleY(410);
   Lang := GetIniString('ISPATCH', 'INFO_BUTTON', 'Info', sLang);
   InfoButton.Caption := Lang;
   InfoButton.OnClick := @ShowInfo; 
   InfoButton.Enabled := False;  
   InfoButton.Parent := Form;
   MusicButton := TButton.Create(Form);                                         
   MusicButton.Width := ScaleX(84);
   MusicButton.Height := ScaleY(22);
   MusicButton.Left := ScaleX(7);
   MusicButton.Top := ScaleY(381);
   Lang := GetIniString('ISPATCH', 'MUSIC_BUTTON_PLAY', 'Music', sLang);
   MusicButton.Caption := Lang + ' |>';
   MusicButton.OnClick := @MusicPause; 
   MusicButton.Parent := Form;
   ExitButton := TButton.Create(Form);                                         
   ExitButton.Width := ScaleX(84);
   ExitButton.Height := ScaleY(22);
   ExitButton.Left := ScaleX(347);
   ExitButton.Top := ScaleY(410);
   Lang := GetIniString('ISPATCH', 'EXIT_BUTTON', 'Exit', sLang);
   ExitButton.Caption := Lang;
   ExitButton.Parent := Form;
   ExitButton.ModalResult := mrOk; 
   ProgressBar := TNewProgressBar.Create(Form); 
   ProgressBar.Parent := Form;
   ProgressBar.Width:= ScaleX(424);
   ProgressBar.Top := ScaleY(440);
   ProgressBar.Left := ScaleX(7);
   ProgressBar.Height := ScaleY(18);
   WintbStart();
   SetTaskBarProgressValue(0);
   SetTaskBarProgressState(0); 
   cb_bak:=TCheckBox.Create(Form);
   cb_bak.Width:=ScaleX(13);
   cb_bak.Height:=ScaleY(13);
   cb_bak.Left:=ScaleX(95);
   cb_bak.Top:=ScaleY(378);               
   cb_bak.checked:= false;
   cb_bak.Parent:=Form;
   cb_log:=TCheckBox.Create(Form);
   cb_log.Width:=ScaleX(13);
   cb_log.Height:=ScaleY(13);
   cb_log.Left:=ScaleX(95);
   cb_log.Top:=ScaleY(396);           
   cb_log.checked:= true;
   cb_log.Parent:=Form;
   cb_vh:=TCheckBox.Create(Form);
   cb_vh.Width:=ScaleX(13);
   cb_vh.Height:=ScaleY(13);
   cb_vh.Left:=ScaleX(95);
   cb_vh.Top:=ScaleY(414);           
   cb_vh.checked:= false;
   cb_vh.Parent:=Form;
   bStr := TLabel.Create(Form);
   bStr.Width:= ScaleX(168);
   bStr.Height:= ScaleX(18);
   bStr.Top := ScaleY(377);
   bStr.Left := ScaleX(112);
   Lang := GetIniString('ISPATCH', 'BACKUP_BUTTON', 'Save Backup', sLang);
   bStr.Caption := Lang;
   bStr.Transparent := True;
   bStr.Parent := Form;
   lStr := TLabel.Create(Form);
   lStr.Width:= ScaleX(168);
   lStr.Top := ScaleY(395);
   lStr.Height:= ScaleX(18);
   lStr.Left := ScaleX(112);
   Lang := GetIniString('ISPATCH', 'LOG_BUTTON', 'Save Log', sLang);
   lStr.Caption := Lang;
   lStr.Transparent := True;
   lStr.Parent := Form;
   vStr := TLabel.Create(Form);
   vStr.Width:= ScaleX(168);
   vStr.Top := ScaleY(413);
   vStr.Height:= ScaleX(18);
   vStr.Left := ScaleX(112);
   Lang := GetIniString('ISPATCH', 'VERIFY_BUTTON', 'Verify Hash', sLang);
   vStr.Caption := Lang;
   vStr.Transparent := True;
   vStr.Parent := Form;
   xInfo := TMemo.Create(Form);
   xInfo.Width := ScaleX(424);
   xInfo.Height := ScaleY(34);
   xInfo.Left := ScaleX(7);
   xInfo.Top := ScaleY(138);
   xInfo.Parent := Form;
   xInfo.ReadOnly := True; 
   xInfo.Alignment :=taCenter;
   xInfo.Font.Style := [fsBold];
   xInfo.WordWrap:=False;
   xInfo.WantReturns:=False;
   oDir := TEdit.Create(Form);
   oDir.Width := ScaleX(244);
   oDir.Height := ScaleY(18);
   oDir.Left := ScaleX(97);
   oDir.Top := ScaleY(111);
   oDir.OnChange := @CheckValidAppPath;
   oDir.Parent := Form;
   ExtractTemporaryFile(ExtractFileName('D:\XDelta\resources\cursors\button\b7.ani'));
   ExtractTemporaryFile(ExtractFileName('D:\XDelta\resources\cursors\form\f7.ani'));
   NewCursor     := LoadCursorFromFile(ExpandConstant('{tmp}\') + ExtractFileName('D:\XDelta\resources\cursors\button\b7.ani'));
   NewCursorForm := LoadCursorFromFile(ExpandConstant('{tmp}\') + ExtractFileName('D:\XDelta\resources\cursors\form\f7.ani'));
   OldCursor:= SetClassLong(StartButton.Handle, GCL_HCURSOR, NewCursor);   
   OldCursor:= SetClassLong(cb_bak.Handle, GCL_HCURSOR, NewCursor); 
   OldCursor:= SetClassLong(cb_log.Handle, GCL_HCURSOR, NewCursor); 
   OldCursor:= SetClassLong(cb_vh.Handle, GCL_HCURSOR, NewCursor); 
   OldCursor:= SetClassLong(pLog.Handle, GCL_HCURSOR, NewCursorForm); 
   OldCursor:= SetClassLong(pInfo.Handle, GCL_HCURSOR, NewCursorForm); 
   OldCursor:= SetClassLong(xInfo.Handle, GCL_HCURSOR, NewCursorForm); 
   OldCursor:= SetClassLong(Form.Handle, GCL_HCURSOR, NewCursorForm); 
   OldCursor:= SetClassLong(oDir.Handle, GCL_HCURSOR, NewCursorForm);  
   OldCursor:= SetClassLong(ProgressBar.Handle, GCL_HCURSOR, NewCursorForm);   
   Form.ActiveControl := ExitButton;
   init_key_chk := 1;
   PlayMusic;
   if Form.ShowModal() = mrOk then
      Result := True;                                  
   finally           
      Form.Free();
   end; 
end;
function InitializeSetup(): Boolean;
begin
      ExtractTemporaryFile(ExtractFileName('D:\XDelta\resources\styles\vcl\Carbon.vsf'));
      LoadVCLStyle(ExpandConstant('{tmp}\') + ExtractFileName('D:\XDelta\resources\styles\vcl\Carbon.vsf'));
      ExtractTemporaryFile(ExtractFileName('C:\Users\SKYNET~1\AppData\Local\Temp\is-90QML.tmp\English.ini'));
      sLang := ExpandConstant('{tmp}\') + ExtractFileName('C:\Users\SKYNET~1\AppData\Local\Temp\is-90QML.tmp\English.ini');
    PatchingError := 2;
    InsertCodeOnStartup;
    init_key_chk := 0;
    ShowUpdaterForm;
      KillTimer(0, sTimerID);
      WintbStop;
      KillTimer(0, fTimerID);
      SetSystemCursor(OldCursor, OCR_NORMAL);
      BASS_Stop();
      BASS_Free(); 
    InsertCodeOnFinish;
      UnLoadVCLStyles;
    Result := False; 
end;
