param(
 
[ValidateSet("sun", "moon", "earth")]
        [Alias("p1")] 
        $Param1
)






function executeProcess ($arguments)
{
                   $psi = New-object System.Diagnostics.ProcessStartInfo 
                   $psi.CreateNoWindow = $false 
                   $psi.UseShellExecute = $true 
                   $psi.RedirectStandardOutput = $false 
                   $psi.RedirectStandardError = $false 
                   $psi.FileName = "cmd"
                   $psi.Arguments = "$arguments"
                   $process = New-Object System.Diagnostics.Process 
                   $process.StartInfo = $psi 
                   [void]$process.Start()
                   #$output = $process.StandardOutput.ReadToEnd()
                   #$process.WaitForExit()               
                   return $psi.Arguments
}


function Get-PhysicalEthernetAdapter ($LogfileLocation)
{
    $MSTFPhysicalAdapter = Get-WmiObject -Class Win32_NetworkAdapter | where-object {$_.PNPDeviceID -match "PCI"}
    
    foreach($1 in $MSTFPhysicalAdapter)
            {
                $NonWireless = Get-WmiObject -Namespace "root/WMI" -Query "SELECT * FROM MSNdis_PhysicalMediumType" |Where-Object {$_.NdisPhysicalMediumType -eq 0 -and $_.InstanceName -eq $1.Name} 
                $NonWirelessAdapterconfig = Get-WmiObject Win32_NetworkAdapterconfiguration|Where-Object { $_.Description -eq $NonWireless.InstanceName }

            }

    if($NonWirelessAdapterconfig.DHCPEnabled -eq $true)
        {
            "The adapter" + "$NonWirelessAdapterconfig.Description" + "have DHCP enabled, a dynamic profile will be configured."
            
            Return "Dhcp enabled"
        }
        else
        {
            $verbose = "The adapter" + "$NonWirelessAdapterconfig.Description" + "have DHCP disabled, a static profile will be configured."
            Out-File -FilePath $LogfileLocation -InputObject $verbose
            Return "Dhcp disabled"
        }
    
}



