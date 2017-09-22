# Recipe 13-x  Report on HV Servers

# 1. Find  servers in HVServers group
$Members = (Get-vmgroup -name HVServers).VMMembers | sort Name
$Members

# 2. Get details for each VM
Foreach ($VM in $Members)
{

$VMName = ($VM.Name.Split('-')[1].Trim())
# $VMname = $VM.Name

# get Win32_OS details
$os = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $VMName

$OS = Invoke-Command -ComputerName $VMName -ScriptBlock $sb -Credential $Credrk

$ht = [ordered] @{}
$ht.OS    = $OS.Caption
$ht.Arch  = $OS.osarchitecture
$ht.ServP = $OS.ServicePackMajorVersion

New-object PSObject -Property $ht
}

