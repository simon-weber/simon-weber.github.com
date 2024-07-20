---
layout: post
title: gmusicapi retrospective
description: I look back on my work on gmusicapi.
listed: true
---

{{ page.title }}
----------------

<p class="meta">May 14 2013</p>


gmusicapi has come a long way since I pushed my [first commit](https://github.com/simon-weber/Unofficial-Google-Music-API/commit/880fcb3063e5ed3ba7179f1a9c8fda8c41f1dd6a) back in January 2012.


The project has grown more than usual during this semester, since -- for the first time -- I worked on it for school credit.
Here's what I spent my time on:


* a number of big features: scan-and-match support, album art operations, Music Manager OAuth support, python 2.6 compatibility. . .
* a new dynamic testing system for my end-to-end tests
* a huge rewrite to allow for more flexible protocol declarations
* continuous integration that also catches protocol changes
* documentation improvements and a new irc support channel
* version 1.0!


[Github's graphs](https://github.com/simon-weber/Unofficial-Google-Music-API/graphs) provide a quick overview of what I've been up to.
Here are a few other metrics:


* documentation visits x5, bounce rate halved
* PyPi download rate x2
* use in a couple of real-world products


I figure this is a good chance to reflect on some of the decisions I've made, both for my sake and for those who might come this way in the future.


### Don't count out end-to-end testing


I have a few unit tests, but the majority of my tests are end-to-end black-box tests that exercise my clients against actual Google servers.
Naturally, they violate core unit test principles: they're stateful, cannot be run offline, and run slowly.


One thing I've learned while coming to this solution: there's a lot of dogma surrounding test strategies.


It's not that I'm against unit testing.
I'd love to have more unit tests!
Unfortunately, writing them isn't free, and in my case, end-to-end tests offer more bang for my buck.
I get more coverage with less code and get to test my expectations about Google's servers.
gmusicapi is also pretty small, so the loss of granularity when bug-hunting isn't a huge deal.


Of course, there's some extra work required to make your end-to-end tests robust.
Backend flakiness can be addressed with retry and backoff.
Test dependence and state management can be handled with TestNG-like frameworks (I use [Proboscis](http://pythonhosted.org/proboscis/)).
Protocol changes can be caught by validating responses against a schema.


Currently, I have a few Google accounts I use exclusively for testing, and I keep their credentials in TravisCI encrypted variables.
There's one big downside to this: encrypted variables can't be used with other folks' pull requests.
In the future, I hope to figure out a way to safely manage a public test account (I think it's possible with 2-factor auth).


### Invest in support


I have trouble saying no to requests for help.
Interestingly, gmusicapi also seems to attract many users who are new to Python.
Because of these factors, I used to spend a fair amount of time answering support emails.
I didn't mind this, but after receiving a few emails on the same topics, I figured it'd be better to flesh out the [gmusicapi documentation](http://unofficial-google-music-api.readthedocs.org).


Basic questions were addressed with installation and getting starting sections.
These were no-brainers, and I should have added them earlier.


I also added a section for a less obvious topic: people want the reverse-engineered protocols I'm using.
So far, I've thrown together a hack that introspects my protocol declaration code, but I've got plenty of room to improve this.


The [#gmusicapi irc channel on Freenode](http://webchat.freenode.net/?channels=gmusicapi) is another recent support addition.
I wish I'd set it up earlier!
Recently, devs building on gmusicapi have started hanging out and answering questions, which has been a huge help.


I still go the extra mile when I do direct support.
Helping users out is its own reward, but I'm also flattered to have received thank-you emails after irc chats, money, and -- once -- even a gift in the mail!


### Looking forward


I'm very pleased with what I've learned and accomplished so far.
My next step is to get the project into a self-sustaining state.
I figure this means knocking out todos, beefing up internal documentation, and refactoring all of the wonky bits that have accumulated over time.


Thankfully, I'll have plenty of time this summer at the [Recurse Center](https://www.recurse.com)!
