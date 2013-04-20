---
layout: post
title: "Development on a Chromebook: an opinionated guide"
description: "My recommendations for a Chromebook development environment."
---

{{ page.title }}
----------------

<p class="meta">April 20 2013</p>

I started using a [Samsung 550 Chromebook](http://www.google.com/intl/en/chrome/devices/chromebook-samsung-550.html) as my on-the-go machine two semesters ago.
It worked nicely for taking notes, but I remained a skeptic: how could I ever write code from a glorified web browser?

Fast forward 6 months: today, I love hacking on my Chromebook, and I have no problems working offline.
It took some effort to get everything set up, so I've put together my recommendations to get other folks up to speed.

First, a disclaimer: the device was given to me as part of the [Google Student Ambassador Program](http://www.google.com/intl/en/jobs/students/proscho/programs/uscanada/ambassador/), and Google pays me for brand advocacy at my school.
That said, I'm *not* getting paid to write this, and this is my advice, not Google's.
I'm a hacker, not a shill (and I'll even save hn the work of linking [pg's submarine essay](http://www.paulgraham.com/submarine.html)).

Anyway: let's get started.
It's easiest to work over ssh, so I'll cover this first.
Later, I'll get to working offline.
I won't talk about cloud development webapps because I don't find them useful.
Also, I don't have any advice if you prefer heavy IDEs; my usual tools are a terminal and web browser.

### For when you have a good connection

#### ssh

You want [Secure Shell](https://chrome.google.com/webstore/detail/secure-shell/pnhechapfaindjhompbnflcldabbghjo) as your ssh client.
It's basically openssh wrapped for [NaCl](https://developers.google.com/native-client/), with [hterm](https://groups.google.com/a/chromium.org/group/chromium-hterm) powering the ui.

It supports everything you'd expect, like key authentication, per-connection profiles, port forwarding, custom color schemes, and even your `~/.ssh/config` file (well, probably; mine is simple).

The [chromium-hterm mailing list](http://goo.gl/RYHiK) is where updates are posted.
If you need an upcoming feature _now_, there's also a hidden [dev channel](http://goo.gl/cFZlv) (you need to be logged into an account that's on the mailing list for this link to work).

A quick tip: set Secure Shell to 'Open as Window', otherwise Chrome will intercept keyboard shortcuts (which e.g. makes Control-W close your terminal).
You'll probably also want to set TERM to xterm.
The FAQ (linked below) has the details and is worth reading through:

* [Secure Shell FAQ](http://goo.gl/3i5AJ)
* [Solarized colors](https://gist.github.com/johnbender/5018685) (run the commands in a DevTools javascript console)

#### vpn

[Legend has it](http://support.google.com/chromeos/bin/answer.py?hl=en&answer=1282338) that CrOS supports OpenVPN and L2TP/IPsec.
However, I couldn't get either to work.
If you really need vpn as part of your workflow, be prepared to jump through some hoops.

Granted, my attempts were a few months ago.
The team is working on this, but I haven't seen real progress; for OpenVPN updates, star [this issue](https://code.google.com/p/chromium/issues/detail?id=217624).

#### remote desktop

If you need a graphical environment, you can use [Chrome Remote Desktop](https://chrome.google.com/webstore/detail/chrome-remote-desktop/gbchcmhmhahfdphkhkmpfmihenigjmpp).
This provides vnc-like functionality across Windows, Mac and Linux, and can be set up for repeated or one-off access.
Note that you cannot currently remote _into_ a Chromebook.

I rarely need this.

#### Crosh Window

Crosh, the built-in CrOS shell, can (and should) usually be avoided.
If you find yourself using it, [Crosh Window](https://chrome.google.com/webstore/detail/crosh-window/nhbmpbdladcchdhkemlojfjdknjadhmh?hl=en-US) takes away some of the pain; it fixes the Control-W problem mentioned earlier and gets you an up-to-date version of hterm.

### For when you're offline or on a terrible connection

#### crouton

For offline work, you'll want root access to a local Linux install.
[crouton](https://github.com/dnschneid/crouton) is _by far_ the best way to go about this: it runs Ubuntu in a chroot.
This has security implications (check the README), but you avoid the performance hit of virtualization, and keep all the CrOS functionality.

You'll need to have your Chromebook in developer mode (i.e. rooted) to use it, which is easy: you flip a hardware switch and wipe your device.
The specifics for going about this vary by model, so just search for instructions.
Once in dev mode, you'll want to hit Control-D on each boot to skip the “you're in developer mode” warning (there's a 30-second wait otherwise).
Have faith: this isn't nearly as annoying as it sounds.

The crouton README has all the information you need to get started.
Note that you can run a normal graphical environment (e.g. Xfce) alongside CrOS.
I prefer using Secure Shell to ssh into localhost so I can keep my terminal customizations and stay in CrOS.
If this sounds appealing, here's what I did:

* used the crouton cli-extra target (eg `crouton -t cli-extra ...`). 
* installed openssh in my chroot
* start sshd, then use Secure Shell to connect to my-user@localhost

To make life a bit easier, I stuck `/etc/init.d/ssh start` into my chroot's `/etc/rc.local` (which crouton runs upon mounting).
Now, when I want to work locally, I just Control-Alt-Forward to get my local shell, `$ sudo enter-chroot`, Control-Alt-Back to CrOS and then run Secure Shell.
You could probably get your chroot to mount and run sshd on boot if you use it all the time.

#### mosh

To deal with flaky connections, install [mosh](http://mosh.mit.edu) on your chroot.
You might have to compile it from source to get the most recent features (e.g. `--ssh`), but this isn't a big deal.
You'll need to install it on your server, too (it doesn't require root).

You can use Secure Shell's 'SSH Arguments' to save some typing if you often mosh into a particular machine.

In the future, you probably won't need crouton to use mosh: [there's a NaCl port on GitHub](https://github.com/davidben/mosh-chrome) that mostly works.
I'm hoping to get it ready for Web Store deployment during [Hacker School](https://www.hackerschool.com/) this summer.


If you're a fellow Chromebook hacker and think I missed something, definitely let me know.
I'll do my best to keep this guide updated as better tools arrive.
