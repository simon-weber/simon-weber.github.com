---
layout: post
title: "Publishing your first Chrome Extension, part 1: Taxes and Legal"
description: "The first in a series of posts with advice on publishing Chrome Extensions."
---

{{ page.title }}
----------------

<p class="meta">July 11 2016, updated March 18 2017</p>

*If you're selling an extension, check out my project [Analytics for Google Payments](https://analytics.simon.codes).*

Earlier this year, I launched my first paid Chrome extension: [Autoplaylists for Google Music](https://autoplaylists.simon.codes/).
The non-software work involved - like organizing a beta, wrangling paperwork, and finding users - was a bit daunting to handle solo.
So, to help other first-timers publish their side projects, I'm writing up my experiences and making recommendations.

There's too much to cover in one post, so I'll start with the part that was scariest for me: dealing with the tax and legal implications of selling software.
I'm effectively a small business owner that sells a product, so I've got to follow the rules or risk getting shut down (or worse).
If yours is free, consider [subscribing to my RSS feed](http://feeds.feedburner.com/SimonWeber).
I'll have advice for you in the coming weeks.

Finally, I want to give thanks to [Patrick McKenzie](http://www.kalzumeus.com/).
He generously gave me some pointers on the topics below.
If you find yourself wrestling with something not covered here, do consider his [standing invitation to reach out](http://www.kalzumeus.com/standing-invitation/).


### Tax and Legal Considerations

Disclaimer time!

* I am not a lawyer nor an accountant, so this post cannot be considered professional advice. Think of it as a starting point for your own research or conversations with professionals.
* this is largely specific to the US, though the themes may apply elsewhere.
* if you're making real money, just pay someone to do all this for you.

With that out of the way, here are the main things I did before allowing sales:

* chose a business structure
* prepared to pay income tax
* prepared to pay sales tax
* handled Google's merchant requirements

I'll cover each separately.

#### business structures

I'm running as a sole proprietorship, which is free and simple.
Basically, it means there's no legal distinction between me and the business.
The only additional paperwork was applying for an Employer Identification Number, which I got just to avoid giving out my SSN.
Despite the name, it's applicable even though I have no employees.

Reasons to not use a sole prop include things like desire to raise investor money or concern about getting sued.
In these cases, a C Corp or LLC are likely more appropriate, but you should definitely talk to a lawyer before deciding -- you're in territory my side project likely won't see.

#### income tax

I report income from my extension and pay taxes on that income.
I include the income with my estimated tax, and next year I'll file a Schedule C with the business's total income and expenses.

If your extension makes little money and you typically receive a tax refund, estimated tax might be overkill.

Be sure to keep an excellent record of all your sales and business expenses.
I'd recommend exporting both your earnings report and orders every month, as Google puts slightly different information in each.

#### sales tax

Unlike Apple's App Store, Google's Web Store makes you the merchant of record.
This is both good and bad: it means Google's cut is less than Apple's, but it means you need to handle sales tax.
How this works varies by state, but this is what I did for New York:

* determined that my extension qualified as "pre-made software" for sales tax purposes
* registered for a [Certificate of Authority](https://www.tax.ny.gov/pubs_and_bulls/tg_bulletins/st/how_to_register_for_nys_sales_tax.htm) a month before my first sale
* turned on automatic NY sales tax collection in the Payments Merchant Center

When it's time to file sales tax, I check for sales to NY residents, look up the tax rate based on their address, and file my return online.
This is tedious, but don't let it discourage you: I'm willing to bet New York's requirements are among the worst to deal with.
For example, these sales wouldn't qualify for sales tax in California, and many other states have reporting minimums I'm not likely to hit.

If you publish internationally, you may have to deal with sales tax on a country-by-country basis as well.
For example, there's VAT for Europe (which Google mostly handles for you) and JCT for Japan.
With the amount of money I'm making, it doesn't make sense for me to put much effort into this.

#### Google's requirements

Compared to the government, appeasing Google is pretty straightforward. You'll need:

* your EIN for tax purposes
* $5 for a one-time signup fee
* a business address and email you're comfortable posting publicly
* your bank information for payouts
* a privacy policy hosted somewhere (I use a Github wiki page)

With this you'll create two accounts - a Payments merchant account and a Chrome developer account - and then link them together.
Be sure to go through all the options in your merchant account: they include important settings like the name on users' credit card statements.

---

This all may seem like a lot if you're only making a few bucks a month.
Still, I'd encourage you to go through with it: it took me only a few days in total, and the business experience has been super valuable.
If you find yourself feeling overwhelmed, feel free to shoot me an email.
While I'm far from an expert, I'm happy to help: <a href="mailto:simon@simonmweber.com">simon@simonmweber.com</a>.
