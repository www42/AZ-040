# AZ-040 Mittwoch
# ===============

# Kalenderwoche
Get-Date -UFormat %V

Get-Help Get-Date -Parameter UFormat


# Module 5 WMI und CIM
# --------------------

# Beispiel
Get-CimInstance -ClassName Win32_OperatingSystem | fl *
Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty caption
Get-CimInstance -ClassName Win32_OperatingSystem | % caption

Get-CimInstance -ClassName Win32_BIOS | % SerialNumber
Get-WmiObject -Class Win32_BIOS | % SerialNumber

# CIM Methods
Get-CimClass -ClassName Win32_Service | Select-Object -ExpandProperty CimClassMethods

Get-Service bits
# Start-Service bits

#Invoke-CimMethod -ClassName Win32_Service -MethodName StartService -Arguments @{Name='Bits'}
Get-CimInstance -ClassName Win32_Service -Filter "Name='Bits'" | Invoke-CimMethod -MethodName StartService