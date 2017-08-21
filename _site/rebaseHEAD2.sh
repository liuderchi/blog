default='DEV'
branch=${1:-$default}

git checkout ./ && git rebase --onto $branch HEAD~2
#git checkout ./ && git rebase --onto DEV HEAD~2
