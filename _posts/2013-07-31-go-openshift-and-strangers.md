---
layout: post
title: Strangers, Go, and Openshift
description: My thoughts on Golang and Openshift after finishing Strangerbotting.
---

{{ page.title }}
----------------

<p class="meta">July 31 2013</p>

I've always liked the idea of [Omegle](http://omegle.com): one-on-one text chats with strangers.
I also hang out in irc a lot, and thought it'd be fun to combine the two.
This wasn't a new idea, but since Hacker School is all about learning by exploring,
I built an [Omegle to irc bridge](https://github.com/simon-weber/omegle-to-irc) with Twisted.

When I hooked it up in [#rochack](http://rochack.org/),
someone had the idea to have the stranger talk to our resident markov chain bot.
The stranger had no way to know they were talking to a bot, and hilarity ensued.

The thing was, only folks in our channel could watch.
To share this, I built [Strangerbotting](http://strangerbotting-simonmweber.rhcloud.com).
It's written in Go, and runs on Openshift, Red Hat's newish open source PaaS.
There are a couple of pieces to the app:

* [gomegle](https://github.com/simon-weber/gomegle): a client library for Omegle
* [gomarkov](https://github.com/simon-weber/gomarkov): simple, fast, in-memory markov chains for text generation
* [strangerbotting-backend](https://github.com/simon-weber/strangerbotting-backend): manages one bot-to-stranger conversation and streams it out over websockets. Runs on Openshift.
* [strangerbotting-frontend](https://github.com/simon-weber/strangerbotting-frontend): a simple webclient to display conversations. Also runs on Openshift.

There's nothing too magical going on in the code, so I won't bother talking about it.
However, I have some new opinions on Go and Openshift that I wanted to write down.

### Golang

Before getting started with Go, I'd seen a lot of folks complain about the more pedantic parts of the language.
To me, this indicates some combination of:

* disagreement with Google's engineering culture
* unfamiliarity with Go's design goals

For example, unused imports in Go raise a compile error.
This reflects both Google's conservative engineering tendencies (they wouldn't want such code checked in),
and the goal of fast compilation (see [here](http://talks.golang.org/2012/splash.article#TOC_7.) for details). 

Maybe it's last summer's Google indoctrination speaking, but I'm fine with these parts of the language.
That said, I still find Go's error handling - which eschews exceptions for multi-value returns - a bit wonky.
For those unfamiliar with the language, here's the relevant part of the Go faq:

<blockquote>
<p>
Why does Go not have exceptions?
</p>

<p>
We believe that coupling exceptions to a control structure, as in the try-catch-finally idiom, results in convoluted code.
It also tends to encourage programmers to label too many ordinary errors, such as failing to open a file, as exceptional.
</p>

<p>
Go takes a different approach.
For plain error handling, Go's multi-value returns make it easy to report an error without overloading the return value.
A canonical error type, coupled with Go's other features, makes error handling pleasant but quite different from that in other languages.
</p>

<p>
Go also has a couple of built-in functions to signal and recover from truly exceptional conditions.
The recovery mechanism is executed only as part of a function's state being torn down after an error, which is sufficient to handle catastrophe but requires no extra control structures and, when used well, can result in clean error-handling code.
</p>
</blockquote>

This means that the majority of function calls get wrapped in a conditional check on a returned error,
which can seem verbose and tedious.
While this certainly required some getting used to, it doesn't bother me anymore.
After all, I end up using a similar number of try/except blocks when writing robust Python code.

What does bother me is the loss of debugging information.
For example, here's an error I received from Go's http client: `Post http://front2.omegle.com/events: EOF`.
The unclear message and lack of a stacktrace left me guessing: is my code broken?
Is Go's?
Maybe it was the server?
I ended up reluctantly grepping the stdlib source, since I didn't even have a line number to go off of.

Thankfully, there's enough to like in Go that I'll put up with some debugging annoyances.
First off, goroutines and selection over channels make for really easy concurrent code.
As somebody who was new to both Twisted- and CSP-style concurrency a month ago, I now greatly prefer the latter.

The stdlib is also pretty decent, even if it can feel somewhat inconsistent.
For example, there's no deque implementation, but there is a one for [suffix arrays](http://golang.org/pkg/index/suffixarray/).
I'm willing to write this off as a combination of Python spoiling me and Go being relatively new.

However, despite its youth, Go's community is fantastic.
The [#go-nuts](http://irc.lc/freenode/go-nuts) channel and [official blog](http://blog.golang.org/) are informative and active,
and [play.golang.org](http://play.golang.org) makes sharing code a breeze.

Overall, I came away pleased with Go, and I'll definitely consider it for backend work in the future.

### Openshift

Openshift, however, left me with mixed feelings.
On one hand, I love the ability to ssh into a PaaS box and have a persistent filesystem.
Rather than futz around with custom buildpacks,
I just downloaded and compiled Nginx to host the [Strangerbotting frontend](http://github.com/simon-weber/strangerbotting-frontend).
Their free tier is generous, too;
I wouldn't have to pay for a three node host/reverse-proxy to redundant backend setup.

However, there's not much else to like.
In particular, their bizarre naming choices are a constant source of confusion.
Apps are the top-level construct.
They are made up of gears (VMs), which run cartridges (buildpacks).

To run the three node architecture I referred to earlier, you don't make an application with three gears, though;
that'd be too easy.
Instead, you need to make three applications, each with one gear.
You see, you only get one "web gear" per application, which the other gears then support
(by eg hosting a database or build system).

Since their docs don't make any of this clear, 
expect to dig around the forums for answers.
Be warned, they've got a very "googling for .NET answers on SO" kind of vibe to them.

I ran into all sorts of other minor difficulties.
For one, there's no official Go cartridge.
There is a Red Hat community catridge, but that's been broken for months now, apparently.
After spending a half a day trying to fix it and cursing at their slow cartridge development system, I gave up.
I'm currently deploying a binary over git, which I'm not too happy about.

These kinds of problems left me with the impression that the service isn't quite there yet.
So, while I won't be paying for Openshift any time soon, I will be rooting for them.
An open source PaaS is a noble goal, and more I always welcome competition for my dollars.
