---
layout: post
title: "Chrome extension hacks: Google Music to turntable"
description: Some of the hacks that went into my first Chrome extension. 
---

{{ page.title }}
----------------

<p class="meta">June 5 2013, updated March 18 2017</p>

*If you're selling an extension, check out my project [Analytics for Google Payments](https://analytics.simon.codes).*

I just shipped my first Recurse Center project: a Chrome extension that scratches a personal itch.
I use [turntable.fm](http://turntable.fm) every now and then, which lets me dj music with friends.
There, I can search for a song, and if someone has previously uploaded it, queue it up for everyone to hear.
If turntable doesn't have a song, I can upload a file from my computer.

However, I don't normally have music files on my laptop; my library is kept in Google Music.
So, if turntable was missing a song, I used to:

* open Google Music and sign in
* find and download the song
* switch to turntable and upload it
* delete the file

My extension lets me do this right in turntable.
Now, all I do is click “Upload from Google Music”, find the song and hit upload.
The extension does the same thing behind the scenes.

If this sounds useful, you can get it here: [Turntable Uploader for Google Music™](https://chrome.google.com/webstore/detail/turntable-uploader-for-go/akchbpaepakjnaihbgkdgjjgpdcckapb).
But, this blog post isn't about advertising: I wanted to document all the weird hacks that went into making this work.
If you're already a Chrome extension guru, you may already know this stuff;
it's intended as a post I would have wanted before writing a line of code.

First, a brief intro to Chrome extensions.
If you've written one before, you can probably skip this part.

### Intro to Chrome extensions

Chrome extensions are just normal javascript and html, but with optional extra permissions.
For example, cross domain requests and cookie access are kosher -- you just need the user to approve them.

Your extension can be made up of two different kinds of scripts.
The first is the _background script_ (or _event script_; the same thing but not always running).
This does the heavy lifting, since it gets access to special `chrome.*` apis.
These enable stuff like the cookie access I mentioned earlier.

You can also run a bunch of _content scripts_.
Unlike the background script, these are specific to a certain page.
They get triggered when a tab matches a url pattern you specify (eg `http://turntable.com/*`).
They don't get `chrome.*` access.
They can access the DOM, but run in an _isolated world_ --
basically, they can modify the DOM, but can't mess with other code running on the page.
For example, my content script can't remove an event handler that a turntable script has set up.

At a first glance, content scripts sound pretty limited.
However, you can get around all of the restrictions above with a bit of hackery.
To access `chrome.*` apis, there's a two-way messaging interface to the background script:
you just offload the work there.
Anything json-encodable is fair game for transport.
Even the isolated world isn't bulletproof: with DOM access, you can inject a script tag to get at the global namespace.

My extension uses all three pieces mentioned above: background, content, and injected scripts.
All together, they communicate like this:
{% highlight bash %}
our background script
     ^
     |
     |
   (chrome message passing)
     |
     v
our content script
     ^
     |
     |
   (the dom)
     |
     v
our injected code
     |
     |
   (global namespace)
     |
     v
other code on the page
{% endhighlight %}
 
Now that we know what we have to work with, I'll go over how I addressed each of the big pieces of my solution.

### Getting the Google Music library and downloading songs

I've spent far too much time with the Google Music protocol from my work on [gmusicapi](http://github.com/simon-weber/Unofficial-Google-Music-API), so I already knew which endpoints to hit.

Auth presented a hurdle, though, since it requires either plaintext credentials (yuck) or OAuth (annoying).
I got around this with my extra Chrome host and cookies permissions:
I just have the user open Google Music in another tab, then piggyback on that session.
My requests will automatically send Google cookies, and I just have to grab an xsrf cookie for use in the url.

### Uploading to turntable

This was the toughest nut to crack.
I considered reverse engineering the endpoints that turntable's client page used for uploading, but this had a number of disadvantages:

* the user wouldn't see the upload in the turntable interface
* I don't have the javascript chops to implement a complicated upload protocol
* future protocol changes would break stuff

A better approach: tricking turntable's own clientside code into believing the user had initiated a normal upload.
This makes turntable do all the work, and is business as usual for the user.

After some quality time in the DevTools debugger, a friend of mine (thanks, [Charlie](https://github.com/clehner)!) figured out a way to do this.
turntable uses a third party library called [plupload](http://plupload.com).
Unfortunately, a high level `window.plupload.upload(File)` function isn't accessible; it's hidden inside turntable closures.
However, a similar function is stored directly as a handler on the main file input, meaning that we can spoof an upload with something like `$('..input[file]..').onchange.call(our_File)`.

Since injected code gets around the isolated world restriction, this is totally possible:
we just need to also inject an html5 File containing the desired mp3.

### Getting a File from a Blob

Html5 Blobs are easy to create, and just represent binary data.
Html5 Files, though, can only be created when a user interacts with a file input (here's the [File api docs](http://www.w3.org/TR/FileAPI/), if you want the details).

Luckily, Files aren't much different from Blobs: they just add a filename and date of modification.
Duck typing to the rescue!

{% highlight javascript %}
//b is our Blob
b.name = 'myfile.mp3';
b.lastModifiedDate = new Date();
// tada!
{% endhighlight %}

### Putting it all together

Those are the main hacks. Combining everything, this is about what happens when an upload is requested:

* content script messages the background script with a file id to upload
* background script performs a cross domain request to Google and retrieves a Blob
* background script encodes the Blob as a base64 dataurl
* Blob dataurl (now json-compatible) is messaged back to the content script
* content script injects the entire dataurl, along with code to do the Blob to File spoofing, trigger the plupload code, and clean up when done

From there, I just added a bunch of messaging to get the ui working and a third party library to display the Google Music library.
You can grab my ugly code on [my GitHub](https://github.com/simon-weber/Google-Music-Turntable-Uploader).

I plan to write continue writing posts like these during my time at the Recurse Center, so if you dug this, Twitter or RSS are the best ways to get more.

Many thanks to my fellow Recursers who read over this post: [Leo Franchi](http://lfranchi.com) and [Erik Taubeneck](https://github.com/eriktaubeneck).
