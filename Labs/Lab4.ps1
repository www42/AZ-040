# Lab 4: Using PSProviders and PSDrives with PowerShell

# ---> LON-CL1

# Exercise 1: Creating files and folders on a remote computer
# -----------------------------------------------------------
# Task 1: Create a new folder on a remote computer
Get-Help New-Item -ShowWindow
New-Item -Path \\Lon-Svr1\C$\ -Name ScriptShare -ItemType Directory

# Task 2: Create a new PSDrive mapping to the remote file folder
Get-Help New-PSDrive -ShowWindow
New-PSDrive -Name ScriptShare -Root \\Lon-Svr1\c$\ScriptShare -PSProvider FileSystem

# Task 3: Create a file on the mapped drive
Get-Help Set-Location -ShowWindow
Set-Location ScriptShare:
New-Item script.txt
Get-ChildItem


# Exercise 2: Creating a registry key for your future scripts
# -----------------------------------------------------------
# Task 1: Create the registry key to store script configurations
Get-ChildItem -Path HKCU:\Software
New-Item -Path HKCU:\Software -Name Scripts

# Task 2: Create a new registry value to store the name of the PSDrive
Set-Location HKCU:\Software\Scripts
New-ItemProperty -Path HKCU:\Software\Scripts -Name "PSDriveName" -Value "ScriptShare"
Get-ItemProperty . -Name PSDriveName


# Exercise 3: Creating a new Active Directory group
# -------------------------------------------------
# Task 1: Create a PSDrive that maps to the Users container in AD DS
Import-Module ActiveDirectory
New-PSDrive -Name AdatumUsers -Root "CN=Users,DC=Adatum,DC=com" -PSProvider ActiveDirectory
Set-Location AdatumUsers:

# Task 2: Create the London Developers group
New-Item -ItemType group -Path . -Name "CN=London Developers"
Get-ChildItem
