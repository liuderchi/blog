git merge POST DEV --no-ff -m 'merge' \
&& jekyll build \
&& git add -f _site \
&& git commit --amend -m 'push _site content' \
&& git push -f

# jekyll build && git add -f _site && git commit --amend -m 'push _site content' && git push -f
