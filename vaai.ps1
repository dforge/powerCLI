###
$vCenter    = "<VCENTER>"
$vLogs      = "C:\Docs\Temp\"
$vDC        = "<DC>"

###
connect-viserver -Server $vCenter

###
$vClusters = Get-Cluster -Location $vDC

###
Write-Host "                                       " –foregroundcolor "White"
Write-Host "#######################################" –foregroundcolor "White"
Write-Host "#                                      " –foregroundcolor "White"
Write-Host "# Installed VAAI Plugin                " –foregroundcolor "White"
Write-Host "# Show host where plugin is installed  " –foregroundcolor "White"
Write-Host "#                                      " –foregroundcolor "White"
Write-Host "#######################################" –foregroundcolor "White"

foreach($vCluster in $vClusters) {

    Write-Host $vCluster.Name –foregroundcolor "Yellow"
    $vHosts = Get-VMHost -Location $vCluster
    foreach($vHost in $vHosts) {

        $ID = ((Get-EsxCli -VMHost s-esxi55-a-13-2.rttv.ru).software.vib.list() | ? {$_.Name -like "*vaai*"}).ID
        if($ID -ne $null -and $ID -like "*vaai*") {
            Write-Host $vHost.Name –foregroundcolor "Red"
        }
    }
}

###
Write-Host "                                    " –foregroundcolor "White"
Write-Host "####################################" –foregroundcolor "White"
Write-Host "#                                   " –foregroundcolor "White"
Write-Host "# Checking state of native VAAI     " –foregroundcolor "White"
Write-Host "# Show host where VAAI is disabled  " –foregroundcolor "White"
Write-Host "#                                   " –foregroundcolor "White"
Write-Host "####################################" –foregroundcolor "White"

foreach($vCluster in $vClusters) {

    Write-Host $vCluster.Name –foregroundcolor "Yellow"
    $vHosts = Get-VMHost -Location $vCluster
    foreach($vHost in $vHosts) {

        $hal = (Get-AdvancedSetting -Entity $vHost -Name VMFS3.HardwareAcceleratedLocking).Value
        $hai = (Get-AdvancedSetting -Entity $vHost -Name DataMover.HardwareAcceleratedInit).Value
        $ham = (Get-AdvancedSetting -Entity $vHost -Name DataMover.HardwareAcceleratedMove).Value
        if( $hai -ne 1 -Or $hal -ne 1 -Or $ham -ne 1 ) {
            Write-Host $vHost.Name –foregroundcolor "Red"
        }
    }
}

###
disconnect-viserver -confirm:$false