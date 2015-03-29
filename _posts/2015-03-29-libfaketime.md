---
layout: post
title: "python-libfaketime"
description: "python-libfaketime is a fast alternative to other datetime-mocking libraries."
---

{{ page.title }}
----------------

<p class="meta">March 29, 2015</p>

I recently released [python-libfaketime](https://github.com/simon-weber/python-libfaketime), which makes it easy to mock the current time during tests.
It's also two orders of magnitude faster than [freezegun](https://github.com/spulec/freezegun) on my laptop.
This is because instead of searching for and monkeypatching imported python stdlib modules, python-libfaketime uses [libfaketime](https://github.com/wolfcw/libfaketime) to intercept c standard library calls.

Here's how it works:

* the user sets an environment variable requesting that the dynamic linker prioritize libfaketime over the c standard library (eg LD_PRELOAD on linux)
* python-libfaketime communicates the datetime to libfaketime through another environment variable

The second step is seamless to end users, but the first step can be annoying.
To make this easier, python-libfaketime provides a function to modify the environment and re-exec the current process.

Give it a try if you notice slow tests while using freezegun -- it made the Venmo test suite about 20% faster.
