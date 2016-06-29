Set objShell = WScript.CreateObject("WScript.Shell") 
rc = objShell.Run("\\SADGCONFIMAN2\SoftwareDistribution\paquetes\Intel-vPro\Configurator\Acuconfig.exe /lowsecurity /output file \\SADGCONFIMAN2\SoftwareDistribution\paquetes\Intel-vPro\Configurator\1212.log status  ", 0, True) 
If (rc = 0) Then 
WScript.StdOut.Write "The application is installed" 
End If 
WScript.Quit(0)