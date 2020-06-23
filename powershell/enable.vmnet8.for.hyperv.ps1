
cinst vmware-workstation-player --yes

$VMSwitchName = "vmnet8"

New-VMSwitch $VMSwitchName -AllowManagementOS $true -NetAdapterInterfaceDescription "VMware Virtual Ethernet Adapter for VMnet8"

$MacAddress = (Get-VMNetworkAdapter -ManagementOS -SwitchName $VMSwitchName).MacAddress
$Adapter = Get-NetAdapter | Where-Object { (($_.MacAddress -replace '-','') -eq $MacAddress) }
$VMSwitchIP = Get-NetIPAddress -InterfaceIndex $Adapter.ifIndex -AddressFamily IPv4

New-NetFirewallRule -DisplayName "AllowVMnet8Host" -LocalAddress $VMSwitchIP.IPAddress -Direction Inbound -Action Allow

