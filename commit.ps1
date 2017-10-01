$Message = Read-host 'Commit message?'
Git add *
Git commit -m $message
Git push -u origin master


# TO pull stuff down
Git pull