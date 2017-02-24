---
layout:     post
title:      How I Run Community Project On Github
abstract:   Notes about running a project contributing by community
tags:       open-source atom package translation review
---

### motivation, before repo init
  - as a user, hope Atom can be better, reach more people around the globe
  - i want to have experience running an open source project with community contribution
  - Somebody is doing but it can be better
      - current i18n package supports only single language
      - can we create a package loading content from different source?
  - Somebody need it
      - i18n of several language is missing i18n on [issue](https://github.com/atom/atom/issues/3103)
      - also there are some volunteer for i18n

---

### Tech Aspect
  - current i18n project
      - `atom-japanese-menu`
          - base
          - with 80% content extracted from code
      - `atom-cht-menu`
          - base on `atom-japanese-menu`
          - more complete coverage of i18n
          - code is more complex
      - both not complicated but with one work to do
          - extracted content from code
  - i fork `atom-japanese-menu` and start to extract content from code
      - discover how UI dom is structured
  - features i want to add
      - common data structure for different lang
      - translate more UI items

---

### Maintenance Aspect
  - From TODO to Github *Projects*
      - former way: use plain text `TODO.md` to create TODO List
      - issue is always a good way to manage *actions*
      - Why use *Projects*
          - keeping update `TODO.md` is distracting
              - we need something that we can edit see it changed on the fly
          - there are some tiny *chores* no need to add issue number on it
              - e.g. refactor some function, add blabla to README.md
          - there are some abstract ideas need to be noted
          - We need a higher view to manage the project
              - like what trello did
              - practice kanban?
              - You can reference issue in kanban
  - add CI hook to repo to save time reviewing commit
  - issues
      - use label to classify issues
  - Travis CI may *Block Publishing* using apm
      - github config: disable all options about *Include administrators*
      - safer way to do
          - github config: disable *Protect this branch*
  - [unpublish package](http://sonpham.me/posts/republish-an-atom-package-version)
      - delete commit on local/remote
          - git reset --hard HEAD~
          - git push -f origin master
      - delete tag on local/remote
          - git tag -d v0.1.3
          - git push origin :refs/tags/v0.1.3
      - *IMPORTANT* clear binding with apm registry
          - apm unpublish spacegray-light-neue-ui@0.1.3  # Note 0.1.3 not v0.1.3
      - *OPTIONAL* clear apm cache
          - rm -r ~/.atom/.apm
      - apm publish patch

---

### Public Relation Aspect
  - for volunteer
      - how to find them?
          - atom discussion, issue page
      - prepare `CONTRIBUTING.md` guide
          - refine instruction to let anyone can understand it
          - simplify the process of translation
              - prepare template
              - use prefix to notice what to translate
      - in the PR discussion
          - thank them
      - `README.md`
          - add volunteer name
          - add link to issue to direct volunteer to issue page of their own locale
          - add link to create new issue for new locale
          - think of it as landing page
  - for user
      - promote your package in Atom discussion
      - get feedback from user
          - add reload prompt notice when switching language
