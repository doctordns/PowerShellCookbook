# Errata - Chapter 1

###Page 10, information note in Step 1 in How To Do It.
Should read:
Show-Command is not available in the Server Core version, as it lacks


###Page 27, step 10
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
    
    