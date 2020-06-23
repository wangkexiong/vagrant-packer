
# Enable NAT function for virtual switch "Default Switch" on Win10
# TODO: Setting DHCP Server (RSAT-DHCP seems not installed on appveyor)

Add-WindowsFeature RSAT-DHCP
$SwitchName = "Default Switch"
Restart-service dhcpserver -Force

New-VMSwitch -Name $SwitchName -SwitchType Internal
$MacAddress = (Get-VMNetworkAdapter -ManagementOS -SwitchName $SwitchName).MacAddress
$Adapter = Get-NetAdapter | Where-Object { (($_.MacAddress -replace '-','') -eq $MacAddress) }

New-NetIPAddress -IPAddress 192.168.140.1 -PrefixLength 24 -InterfaceIndex $Adapter.ifIndex
Add-DhcpServerv4Scope -Name "DHCP4DefaultSwitch" -StartRange 192.168.140.10 -EndRange 192.168.140.100 -SubnetMask 255.255.255.0
Set-DhcpServerv4DnsSetting -IPAddress 8.8.8.8 -DynamicUpdates "Never"
New-NetNat -Name Lab1NAT -InternalIPInterfaceAddressPrefix 192.168.140.0/24
New-NetFirewallRule -DisplayName "AllowDefaultSwitchHost" -LocalAddress 192.168.140.1 -Direction Inbound -Action Allow

