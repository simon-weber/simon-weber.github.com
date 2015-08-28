---
layout: post
title: "Python linting at Venmo"
description: "I go over our combination of Python linting tools."
---

{{ page.title }}
----------------

<p class="meta">August 28, 2015<br/>
cross-posted at the <a href="https://venmo-blog.squarespace.com/2015/8/26/python-linting-at-venmo">Venmo blog</a>
</p>

Quick! What’s wrong with this (contrived) Python 2 code?

{% highlight python %}
import sys

class NotFoundError(Exception):
   pass

def enforce_presence(key, entries):
   """Raise NotFoundError if key is not in entries."""

   for entry in entries:
       if entry == key:
           break
   else:
       NotFoundError
{% endhighlight %}
           
If you said the unused import and missing `raise` keyword, you’re right!
But, if you took longer than a quarter of a second to answer, sorry: you were outperformed by my linting tools.

Don’t feel bad! Linting is designed to detect these problems more quickly and consistently than a human.
There are two ways to make use of it: manually or automatically.
The former is flexible but not robust, while the latter risks getting in the way.
We lint automatically at Venmo; here’s how we strike a balance between flexibility and enforcement.

We use a collection of linting tools.
Currently we use [flake8](https://flake8.readthedocs.org), [pylint](http://www.pylint.org/) and a custom internal tool.
They each address different needs: flake8 quickly catches simple errors (like the unused import), pylint slowly catches complex errors (like the missing `raise`), and our internal tool catches errors that are only relevant to Venmo.
For easy use from the shell, we combine their output with [git-lint](https://github.com/sk-/git-lint) and a [short script](https://gist.github.com/simon-weber/cfb1dcb3118135714abc).
This setup catches a wide variety of errors and can easily accommodate new linters.
Here’s what it looks like when run on the code from this post:

{% highlight bash %}
$ ./lint example.py
Linting file: example.py FAILURE
line 1, col 1: [F401]: 'sys' imported but unused
line 15, col 8: Warning: [W0104]: Statement seems to have no effect
{% endhighlight %}

Linting happens in three places during our workflow: in-editor, pre-commit, and during builds.
The first step varies for each of us since we don’t all use the same editor (though vim with [syntastic](https://github.com/scrooloose/syntastic) is a common choice).
This is the step with the fastest feedback loop: if you don’t currently use linting, start with this.

The second step is implemented with a git [pre-commit hook](https://gist.github.com/simon-weber/b056db8cfa81e08ac67d).
It lints all the files about to be committed and aborts the commit if there are problems.
Sometimes we opt out of this check - maybe we know about the problems and plan to address them later - by using git’s built in `--no-verify` flag.

Finally, any errors that survive to a pull request will be caught during build linting on Jenkins.
It’s similar to the pre-commit check, but runs on all files that have been changed in the feature branch.
However, unlike the pre-commit check, our build script uses GitHub Enterprise’s [comparison api](https://developer.github.com/v3/repos/commits/#compare-two-commits) to find these files.
This eliminates the need to download the repository’s history, allowing us to save bandwidth and disk space with a git shallow clone.

No matter when linting is run, we always operate it at the granularity of an entire file.
This is necessary to catch problems such as unused imports or dead code; these aren’t localized to only modified lines.
It also means that any file that’s been touched recently is free of problems, so it’s rare that we need to fix problems unrelated to our changes.

All of our configuration is checked into git, pinning our desired checks to a specific version of the codebase.
Checks that we want to enable are whitelisted, allowing us to safely update our linters without worrying about accidentally enabling new, unwanted checks.

When enabling a new check, we also fix any existing violations.
This avoids chilling effects: we don’t want to discourage small changes through fear of cleaning up lots of linting violations.
It also incentivizes automated fixes, which saves engineering time compared to distributed manual editing.

Hopefully, sharing our linting workflow helps save you some time as well!
