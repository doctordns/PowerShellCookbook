$Message = Read-host 'Commit message?'
Git status
Git add *

Git commit -m $message
Git push -u origin master


# to add AND commit
git commit -am $message
# TO pull stuff down
Git fetch