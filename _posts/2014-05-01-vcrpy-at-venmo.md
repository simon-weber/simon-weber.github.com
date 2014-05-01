---
layout: post
title: "VCR.py at Venmo"
description: "How we use VCR.py at Venmo to speed up our tests."
---

{{ page.title }}
----------------

<p class="meta">May 1 2014</p>

Recently at Venmo, I spent some time improving our Python test suite.
It was in pretty bad shape when I arrived: builds took 45 minutes and tests were flaky.
Now, builds take 6 minutes and are much more dependable.

I was asked to write up some blog posts describing our changes, and I decided to start with mocking external interactions.
The full post is at the [Venmo engineering blog](http://venmo.github.io/blog/2014/04/30/vcrpy-at-venmo/).
Hopefully it's helpful! Feel free to email me with questions.
