# Recipe 1-3 - Discover new cmdlets in PowerShell 5/5.1
# NB this recipe has steps you do with the GUI presented via Show-GUI
# You should run this from the ISE.

# 1. Investigate Write-Information by looking at the Write-* commands, and
#    help for the about_Redirection topic:
Get-Command -Verb Write -Module *Utility
Get-Help about_Redirection -ShowWindow

# 2 Use Write-Information:
Write-Information 'Test'

# 3. This produces no output. To resolve, you should inspect and change the
#    $InformationPreference variable:
Get-Variable 'InformationPreference'
Set-Variable -Name 'InformationPreference' -Value 'Continue'

# 4. Use Write-Information again:
Write-Information 'Test of Write Information'

# 5. Set $InformationPreference back to default value:
$InformationPreference = 'SilentlyContinue'

# 6. Review the information-related options in the CommonParameters of each
#    command:
Show-Command Get-Item

# 7. Use ConvertFrom-String to get objects from strings; NoteProperties are
#    created with default names:
'Here is a sentence!' | ConvertFrom-String
'Here is a sentence!' | ConvertFrom-String | Get-Member

# 8. Use -PropertyNames to control the names:
'Here is a sentence!' |
    ConvertFrom-String -PropertyNames First,Second,Third,Fourth

# 9. Use -Delimiter to get items from a list:
'Here,is,a,list!' |
    ConvertFrom-String -PropertyNames First,Second,Third,Fourth `
                       -Delimiter ','

# 10 You next test the template capabilities of ConvertFrom-String:
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

# 11. ConvertFrom-String recognizes only one line from the text—the template
#     needs more examples to train the function, so add a second example to the
#     template and test:
$Template2 = @'
{[string]Category*:Animal}, {[string]Example:Bird}
{[string]Category*:Country} like {[string]Example:Italy}
'@
ConvertFrom-String -TemplateContent $Template2 `
                   -InputObject $TextToParse

# 12. Note three lines are recognized, even the last line that is unusual. Adding another
#     example to our template trains the function enough to recognize all four lines:
$Template3 = @'
{[string]Category*:Animal}, {[string]Example:Bird}
{[string]Category*:Country} like {[string]Example:Italy}
{[string]Category*:Number} like {[int]Example:99}
'@
ConvertFrom-String -TemplateContent $Template3 `
                   -InputObject $TextToParse

# 13. Experiment with Format-Hex to output values in hexadecimal:
$TestValue =
@"
This is line 1
and line 2
"@
$TestValue | Format-Hex

# 14. Experiment with Get-ClipBoard and Set-Clipboard by selecting some text,
#     then press Ctrl+C to copy to clipboard, then inspect the clipboard:

# Select this line and press Control-C to copy to clipboard
$Value = Get-Clipboard
$Value

# 15. Use Set-Clipboard to replace the clipboard value, then Ctrl+V to paste that new
#     value:
$NewValue = '#Paste This!'
$NewValue | Set-Clipboard
# Press Control-V to paste!