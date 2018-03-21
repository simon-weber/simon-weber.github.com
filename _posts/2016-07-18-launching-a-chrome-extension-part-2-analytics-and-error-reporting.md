---
layout: post
title: "Publishing your first Chrome Extension, part 2: Analytics and Error Reporting"
description: "The second in a series of posts with advice on publishing Chrome Extensions."
---

{{ page.title }}
----------------

<p class="meta">July 18 2016, updated March 18 2017</p>

*If you're selling an extension, check out my project [Analytics for Google Payments](https://analytics.simon.codes).*

Earlier this year, I launched my first paid Chrome extension: [Autoplaylists for Google Music](https://autoplaylists.simon.codes/).
The non-software work involved - like organizing a beta, wrangling paperwork, and finding users - was a bit daunting to handle solo.
So, to help other first-timers publish their side projects, I'm writing up my experiences and making recommendations.

This post focuses on analytics and error reporting.
For the first post on the tax and legal requirements of selling an extension, see [part 1](/2016/07/11/launching-a-chrome-extension-part-1-taxes-and-legal.html).
If you're interested in reading future posts, consider [subscribing to my RSS feed](http://feeds.feedburner.com/SimonWeber).

### Analytics and Error Reporting

Analytics lets you track how your extension is being used and found, while error reporting lets you find bugs users may not otherwise report.
Without them, you're sticking your head in the sand.

I recommend the free tiers of Google Analytics and Sentry.
If you've used them before, know that there's a bit of extra work involved to make them effective in an extension.

#### Google Analytics

I use [Google Analytics](https://analytics.google.com/) heavily.
It helps me answer questions like:

* how many playlists are users creating?
* how many visits, installs, and subscriptions did a writeup generate?
* how does usage differ between free and paid users?
* how is user growth changing over time?

To handle all this, Analytics runs on my web store page, the extension itself, and [autoplaylists.simon.codes](https://autoplaylists.simon.codes).
They all report into one account as separate properties.

Hooking up the web store and homepage are trivial.
Adding reporting to the Chrome extension itself is a bit more involved: you'll need to use the [Chrome Platform Analytics](https://github.com/GoogleChrome/chrome-platform-analytics/wiki) library.
In addition, be sure to:

* [generate a per-user uuid](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/3f9c5d02e8b34f540171b856e18e1a5180b8afef/src/js/storage.js#L17), [send it with requests](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/3f9c5d02e8b34f540171b856e18e1a5180b8afef/src/js/reporting.js#L58), and [keep it in sync storage](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/3f9c5d02e8b34f540171b856e18e1a5180b8afef/src/js/storage.js#L89)
* create [a privacy policy](https://github.com/simon-weber/Autoplaylists-for-Google-Music/wiki/Frequently-Asked-Questions#privacy-and-security) and clearly link it in your extension
* implement [opt-out](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/master/src/js/privacy.js) and an [opt-out ui](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/master/src/html/privacy.html)

I've linked my code above as examples.

Now that Analytics is running, you should customize it a bit.
The web store is simplest: track installs by setting up a destination goal for "begins with /track\_install".
I plot goal conversions and completions on the same chart and have it emailed to me weekly.
I haven't figured out a good way to track other web store events like reviews and comments.

Customizing reporting for your extension will of course vary based on what you're doing.
I'd recommend at least adding [app views](https://github.com/GoogleChrome/chrome-platform-analytics/wiki#track-app-view-changes) for your UI and an event for loading the extension.
To give you some ideas on what else to track, here are some examples from Autoplaylists:

* to segment paid vs free users: a custom dimension for paid status; custom segments for paid and unpaid.
* to track sync success: events for sync success, failure, and retry; custom segments for users without syncs, without successful syncs, and with at least one successful sync.
* to track onboarding success: a destination goal for playlist creation and required funnel from a zero-playlists event.

#### Sentry

[Sentry](https://getsentry.com) tracks errors coming from your extension.
Hooking up Raven, their client library, is simple: I don't have much to add to [their docs](https://docs.getsentry.com/hosted/clients/javascript/).

Once basic error reporting is working, there are two extra steps you should do every time you publish a new version: create a [Sentry release](https://docs.getsentry.com/hosted/api/releases/post-project-releases/) and upload [source maps](https://docs.getsentry.com/hosted/clients/javascript/sourcemaps/).
These will help you track down exactly which changes introduced an error.
I've written [a script that automates both steps](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/3f9c5d02e8b34f540171b856e18e1a5180b8afef/release.sh#L39) (it also publishes my extension via [Google's web store api](https://developer.chrome.com/webstore/using_webstore_api)).

Keep in mind that Raven will only automatically collect exceptions, which Chrome apis don't raise (they use lastError instead).
I've written  [a decorator](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/3f9c5d02e8b34f540171b856e18e1a5180b8afef/src/js/chrometools.js#L7) that will automatically send these errors to Sentry as well.

Finally, here are some parting tips:

* if you use custom dimensions with Analytics, you'll want to add that information to Raven's [user context](https://docs.getsentry.com/hosted/learn/context/) as well. 
* consider [wrapping Raven](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/master/src/js/reporting.js) to make it accessible across background, UI, and context scripts.

Feel free to shoot me an email if I can help with anything: <a href="mailto:simon@simonmweber.com">simon@simonmweber.com</a>.
