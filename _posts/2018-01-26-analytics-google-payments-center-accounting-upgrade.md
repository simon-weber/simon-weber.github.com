---
layout: post
title: "Analytics for the Google Payments Center: accounting data now supported"
description: "Analytics now has access to transactions as well as orders."
---

{{ page.title }}
----------------

<p class="meta">January 26 2018</p>

*tl;dr [sign up for a beta invite](https://goo.gl/forms/1E1pYXKm95QIdR7M2).*

Last year I launched the beta of [Analytics for the Google Payments Center](/2017/03/18/google-payments-center-analytics-extension.html),
a Chrome Extension to help Google merchants make sense of their business metrics.
Today I'm announcing the first major change in a while: full support for accounting data.

Basically, Analytics used to only support order data.
This was useful for tracking subscription metrics like net new subscribers or churn, but didn't help with accounting.
Now, Analytics has access to every transaction, earnings report and VAT invoice, meaning it can answer questions like:

* what's my growth in profit over time?
* how much sales tax did I collect in the last reporting period?
* how much am I paying in Google fees?

Here's an example graph:

<div class="figure">
<p><img src="/images/gpc_earnings.png" alt="the new earnings graph"></p>
<p>A screenshot of the new earnings graph. Each bar is a monthly breakdown with the trend line showing net growth.</p>
</div>

I'm also looking into supporting bulk exports of this new data.
This would combine monthly documents like earnings reports for download all at once, rather than one at a time.

**To get in on the free beta, [sign up here](https://goo.gl/forms/1E1pYXKm95QIdR7M2).**
