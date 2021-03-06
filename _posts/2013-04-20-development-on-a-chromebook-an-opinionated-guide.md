---
layout: post
title: "Development on a Chromebook: an opinionated guide"
description: "My tips to set up a development environment on ChromeOS."
---

{{ page.title }}
----------------

<p class="meta">April 20 2013, last updated January 6 2017</p>

I started using a
[Samsung 550 Chromebook](http://www.google.com/intl/en/chrome/devices/chromebook-samsung-550.html)
as my on-the-go machine two semesters ago. It worked nicely for
taking notes, but I remained a skeptic: how could I ever write code
from a glorified web browser?

Fast forward 6 months: today, I love hacking on my Chromebook, and
I have no problems working offline. It took some effort to get
everything set up, so I’ve put together my recommendations to get
other folks up to speed.

First, a disclaimer: the device was given to me as part of the
[Google Student Ambassador Program](http://www.google.com/intl/en/jobs/students/proscho/programs/uscanada/ambassador/),
and Google pays me for brand advocacy at my school. That said, I’m
*not* getting paid to write this, and this is my advice, not
Google’s. I’m a hacker, not a shill (and I’ll even save hn the work
of linking
[pg’s submarine essay](http://www.paulgraham.com/submarine.html)).

Anyway: let’s get started. It’s easiest to work over ssh, so I’ll
cover this first. Later, I’ll get to working offline. I won’t talk
about cloud development webapps (maybe check out [Nitrous.IO](https://www.nitrous.io)?).
Also, I don’t have any advice if you prefer heavy IDEs; my usual
tools are a terminal and web browser.

### For when you have a good connection

#### ssh

You want
[Secure Shell](https://chrome.google.com/webstore/detail/secure-shell/pnhechapfaindjhompbnflcldabbghjo)
as your ssh client. It’s basically openssh wrapped for
[NaCl](https://developers.google.com/native-client/), with
[hterm](https://groups.google.com/a/chromium.org/group/chromium-hterm)
powering the ui.

It supports everything you’d expect, like key authentication,
per-connection profiles, port forwarding, custom color schemes, and
even your `~/.ssh/config` file (well, probably; mine is simple).

The [chromium-hterm mailing list](http://goo.gl/RYHiK) is where
updates are posted. If you need an upcoming feature *now*, there’s
also a hidden [dev channel](http://goo.gl/cFZlv) (you need to be
logged into an account that’s on the mailing list for this link to
work).

A quick tip: set Secure Shell to ‘Open as Window’, otherwise Chrome
will intercept keyboard shortcuts (which e.g. makes Control-W close
your terminal). You’ll probably also want to set TERM to xterm. The
FAQ (linked below) has the details and is worth reading through:

-   [Secure Shell FAQ](http://goo.gl/3i5AJ)
-   [Solarized colors](https://gist.github.com/johnbender/5018685)
    (run the commands in a DevTools javascript console)

#### vpn

[Legend has it](http://support.google.com/chromeos/bin/answer.py?hl=en&answer=1282338)
that CrOS supports OpenVPN and L2TP/IPsec. However, they're notoriously difficult
to get working in some configurations; I never got mine working.

_edit_: I haven't tried this for about a year, and it seems like 
[the team is making progress](https://code.google.com/p/chromium/issues/detail?id=217624).

#### remote desktop

If you need a graphical environment, you can use
[Chrome Remote Desktop](https://chrome.google.com/webstore/detail/chrome-remote-desktop/gbchcmhmhahfdphkhkmpfmihenigjmpp).
This provides vnc-like functionality across Windows, Mac and Linux,
and can be set up for repeated or one-off access. Note that you
cannot currently remote *into* a Chromebook.

I rarely need this.

#### Crosh Window

Crosh, the built-in CrOS shell, can (and should) usually be
avoided. If you find yourself using it,
[Crosh Window](https://chrome.google.com/webstore/detail/crosh-window/nhbmpbdladcchdhkemlojfjdknjadhmh?hl=en-US)
takes away some of the pain; it fixes the Control-W problem
mentioned earlier and gets you an up-to-date version of hterm.

### For when you’re offline or on a terrible connection

#### GalliumOS

_edit_: <a href="https://galliumos.org/">GalliumOS</a> is a linux distribution that's designed for Chromebooks.
For example, it supported my Pixel's keyboard layout and touchscreen out of the box.
If you're comfortable maintaining your own linux install - or regularly work with VMs - I'd suggest it over crouton.

My setup is a dual-boot installed with chrx, which you can find instructions for <a href="https://wiki.galliumos.org/Installing">here</a>.
If you run into problems, <a href="https://wiki.galliumos.org/Community">the subreddit and irc channel </a> are quite active.

#### crouton

For offline work, you’ll want root access to a local Linux install.
[crouton](https://github.com/dnschneid/crouton) is *by far* the
best way to go about this: it runs Ubuntu in a chroot. This has
security implications (check the README), but you avoid the
performance hit of virtualization, and keep all the CrOS
functionality.

You’ll need to have your Chromebook in developer mode (i.e. rooted)
to use it, which is easy: I just flipped a hardware switch.
The specifics for going about this vary by model, so just
search for instructions. Once in dev mode, you’ll want to hit
Control-D on each boot to skip the “you’re in developer mode”
warning (there’s a 30-second wait otherwise). Have faith: this
isn’t nearly as annoying as it sounds.

The crouton README has all the information you need to get started.
Note that you can run a normal graphical environment (e.g. Xfce)
alongside CrOS. I prefer using Secure Shell to ssh into localhost
so I can keep my terminal customizations and stay in CrOS. If this
sounds appealing, here’s what I did:

-   used the crouton cli-extra target (eg
    `crouton -t cli-extra ...`).
-   installed openssh in my chroot
-   start sshd, then use Secure Shell to connect to
    my-user@localhost

To make life a bit easier, I stuck `/etc/init.d/ssh start` into my
chroot’s `/etc/rc.local` (which crouton runs upon mounting). Now,
when I want to work locally, I just Control-Alt-Forward to get my
local shell, `$ sudo enter-chroot`, Control-Alt-Back to CrOS and
then run Secure Shell. You could probably get your chroot to mount
and run sshd on boot if you use it all the time.

#### mosh

As an alternative to ssh on flaky connections, you can use [mosh](http://mosh.mit.edu/).
It'll need to be installed on your server to use it.

_edit_: I used to recommend running it inside crouton, but
there's now a proper
[mosh Chrome packaged app](https://chrome.google.com/webstore/detail/mosh/ooiklbnjmhbcgemelgfhaeaocllobloj?hl=en).


### Parting words

_edit_: [zRAM](http://gigaom.com/2013/04/05/running-out-of-memory-on-a-chromebook-heres-a-30-second-solution/)
is now enabled by default, so you don't need to worry about turning it on yourself.

If you’re a fellow Chromebook hacker and think I missed something,
definitely let me know. I’ll do my best to keep this guide updated
as better tools arrive.

_edit_: here's a link to the [hn discussion](https://news.ycombinator.com/item?id=5582531).
