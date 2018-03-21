---
layout: post
title: "Adding a vcs dependency to requirements.txt"
description: "The right way to add a vcs dependency (eg on github or bitbucket) to a pip requirements.txt."
---

{{ page.title }}
----------------

<p class="meta">November 23 2014, updated August 27 2016</p>



It's sometimes useful to point your requirements.txt at code not yet on pypi.
For example, imagine you've just sent a bugfix PR to one of the libraries you depend on.
Instead of waiting for the PR to be merged and packaged, you can temporarily change your dependency to point at your fork.

When adding the dependency line, it's best to provide every field.
Leaving some out can have unexpected effects, like pip installing a different version of the code or recloning it on every run.

Here's an example of a fully-specified requirement line pointing to [gmusicapi](https://github.com/simon-weber/gmusicapi) 4.0.0 on Github:

{% highlight bash %}
git+https://github.com/simon-weber/gmusicapi.git@4.0.0#egg=gmusicapi==4.0.0
{% endhighlight %}

Here's an explanation of each field:

* `git+https://...git`: the vcs type with the repo url appended. https (rather than ssh) is usually how you want to install public code, since it doesn't require keys to be set up on the machine you're running on.
* `@4.0.0`: the git ref to clone. This example points to [the 4.0.0 tag](https://github.com/simon-weber/gmusicapi/releases/tag/4.0.0). You don't need to use a tag - pip will happily use anything that can be checked out, such as a feature branch - but I recommend it to avoid using a ref that will point somewhere else later (like `master` likely would).
* `egg=gmusicapi`: the name of the package. This is the name you'd give to `pip install` (which isn't always the same name as the repo).
* `==4.0.0`: the version of the package. Without this field pip can't tell what version to expect at the repo and will be forced to clone on every run (even if the package is up to date).

If the maintainer doesn't change package versions between releases, you'll want to change it on your branch so pip can tell the difference between your temporary release and the last release. For example, say you contribute a fix to version 1.2.3 of a library. To create your new version, you could:

* branch from your feature branch
* change the version to 1.2.4-rc.1, since it's a release candidate of the bugfixed 1.2.3 release
* use a requirements line like `git+https://github.com/me/lib.git@new_branch#egg=lib==1.2.4-rc.1`
