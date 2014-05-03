---
layout: post
title: "Tough cookies: a debugging story"
description: "How a simple oversight broke gmusicapi logins"
---

{{ page.title }}
----------------

<p class="meta">February 14 2012</p>

I used to think of (web) cookies as simple key/value pairs.
That was before I spent an hour tracking down a bug in [gmusicapi](http://github.com/simon-weber/Unofficial-Google-Music-API).

The symptoms were simple.
The user would successfully log in.
Then, on their first request to a web service endpoint (eg music.google.com/loadalltracks), Google would reject their request and redirect them to a login page.

The auth code was immediately suspect. However, there were a few complications:
- I could not recreate the issue
- that code hadn’t changed much since last known-good version

The user who reported the bug stopped by #gmusicapi on Freenode (thanks, Leonardo!) and humored my requests for debug information.
Here's what we found out:

* the login was successful; calls to Music Manager endpoints succeeded
* the user was outside of the US
* normal login to music.google.com through a browser was fine
* the bug did not depend on multiple login status, locale assumptions or current login status
* the user had all the proper session cookies

Throughout all this, I still could not recreate the issue.
In a lucky guess, I used a test account from outside the US: bingo!
This only affected non-US logins!

Now that I had a way to recreate the bug, I fired up git bisect to track down the commit that introduced it.
Inside a function to take a [requests.Request](http://docs.python-requests.org/en/latest/) and send it off to Google, here’s the relevant code before:

{% highlight python %}
if send_xt:
    request.params['u'] = 0
    request.params['xt'] = self.get_web_cookie('xt')

# web_cookies is a CookieJar
request.cookies = self.web_cookies

prep_request = request.prepare()
s = requests.Session()
res = s.send(prep_request)

return res
{% endhighlight %}

and after:


{% highlight python %}
if request.cookies is None:
    request.cookies = {}

#Attach auth.
if send_xt:
    request.params['u'] = 0
    request.params['xt'] = self.get_web_cookie('xt')

if send_clientlogin:
    request.cookies['SID'] = self.client.get_sid_token()

if send_sso:
    #dict <- CookieJar
    web_cookies = {c.name: c.value for c in self.web_cookies}
    request.cookies.update(web_cookies)

prepped = request.prepare()
s = requests.Session()

res = s.send(prepped, **session_options)
return res
{% endhighlight %}

The commit was some refactoring from two separate request-sending functions (eg send_web_request and send_musicmanager_request) to one.
Do you see the bug?
Here’s a hint, changing:

{% highlight python %}
web_cookies = {c.name: c.value for c in self.web_cookies}
request.cookies.update(web_cookies)
{% endhighlight %}

to:

{% highlight python %}
request.cookies = self.web_cookies
{% endhighlight %}

solves the problem (hackily, since then clientlogin and sso auth can’t be sent together, but that never happens anyway - and this will all be rewritten soon).

If you didn't figure it out, here's the issue: auth was stored in Python [Cookie objects](http://docs.python.org/2/library/cookie.html#module-Cookie), but I had attached them to the request as a name/value dictionary.
In doing so, there was information loss:

 * in the case of cookies with identical names, only one would be sent
 * Cookie-specific fields like secure and domain were dropped

In their Python form, Cookies are not simple name/value pairs!
Attaching Cookies directly to the request kept all the relevant information and solved the problem.

I’d like to thank Lukasa and SigmaVirus24 on #python-requests for pointing me to the relevant Requests internals, and for generally putting up with my mad raving.
Lukasa also had what I thought was some sharp insight into the situation:

> **simon_weber**: I suppose it would be nice for tear-their-own-hair-out insane folks like me to be able to set both simple and Cookie cookies \[using Requests\]

> **Lukasa**: I think more than that, we want to discourage it.
> Cookies are complicated and easy to get wrong
> (as this entire discussion shows)

> **Lukasa**: And so we'd rather that people use the known-good code in Requests

He’s exactly right, of course, and I already have an entry on my todo list for this (I’ve just got [a lot on my plate](https://github.com/simon-weber/Unofficial-Google-Music-API/issues) at the moment).

At least this story has a happy ending: despite the confusion, gmusicapi soldiers on with [happy international users](https://twitter.com/thiloleibelt/status/302159032922296322).
As for me, having learned from this bug hunt, hopefully I’ll never be suckered into disrespecting the surprising complexity of the cookie - nor their internet cousins of the same name.
