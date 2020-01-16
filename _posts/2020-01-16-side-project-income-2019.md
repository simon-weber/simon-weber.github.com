---
layout: post
title: "Side project income 2019"
description: "A look back on my fourth year of running a software business."
tags: "annual-summaries"
---

{{ page.title }}
----------------

<p class="meta">January 15 2020</p>

2019 was my fourth year running my own small software business.
I also [quit my job](/2019/04/26/leaving-venmo-after-five-years.html) in the spring!
I'm now self-employed but spend most of my time consulting, so I still consider the business to be "on the side".
Here's my active projects as of the end of the year:

* [Autoplaylists for Google Music](https://autoplaylists.simon.codes/): iTunes Smart Playlists for Google Music.
* [Autoresponder for Google Hangouts](https://gchat.simon.codes/): vacation/out-of-office replies for Google Chat.
* [Kleroteria](https://www.kleroteria.org/): an email lottery and spiritual successor to The Listserve.
* [Repominder](https://www.repominder.com/): release reminders for open source projects.
* [NYC Park Alerts](https://parks.simon.codes/):  closure notifications about NYC Parks locations.
* [Plugserv](https://www.plugserv.com/): an ad server for my own projects.

### Financials

This was my first down year:

* annual revenue decreased from $3600 to $3330
* annual expenses grew slightly from $240 to $280
* monthly recurring revenue dropped substantially from $350 to $250

Autoplaylists and Autoresponder - which make up nearly all my revenue - both extend Google products that are being shut down, so I had actually expected more of a decline.
While I [began diversifying in 2018](/2019/01/07/side-project-income-2018.html), those efforts haven't yet impacted the bottom line.

### New Projects

I added two smaller projects last year.
NYC Park Alerts was inspired by my gym habits, of all things.
I work out at a local rec center and showed up a few times to find it unexpectedly closed.
Looking into it, I found that the city posts updates online but with no way to subscribe to them.
So, I set up a scraper that lets people receive emails when locations of their choice are affected.
It's got one user (besides me) and is more of a community service, so I don't expect to ever make money off it.

<p>
My second new project was Plugserv.
It's a tiny ad server that helps me shamelessly plug my projects across my own sites.
Here's a live example of what it looks like: "<span id="example-plug"></span>"
Behind the scenes that copy is being retrieved from the Plugserv api, which handles rotation and tracking.
It's performed better than I expected: in the six months it's been active it's served ~25k ads with a click through rate of over 1%, which beats most display ad benchmarks.
Despite working well for me it hasn't picked up any other users; go <a href="https://www.plugserv.com/">check it out</a> if you'd like to run your own ads on your own sites!
</p>

### Existing Projects

2019 was also the first year I stopped running any projects.
I'm usually content to let projects run despite low usage because my expenses are so low.
But, I made an exception for Analytics for Google Payments:
despite being free to run and having potential with business customers, it was painful to maintain and targeted a much smaller market than I expected.

[MinMaxMeals](https://www.minmaxmeals.com/), my cooking site, was more of a case of lost interest.
Its recipes were heavily optimized for time, which isn't as important to me now that I'm self-employed and work from home.
It's still a fun talking point, though, and I might return to it someday.

My remaining projects both grew slowly without my involvement.
Repominder picked up a notable open source power user and Kleroteria added about 500 subscribers.

Though I didn't do much marketing or feature work, I did spend some time on operational improvements.
I consolidated my sundry virtual servers into a fleet of $2/month instances at [BuyVM](https://my.frantech.ca/aff.php?aff=3397).
Each runs a new NixOS+docker setup that's generic enough to be cloned for new projects.
I also upgraded everything to Python 3 and worked out a better way to route my custom-domain emails into Gmail for cheap (which I'll write up eventually).

### Reflection

2019 had its ups and downs, but now that I'm settled into my new lifestyle I'm feeling ready for 2020.
I don't expect it to be easy, though: Autoplaylists and Autoresponder are likely to shut down completely, and there's a real chance I'll find myself in the red.

So, hopefully my upcoming projects can prevent this.
One of these - hosted server/application monitoring with unusually low operating costs - should launch soon, so sign up below if you'd like to get notified about it!

As always, thanks for following along and feel free to reach out with questions.
If you'd like to read my previous annual summaries, they're available [here](/annual-summaries).

<script>
  window.plugserv_config = {
    elementId: 'example-plug',
    endpoint: 'https://www.plugserv.com/serve/eb7e777e-9ec5-4323-acba-4e05f881cf42'
  };
</script>

<script async
  src="https://www.plugserv.com/js/v1/plugserv.js"
  integrity="sha384-Ngv41QqyGqgFyjzQseAmANPgTafxpqZ3fRcQXsShP02KwdzUy9VzIrp/ARgmFEql"
  crossorigin="anonymous">
</script>
