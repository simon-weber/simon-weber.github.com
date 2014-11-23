---
layout: post
title: "Adding a vcs dependency to requirements.txt"
description: "The right way to add a vcs dependency (eg on github or bitbucket) to a pip requirements.txt."
---

{{ page.title }}
----------------

<p class="meta">November 23 2014</p>

It's sometimes useful to point your requirements.txt at code not yet on the cheeseshop.
For example, imagine you've just sent a bugfix PR to an existing dependency.
Instead of waiting for the PR to be merged, you can just change your dependency to point at your fork.

When adding the dependency line, there are two bits I don't often see people use: the egg declaration and the version.
Leaving these out will make `pip install -r`  reclone and reinstall your package every time, even if it hasn't changed.
Here's an example of setting these when pointing to [gmusicapi](https://github.com/simon-weber/Unofficial-Google-Music-API) 4.0.0 on Github:

{% highlight bash %}
git+https://github.com/simon-weber/Unofficial-Google-Music-API.git@4.0.0#egg=gmusicapi==4.0.0
{% endhighlight %}
