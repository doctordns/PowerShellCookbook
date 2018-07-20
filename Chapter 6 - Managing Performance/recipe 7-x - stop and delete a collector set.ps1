$dataCollectorSet = New-Object -ComObject Pla.DataCollectorSet
$dataCollectorSet.Query('SRV1 Collector Set',$null)
$dataCollectorSet.Stop($true)
Sleep 2
$dataCollectorSet.Delete()