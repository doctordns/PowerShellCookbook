#  Recipe 2-1 - Connecting to and managing a Nano Server

#
#  METHOD 1 - Using Nano Server Recovery Console
#

#  This method uses the Nano Server 'GUI' 
#  No PowerShell steps


#
#  METHOD 2 - Using PowerShell Direct
#

# 1. From the Hyper-V host, open PowerShell ISE. List the VMs:
Get-vm -Name N*

# 2. Store the Nano Server VM name and administrator credential in variables:
$NanoComputerName = 'NANO1'
$Credential = Get-Credential `
                 -Message "Enter administrator password for target VM:" `
                 -UserName administrator


# 3. Get the running processes using Invoke-Command via PowerShell Direct:
Invoke-Command -VMName $NanoComputerName `
               -Credential $Credential `
               -ScriptBlock { Get-Process }

# 4. Enter an interactive PowerShell remoting session via PowerShell Direct:
Enter-PSSession -VMName $NanoComputerName -Credential $Credential

# 5. You are connected just like that in a PowerShell remoting session! Create and use
#    a test folder in your Nano server:
New-Item -ItemType Directory -Path C:\foo `
         -ErrorAction SilentlyContinue
Set-Location C:\foo

# 6. Gather information about your server using the new Get-ComputerInfo cmdlet:
Get-ComputerInfo -Property CsName, WindowsEditionId, OSServerLevel, 
                           OSType, OSVersion, WindowsBuildLabEx, 
                           BiosBIOSVersion

# 7. Examine $PSVersionTable, noting the value of the PSEdition property:
$PSVersionTable

# 8. Get the IP Address of your Nano Server, noting it for later recipe steps:
Get-NetIPAddress -AddressFamily IPV4 -InterfaceAlias Ethernet |
    Select-Object -ExpandProperty IPAddress
# 9. If required, change the IP Address of your Nano Server, and display the new IP:
New-NetIPAddress -InterfaceAlias 'Ethernet' `
                 -IPAddress 10.10.10.131 `
                 -PrefixLength 24 `
                 -DefaultGateway 10.10.10.254
Get-NetIPAddress -InterfaceAlias 'Ethernet' -AddressFamily IPv4

# 10. If required, set the DNS of your Nano Server, and display the DNS information:
Set-DnsClientServerAddress -InterfaceAlias 'Ethernet' `
                           -ServerAddresses 10.10.10.10,10.10.10.11
Get-DnsClientServerAddress

# 11. Exit your remoting session:
Exit-PSSession


#
#    MEHOD 3 - USING POWERSHELL REMOTING
#

# 1. PowerShell remoting requires that the remoting target computer IP should be
#    among the TrustedHosts defined on your computer. Add the IP Address of the
#    Nano Server to our computer's TrustedHosts and verify the value:
$NanoServerIP = '10.10.10.131'
Set-Item -Path WSMan:\localhost\Client\TrustedHosts `
         -Value $NanoServerIP -Force
Get-Item -Path WSMan:\localhost\Client\TrustedHosts

# 2. Verify WSMan connectivity to the Nano Server:
Test-WSMan -ComputerName $NanoServerIP

# 3. Connect via PowerShell remoting to the Nano Server:
Enter-PSSession -ComputerName $NanoServerIP `
                -Credential $Credential

# 4. Use Get-ComputerInfo to inspect the Nano Server:
Get-ComputerInfo -Property CsName, WindowsEditionId,
                           OSServerLevel, OSType, OSVersion,
                           WindowsBuildLabEx, BiosBIOSVersion

# 5. Exit your remoting session:
Exit-PSSession


#
#    METHOD 4 - Using WMI with the CIM cmdlets:
#

# 1. Create a new CIM session on the Nano Server, and view the $CimSession object:
$CimSession = New-CimSession -Credential $Credential `
                             -ComputerName $NanoServerIP
$CimSession
# 2. Examine the properties of the Win32_ComputerSystem CIM class:
Get-CimInstance -CimSession $CimSession `
                -ClassName Win32_ComputerSystem |
                        Format-List -Property *

# 3. Count the CIM classes available:
Get-CimClass -CimSession $CimSession | Measure-Object

# 4. View the running processes using the CIM_Process WMI class and a WMI
#    query:
Get-CimInstance -CimSession $CimSession `
                -Query "SELECT * from CIM_Process"

# 5. Remove your CIM Session:
Get-CimSession | Remove-CimSession
