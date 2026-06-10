Option Explicit

Dim shell, fso, projectDir, checkCode, serverCmd, url, browserCmd
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' เปลี่ยนเป็นที่อยู่ของโปรเจคต์
projectDir = fso.GetParentFolderName(WScript.ScriptFullName)
If Not fso.FileExists(projectDir & "\index.html") Then
  projectDir = "C:\Users\Computer01\Thitipong\RPG15-School\RPG15"
End If

checkCode = shell.Run("cmd /c where http-server >nul 2>&1", 0, True)
If checkCode <> 0 Then
  MsgBox "Could not find http-server command." & vbCrLf & _
         "Install it once with: npm install -g http-server", _
         vbCritical, "RPG15 Startup"
  WScript.Quit 1
End If

serverCmd = "cmd /c cd /d """ & projectDir & """ && http-server --proxy http://localhost -p 8080"
shell.Run serverCmd, 0, False

WScript.Sleep 5000
url = "http://localhost:8080/?sn=202604150001"
browserCmd = BuildFullscreenBrowserCommand(url, shell.ExpandEnvironmentStrings("%ProgramFiles%"), shell.ExpandEnvironmentStrings("%ProgramFiles(x86)%"), shell.ExpandEnvironmentStrings("%LocalAppData%"), fso)

If browserCmd <> "" Then
  shell.Run browserCmd, 1, False
Else
  shell.Run url, 0, False
End If
' เปลี่ยนทsnที่ต้องการ ติดตั้ง npm install -g http-server ด้วยถ้ายังไม่ได้ติดตั้ง http-server

Function BuildFullscreenBrowserCommand(targetUrl, programFilesDir, programFilesX86Dir, localAppDataDir, fileSystem)
  Dim candidates, i, path

  candidates = Array( _
    programFilesDir & "\Google\Chrome\Application\chrome.exe", _
    programFilesX86Dir & "\Google\Chrome\Application\chrome.exe", _
    localAppDataDir & "\Google\Chrome\Application\chrome.exe", _
    programFilesDir & "\Microsoft\Edge\Application\msedge.exe", _
    programFilesX86Dir & "\Microsoft\Edge\Application\msedge.exe" _
  )

  For i = 0 To UBound(candidates)
    path = candidates(i)
    If fileSystem.FileExists(path) Then
      BuildFullscreenBrowserCommand = Chr(34) & path & Chr(34) & " --new-window --start-fullscreen " & Chr(34) & targetUrl & Chr(34)
      Exit Function
    End If
  Next

  BuildFullscreenBrowserCommand = ""
End Function
