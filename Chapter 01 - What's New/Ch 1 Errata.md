# Errata - Chapter 1 - What's New


### Page 10, information note in Step 1 in How To Do It 
Should read:  

    Show-Command is not available in the Server Core version, as it lacks

### Page 27, step 10 
Code should read:
    
    $TextToParse = @'
    Animal, Bird
    Shape like Square
    Number is 42
    Person named Bob
    '@
    $Template1 = @'
    {[string]Category*:Animal}, {[string]Example:Bird}
    '@
    ConvertFrom-String -TemplateContent $Template1 `
       -InputObject $TextToParse

### Page 35, step 23 
Code should read:

    New-Item -ItemType Directory `
             -Path $env:HOMEDRIVE\DownloadedModules
    $Path = "$env:HOMEDRIVE\DownloadedModules"
    Save-Module -Name TreeSize `
                -Path $PATH
    Get-ChildItem -Path "$env:HOMEDRIVE\DownloadedModules" -Recurse

### Page 53, step 2
After clicking on the Create New Feed button, you may see a request for your login details. An extra step showing the login dialog should have been present.

### Page 56 - Step 7
If you have not previously added NuGet to your system, you may see a dialog after issuing the Publish-Module command asking to install NuGet. Either select yes, or use -Force with Publish-Module, like this:

    Publish-Module -Name Pester -Repository MyPowerShellPackages `
       -NuGetApiKey "Admin:Admin" `
       -Force
Also in this step - publishing Pester (in PowerShell V5) can generate a warning message:  
**WARNING: The module manifest member 'ModuleToProcess' has been deprecated. Use the 'RootModule' member instead.**

To resolve this issue, before publishing the module, edit the Pester.PSD1 file, changing line 5 from:

    ModuleToProcess = 'Pester.psm1'

to:
    
    RootModule = 'Pester.psm1'

The .PSM1 file is at:

    C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0\Pester.psm1

### Page 56 - Step 8

If the `C:\Foo` folder already exists this step can error.  
Change to read:

    Find-Module -Name Carbon -Repository PSGallery
    If (-Not (Test-Path -path 'c:\foo'))
    {
       New-Item -ItemType Directory -Path 'C:\Foo'
    }
    Save-Module -Name Carbon -Path C:\foo
    Publish-Module -Path C:\Foo\Carbon `
                   -Repository MyPowerShellPackages `
                   -NuGetApiKey "Admin:Admin"
    
### Page 56 - Step 8

Code should read:

    Find-Module -Name Carbon -Repository PSGallery
    If (-Not (Test-Path -Path 'C:\foo'))
     {
        New-Item -ItemType Directory -Path 'C:\Foo'
     }
    Save-Module -Name Carbon -Path C:\foo
    Publish-Module -Path C:\Foo\Carbon `
                   -Repository MyPowerShellPackages `
                   -NuGetApiKey "Admin:Admin"
    

Also, publishing the Carbon module into the local repository can create a warning message:

**WARNING: This module 'C:\Users\<username>\AppData\Local\Temp\2068058682\Carbon\Carbon.psd1' has exported
DscResources. As a best practice, include exported DSC resources in the module manifest
file(.psd1). If your PowerShell version is higher than 5.0, run Update-ModuleManifest -DscResourcesToExport to update the manifest with ExportedDscResources field.`**

If you plan to use this module, then update the module manifest for this module (or download an updated version).


