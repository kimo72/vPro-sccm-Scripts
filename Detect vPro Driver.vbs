Option Explicit
Dim objWMIService, objItem, colItems, strComputer, x, DriverOk, outFile, objFile, objFSO, colRunningServices, nItems, SvcName
Dim SvcOK,objShell,strRegPath,RegVal,RegOk, DrvName
DriverOk = False
SvcOK = False
RegOk = False
DrvName = "intel%sol%"
SvcName = "LMS"
strRegPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1CEAC85D-2590-4760-800F-8DE5E91F3700}\DisplayVersion"
On Error Resume Next
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" _
& strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery(_
"Select * from Win32_PnPSignedDriver Where DeviceName like '" & DrvName & "'")
nItems = colItems.Count
if (nItems > 0) Then	
	DriverOk = True
Else
	DriverOk = False
End If
Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set colRunningServices = objWMIService.ExecQuery("Select * from Win32_Service Where Name='" & SvcName & "'")  
For Each objItem in colRunningServices 
	If objItem.State = "Stopped" Then 
		SvcOK = False
	Else
		SvcOK = True
	End If 
Next 
Set objShell = WScript.CreateObject("WScript.Shell")
RegVal = objShell.RegRead(strRegPath)
If (RegVal = "10.0.39.1003") Then
	RegOk = True
Else
	RegOk = False
End If
If (DriverOk AND SvcOK AND RegOk) Then
	WScript.Echo "Installed"
WScript.Quit(0)
Else
WScript.Quit(0)
'	WScript.Echo "Driver: " & DriverOk
'	WScript.Echo "Service: " & SvcOK
'	WScript.Echo "Registry: " & RegOk
'	WScript.Echo "Not Installed"
End If