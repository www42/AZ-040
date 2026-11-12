# Donnerstag
Get-PSDrive -Name Alias,Cert
Get-PSDrive Alias,Cert


Get-Command dir
Get-ChildItem cert:/currentuser/My
Get-ChildItem cert:/currentuser/My | Get-Member -MemberType Properties
Get-ChildItem cert:/currentuser/My | Select-Object FriendlyName,NotAfter

# Welche Zertifikate laufen in den nächsten 4 Wochen ab?
Get-ChildItem cert:/currentuser/My | Where-Object {$_.NotAfter -le (Get-Date).AddDays(28)} | Select-Object FriendlyName,Subject,NotAfter | Format-List

# Self signed Cert  for Codesigning
New-SelfSignedCertificate
get-help  New-SelfSignedCertificate -Online

# New file 
gcm pwd
Get-Location
gcm cd

New-Item -ItemType File -Name test.txt
New-Item -ItemType File -Name test2.txt | Out-Null

dir *.txt


# WMI (CIM) Datenbank
Get-CimInstance -ClassName Win32_BIOS | Select-Object                 SerialNumber,BIOSVersion
Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber

Get-CimInstance -ClassName Win32_BIOS | Select-Object -ExpandProperty SerialNumber | Get-Member
Get-CimInstance -ClassName Win32_BIOS | Select-Object                 SerialNumber | Get-Member