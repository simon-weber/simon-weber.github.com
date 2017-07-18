---
layout: post
title: "tabs.executeScript as a content script alternative in Chrome Extensions"
description: "How, when, and why to use executeScript instead of a manifest content script."
---

{{ page.title }}
----------------

<p class="meta">July 17 2017</p>
I just updated [Autoplaylists for Google Music](https://autoplaylists.simon.codes) so it uses `chrome.tabs.executeScript` instead of a manifest content script.
It's only been a few days, but so far it's halved sync problems.
Since I didn't find similar recommendations elsewhere, this post explains what motivated the change and how I went about it.

First, some context on Autoplaylists.
It's a Chrome Extension that adds iTunes-style "smart playlists" to Google Music.
It runs entirely in the browser and makes money from a freemium subscription model (there's more details in [my](/2016/07/11/launching-a-chrome-extension-part-1-taxes-and-legal.html) [business-focused](/2016/07/18/launching-a-chrome-extension-part-2-analytics-and-error-reporting.html) [posts](/2017/01/09/side-project-income-2016-0-to-100.html)).

Since it uses unofficial apis, Autoplaylists depends on communication with a running Google Music tab.
Specifically, it needs to:

* retrieve the Google Music user id at startup
* retrieve the cached library from Google's IndexedDB at startup
* retrieve Google's xsrf cookie at startup, and on-demand (if it expires)

To do this, Autoplaylists previously used a single long-running content script which sent its tab id to the background script after loading.
The background script would use that tab id for any on-demand messages.

This caused a few problems.
First, a tab refresh was required after an install, upgrade, or reload, since the background script would lose the tab id and message passing channel.
This was the worst issue: it'd interrupt syncing for no apparent reason, causing symptoms like [these](https://github.com/simon-weber/Autoplaylists-for-Google-Music/issues/157).
Second, the background script had no way of knowing when tabs closed without messaging them.
On-demand messages often ended up going into the void.

My new setup fixes these problems.
The notable changes are:

* the background script has `tabs` permission
* at startup or when detecting a tab opening, the background script will:
  * create a unique script id
  * add a new message listener that detaches itself after receiving a response with the script id
  * executeScript the former content script code (adapted for one-time use)
* the content script code sends responses as before, but includes the script id

This moves the responsibility of running page code from Chrome into the background script.
The added flexibility allows startup-time detection of tabs (after installs/upgrades/reloads), garbage collection of page code after one use, and easier handling of closed tabs for on-demand messages.

It's not a perfect solution.
Aside from the added [complexity of script ids and dynamic event listeners](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/master/src/js/page.js), adding the tabs permission turned out to be costly.
Unexpectedly, it's presented to users as allowing the extension to "view your browsing activity", which is easily misinterpreted as access to history.
Furthermore, Chrome prompts users for all the extension's permissions when just adding one.
The result was a lot of scary prompts and a few negative reviews.
I'm working on setting up a mailing list so I can get in front of changes like these next time.

Overall, though, the costs have been worth it.
I'd recommend executeScript as a manifest content script alternative for extensions with long-running background scripts and on-demand page communication requirements.
In case it's helpful, you can find most of my relevant code in [page.js](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/master/src/js/page.js), and the injected code in [querypage.js](https://github.com/simon-weber/Autoplaylists-for-Google-Music/blob/master/src/js/querypage.js).
As always, feel free to reach out on GitHub or via email with questions.
