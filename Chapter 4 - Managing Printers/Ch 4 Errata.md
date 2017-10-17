# Errata - Chapter 4 - Managing Printers


### Page 123, step 3
Should read:  

    Add-PrinterDriver -Name 'NEC Color MultiWriter Class Driver' `
                      -PrinterEnvironment 'Windows x64'

### Page 123, step 4
Should read:  

    Add-Printer -Name SGCP1 `
                -DriverName 'NEC Color MultiWriter Class Driver' `
                -Portname 'Sales_Color'

### Page 123, step 6
Should read:      

    Get-PrinterPort -Name Sales_Color |
        Format-Table -Property Name, Description,
                               PrinterHostAddress, PortNumber `
                     -Autosize
    Get-PrinterDriver -Name NEC* |
        Format-Table -Property Name, Manufacturer,
                               DriverVersion, PrinterEnvironment
    Get-Printer -ComputerName PSRV -Name SGCP1 |
        Format-Table -Property Name, ComputerName,
                               Type, PortName, Location, Shared


### Page 129, step 3
Should read:      

    $Ps = New-Object `
           -TypeName System.Printing.PrintServer `
           -ArgumentList $Permissions


### Page 129, second method, step 2:

Should read:

    $RPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\' +
             'Print\Printers'
    $Spooldir = 'C:\SpoolViaRegistry' # NB: Folder should exist
    Set-ItemProperty -Path $RPath `
                     -Name DefaultSpoolDirectory `
                     -Value 'C:\SpoolViaRegistry'
       

### Page 132 - Step 1

Should read:

    Add-PrinterDriver -Name  `
                      'HP LaserJet 9000 PS Class Driver'

### Page 132 - Step 3

Should read:

    Set-Printer -Name $Printer.Name `
                -DriverName 'HP LaserJet 9000 PS Class Driver'
    
### Page 136 - step 7

Should read:

    $PermType = $flag.name  `
               -Csplit '(?=[A-Z])' -ne '' -join ' '