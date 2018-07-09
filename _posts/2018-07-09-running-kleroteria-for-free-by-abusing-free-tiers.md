---
layout: post
title: "Running Kleroteria for free by (ab)using free tiers"
description: "10k subscribers, 13 services, $0/month."
---

{{ page.title }}
----------------

<p class="meta">July 9 2018</p>

[Kleroteria](https://www.kleroteria.org/) is an email lottery: periodically, a random subscriber is chosen to write to everyone else.
I built it to replace The Listserve, which recently shut down after providing years of advice, hundreds of personal stories, and one impromptu picnic.
It was a fun and personal corner of the internet that I missed immediately.

I suspect the creators of The Listserve just got tired of running it.
First, it was high maintenance: the lottery and post sending was done by hand.
Second, it was expensive: it was powered by MailChimp, which would have cost hundreds of dollars per month given their tens of thousands of subscribers.

I'd need to address these in my replacement.
I figured I could easily run it for little more than the cost of sending emails.
But could I host the entire thing for free?
I wasn't sure, and figuring it out quickly became a personal challenge.

After far too long digging through pricing docs, I came up with a serverless setup run on AWS's indefinitely free tier.
It's illustrative of just how much Amazon gives away, but also how quickly a serverless architecture can get out of hand.

This post lays out my ridiculous thirteen-service setup to inspire future free tier shenanigans.

### Infrastructure shopping

My other side projects are run unceremoniously on cheap virtual private servers.
[Autoresponder](https://gchat.simon.codes/) and [Repominder](https://www.repominder.com/), for example, run on <$1/month deals from lowendbox.
A comparable free offering is Google's f1-micro instance, though I was concerned about bottlenecking on vcpu during signup spikes. 

So, I started looking at serverless options since the free tiers seemed generous.
GCP looked promising, but Google's free email offering was limited to a few thousand sends/month.
I considered Azure as well, but was turned off by the lack of a free hosted database.
AWS ended up providing roughly the same pieces as Google, but with the benefit of 62k free sends/month through SES.

Things were starting to take shape.
I could use Lambda for the backend, DynamoDB for storage (RDS is only free for a year), and SES for email.
Most of the service limits weren't an issue - I'll never need 25GB of storage - but Dynamo throughput was a concern.
It's measured in "capacity units" which boil down to about 25 writes/second and 50 eventually-consistent reads/second.
I needed to make sure I could stay under these limits.

### Dynamo math

Kleroteria stores two things: posts and subscribers.
I decided to use random ids to prevent hot partitions.
The full schemas ended up looking like this:

* pending_posts table:
  * key: randomly-generated id
  * values: contents and status
* subscriber table:
  * key: randomly-generated id
  * values: email address

Post contents are capped such that their rows are less than 4kb.
Subscriber rows, on the other hand, are only ~32b on average.
These row sizes are important, since capacity units are measured in 1kb chunks for writes and 4kb chunks for reads.

For example, consider sending out a post.
This requires a full scan of the subscriber table.
With a table of 10k rows, each under 32b, read in perfect 4kb chunks, a sustained scan at one read capacity unit would require about 40 seconds.
Using 5 rcus, it'd take ~8 seconds.
Similarly, 100k subscribers could be handled in ~20 seconds with 20 rcus.

Selecting a lottery winner is roughly the same thing: a full scan, then random selection.
Originally, I avoided the scan by using a composite primary key.
This involved a two-level index - partitioned by the first character of the id and sorted by the full id - and could select a random item in under two queries.
It turned out not to be worth the trouble, though, since its distribution was biased and the AWS limit of 25 rcus allows for fast enough scans.

The other operations are more straightforward.
Subscribing and unsubscribing, for example, cost 1 wcu each.
Processed synchronously, though, this could cause an issue: beyond 25 signups/second I'd start getting throttled (or worse, charged).
I needed a way to spread out operations during spikes.

### Throttling under service limits

Kleroteria has the luxury of being entirely asynchronous, so I connected everything with SQS queues.
This allows precise throttling by adjusting the queue polling rate.
For example, if subscriptions were sent through a queue consumed at 1 message/second, it'd never exceed 1 wcu.

Dynamo's capacity units aren't the only limit in play, though.
SQS and Lambda both allow only one million free requests/month.
Lambda also constrains runtime and memory usage, and SES has a sending rate limit.
To fit within all of these, I'm currently running:

* 1 scheduled lambda execution / minute
* 30 seconds / lambda execution
* 10 messages / SQS poll
* 10 second wait / SQS poll

This puts me at ~40k executions/month, ~120k polls/month, ~1 wcu, and ~1 email/second, which is pretty conservative.
I plan to increase the message limit once it's been live for a while.

Putting it all together, the pieces involved in subscription handling look like this:

<p>
<pre style="font-family: monospace">
      browser (AWS sdk + Cognito) --> SQS                     
                                       |                      
                                       v                      
      CloudWatch events -----------> Lambda --> Dynamo and SES
</pre>
</p>

Note that the frontend enqueues directly to SQS.
This avoids API Gateway (which isn't free) and per-request Lambda executions.
It comes with a cost, though: javascript must be enabled to sign up, and I can't give users feedback from serverside validation.
I'm hoping this doesn't matter too much in practice.

### Everything else

Astute readers will count six services so far, while I promised thirteen.
The seventh is IAM, which is used for internal access control.
It's always free since it's an essential part of AWS.

The remaining six services aren't from AWS.
One is netlify, used to host the frontend assets.
I've found it comparable to GitHub Pages - my usual choice - though I've noticed surprisingly flaky uptime according to New Relic Synthetics, my external monitoring tool.

The remaining services play supporting roles and don't require much commentary:

* Sentry: error reporting (frontend + lambda)
* Google Analytics: frontend analytics
* BitBucket: private git repo
* CloudFlare: dns (with cdn disabled, since netlify provides one)

### Whew

So, there you have it: thirteen services, tens of thousands of subscribers, $0 per month.
Was it worth it?
Probably not, at least in the context of a side project.
Reading pricing docs, planning Dynamo capacity, and setting up a local environment added days to what should have been a weekend project.
That said, it was a fun challenge and the result is more robust than my usual vps setups.

**[Go join Kleroteria](https://www.kleroteria.org/) so I can justify my effort!**
If you're interested in hearing more about it - or getting notified if I open source it - consider subscribing with the links below.
