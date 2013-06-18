---
layout: post
title: "Python protobuf on Google App Engine"
description: How to get the Python protobuf package working on App Engine.
---

{{ page.title }}
----------------

<p class="meta">June 18 2013</p>

Today, if you try to use Google Protocol Buffers on App Engine, you'll run into
an error like this one:
{% highlight python %}
from google.protobuf import descriptor 
ImportError: No module named protobuf
{% endhighlight %}

The problem is that Google's own App Engine apis also use the `google` package namespace,
and they don't include the protobuf package.

Thankfully, there's a simple way to fix this.
First, vendorize the library as you normally would.
I just ripped the `site-packages` folder from a virtualenv into the application root:
{% highlight bash %}
app.py
app.yaml
vendor
├── google
│   └── protobuf...
└── httplib2...
{% endhighlight %}

Then, just add your google directory to the google namespace, and add your
vendor directory to the system path.
I used this bit of code:
{% highlight python %}
import os
import sys

import google  # provided by GAE

# add vendorized protobuf to google namespace package
vendor_dir = os.path.join(os.path.dirname(__file__), 'vendor')
google.__path__.append(os.path.join(vendor_dir, 'google'))

# add vendor path
sys.path.insert(0, vendor_dir)
{% endhighlight %}

That's it!
There's no need for [weird hacks](https://code.google.com/p/protobuf-gae-hack).
