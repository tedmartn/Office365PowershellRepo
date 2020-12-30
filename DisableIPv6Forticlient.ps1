net stop DnsProxyAgent

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\webroot\DnsAgent\NicSettings" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\webroot\DnsAgent\OriginalNicSettings" /f


$FortinetAdapter = Get-NetAdapter -InterfaceDescription "Fortinet SSL VPN Virtual Ethernet Adapter"
Disable-NetAdapterBinding -Name $FortinetAdapter.name -ComponentID ms_tcpip6 -PassThru


net start DnsProxyAgent
 