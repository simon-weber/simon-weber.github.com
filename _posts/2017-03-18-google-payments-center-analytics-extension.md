---
layout: post
title: "Analytics for the Google Payments Center"
description: "Announcing the private beta of a Chrome Extension for the Google Payments Center."
---

{{ page.title }}
----------------

<p class="meta">March 18 2017</p>

*tl;dr [install the extension here](https://analytics.simon.codes).*

If you receive money from Google you're surely familiar with the Google Payments Center.
I deal with it in the context of my subscription Chrome Extension [Autoplaylists for Google Music](https://autoplaylists.simon.codes).

Its main interface is a list of orders:
<div class="figure">
<p><img src="/images/gpc_orders_redacted.png" alt="example Google Payments Center orders"></p>
<p>A screenshot from my account with full order numbers removed.</p>
</div>

This is largely useless for answering business reporting questions such as:

* how many new users purchased this month?
* how many subscriptions churned this month?
* what's the net growth in subscriptions over time?

So, I've created an analytics Chrome Extension to calculate these numbers.
It lets me answer these questions at a glance, like Baremetrics or ChartMogul do for other processors.
Here's the graph it generates for me:
<div class="figure">
<p><img src="/images/gpc_graph.png" alt="the graph generated from my orders"></p>
<p>A screenshot of the extension. Each bar is a monthly breakdown with the trend line showing net growth.</p>
</div>

While it's still rough around the edges, it's already my favorite way to look at order trends.
So, I'm opening it up for a free private beta.
**If you'd like to try it out, [install it here](https://analytics.simon.codes).**

Here's a few more details:

* your order information never leaves your own computer
* subscription products will generate the best graph, but one-time purchases, in-app purchases, Android Apps, Youtube Fan Funding, ad payments, etc will also work
* more metrics are in the works, such as monthly recurring revenue (MRR), failed charges, and life time value (LTV)
* I'm interesting in addressing other pain points as well, such as bulk exporting of statements
* I plan to charge after leaving beta
