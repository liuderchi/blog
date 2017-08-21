---
layout:     post
title:      How I Contribute To Atom From Scratch
abstract:   Notes about how to contribute to famous editor Atom.
tags:       open-source atom review
---


### Abstract

  - This article is more like a note about *how I contribute* to popular open source software -- Atom -- from little
  - I would try to make it easy to understand
  - I want to encourage those passionate with open source but don’t know how to start.

---

### Starting as an User

  - Time is always the most valuable for developer so I like to discovering productivity tools to save time
      - what do i need in ATOM
          - code: auto-complete, snippet, linting...
          - document: markdown utils/highlighting, text folding like what workflowy offers
  - I like to discover packages in Atom pages
      - try to describe my needs and convert them into key words
  - Atom encourage user to discover it's power and customize it
  - *[flight-manual]* is a good starting point
      - discover more functionalities to make your life easier
      - tutorial about building hello-world package from boilerplate
          - i took some time to go through it (fm version 1.0)

---

### Play around with API

  - most fun part: try to play around the rich APIs
      - e.g. insert template with date in markdown, move cursor to some place you want
  - Atom provide a playful interface --- `init.coffee` so we can play with API with ease
      - you can implement custom command on the fly
  - I let my `init.coffee` start to grow large
      - plugin of text manipulation in markdown
  - a good starting point to satisfy what I need to enhance productivity

---

### Discovering Issues

  - now I can try to enhance my ux/productivity
      - by discovering Atom built-in (config, hotkey, snippet, stylesheet)
      - by discovering 3rd package
      - by customizing my own command in `init.coffee` with help of API doc
  - but sometimes we are still unsatisfied
      - I want to open file without toggling tree view
          - discover it on issue, join discussion
          - looking into source, found that core function is prepared
  - try to *reuse* functions from source
      - POC in `init.coffee`
          - feedback on issue page

---

### Sending Pull Request

  - I've found that I can start to contribute!
      - just require some refactoring and reuse some inner help function
      - discuss on issue page
  - prepare dev env/tools
      - fork repo, sync it with upstream
      - link,
      - CoffeeScript linter
  - wrap some code and then commits
      - learn and refactor Coffee Script
          - takes time to understand it
      - So happy it works after some iteration!
      - refactoring commits message
          - commits often, with little changes
          - commits message style guide
          - use interactive rebase to get commits tidy
  - create PR for reviewing
      - fixing typo/syntax by comments/reviews
  - create spec is hard but I feel like I'm close to it
      - learning from reading other's code
      - learning `jasmine`, BDD
      - learning `Travis CI`
  - interact with reviewer
      - don't be afraid to discuss/notify with reviewer
          - they are busy so try to keep in contact with them
      - so happy to see it merged then go in beta/stable

---

### Conclusion

  - starts from one open source you like to use
      - better if you use it every day
      - better if it has friendly document
          - since I can easily play with it so I can keep follow on it
      - better if it has supportive community
  - watch and learn from open source
      - how to write spec
      - how to contribute to Issue
      - how to send PR
  - yes you can contribute, Atom prepares simple issue tag for anyone in interest
      - tips on issue query
          - *help-wanted*
          - sort by most comments
          - `q=is%3Aopen+is%3Aissue+label%3Ahelp-wanted+sort%3Acomments-desc`
      - core packages require many helps (issue and PR)


[flight-manual]: https://flight-manual.atom.io/
