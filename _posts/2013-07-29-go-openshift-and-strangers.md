---
layout: post
title: Strangers, Go, and Openshift
description: My thoughts on Golang and Openshift after finishing a project.
---

{{ page.title }}
----------------

<p class="meta">July 30 2013</p>

I've always liked the idea of [Omegle](http://omegle.com): one-on-one text chats with strangers.
I also hang out in irc a lot, and thought it'd be fun to enable pulling a stranger into a channel.
This wasn't a new idea, but since Hacker School is all about learning by exploring,
I built an [omegle to irc bridge](https://github.com/simon-weber/omegle-to-irc) with Twisted.

When I hooked it up in [#rochack](http://rochack.org/),
someone had the idea to pipe the stranger's input to our resident markov chain bot.
Hilarity ensued.

I wanted to be able to share this and had been itching to try Go's CSP-influenced concurrency support,
so I built [Strangerbotting](http://strangerbotting-simonmweber.rhcloud.com).
There are a few pieces to it:
* [gomegle](https://github.com/simon-weber/gomegle): a go client library for Omegle
* [gomarkov](https://github.com/simon-weber/gomarkov): simple, fast, in-memory markov chains for text generation
* [strangerbotting-backend](https://github.com/simon-weber/strangerbotting-backend): manages one bot-to-stranger conversation and streams it out over websockets. Runs on Openshift.
* [strangerbotting-frontend](https://github.com/simon-weber/strangerbotting-frontend): a simple webclient to display conversations. Also runs on Openshift.

There's nothing too magical going on in the code, so I won't bother talking about it.
However, I have some new opinions on Go and Openshift that I wanted to write down.

### Golang

Before getting started with Go, I'd seen a lot of folks complain about the more pedantic parts of the language
(eg "why is an unused import a compile error!?").
To me, this indicates one of:
* disagreement with Google's engineering culture
* unfamiliarity with Go's design goals

First, it's important to realize that Go is a language by Google, for Google;
of course their conservative engineering tendencies show through.
Second, the language was designed to compile quickly, and disallowing unused imports supports this goal
(see [this](http://talks.golang.org/2012/splash.article#TOC_7.) for details). 

However, in spite of my Google indoctrination, I still found error handling a bit wonky.
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

Coming from Python, this philosophy stuck out.
The majority of function calls get wrapped in a conditional check on a returned error, which seems overly verbose and tedious.
This certainly required some getting used to, but now doesn't bother me much.
After all, I end up using a similar number of try/except blocks when writing robust Python code.

What does bother me is the loss of debugging information without exceptions.
For example, here's an error I received from Go's http client: `Post http://front2.omegle.com/events: EOF`.
The unclear message and lack of a stacktrace left me guessing: is my code broken?
Is Go's?
Maybe it was the server?
I ended up reluctantly grepping the stdlib source, since I didn't even have a line number to go off of.

Thankfully, Go's concurrency support makes up for this and then some.
Goroutines and selection over channels make reasoning about concurrency super easy.
Sorry, Twisted: I'm a convert.

The stdlib is pretty decent, but can feel somewhat inconsistent.
Deques?
Nope.
[Suffix arrays](http://golang.org/pkg/index/suffixarray/)?
. . .Yes? Huh.
For now, I'm willing to write this off a combination of Python spoiling me and Go being relatively new.

However, despite its youth, Go's community is fantastic.
I've had nothing but good experiences in `#go-nuts`, and [play.golang.org](http://play.golang.org) is a big win when sharing code.

Overall, I came away pleased with Go, and I think I'll definitely favor it for backend work in the future.

### Openshift

Openshift left me with more mixed feelings.
On one hand, I love the ability to ssh into a PaaS box and have a persistent filesystem.
On the other, their docs are pretty bad.
Then again, the free tier is generous. . .but custom buildpack development is painful.
And, while the community is there, it has a distinct Java/.NET flavor to it.

I feel like I could pick positives and negatives all day long, and in the end it just about cancels out.
I'll be rooting for them, but I don't see myself paying for the service any time soon.
