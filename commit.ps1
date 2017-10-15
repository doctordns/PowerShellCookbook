$Message = Read-host 'Commit message?'
Git status
Git add *

Git commit -m $message
Git push -u origin master

# TO pull stuff down
Git fetch