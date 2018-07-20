# Recipe 7-2
# Get Perf Counters using CIM Cmdlets

#  1. Find Perf related counters in RootzCimV2
Get-Cimclass -ClassName Win32*perf* | Measure-Object
Get-Cimclass -ClassName Win32*perfFormatted* | Measure-Object
Get-Cimclass -ClassName Win32*perfraw* | Measure-Object

# 2. Find key Performance classes
Get-cimclass "win32_PerfFormatted*perfos*" | Select-Object -Property CimClassName
Get-cimclass "win32_PerfFormatted*disk*" | Select-Object -Property CimClassName

# 3. Get Memory counter samples
Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory

# 4. Get CPU counter samples
Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Processor |
    Where Name -eq '_Total'
Get-Ciminstance -ClassName Win32_PerfFormattedData_PerfOS_Processor |
    Select -Property Name, PercentProcessortime

# 5. Get Memory counter samples from a remote system
Get-CimInstance -ClassName Win32_PerfFormattedData_PerfOS_Memory -ComputerName DC1
