# Archive.PS1 - Demonstrates Zip/UnZip
Get-ChildItem    -Path C:\Foo\Zip
Compress-archive -Path C:\Foo\Zip\*.txt -DestinationPath C:\Foo\zip\zip.zip
Get-ChildItem    -Path C:\Foo\*.Zip
Expand-Archive   -Path C:\foo\zip\zip.zip -DestinationPath C:\Foo\Zip\Outzip
Get-ChildItem    -Path C:\Foo\Zip\Outzip