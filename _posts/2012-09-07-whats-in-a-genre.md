---
layout: post
title: "What's in a genre?"
description: "I briefly analyze the genres in my Google Music library"
---

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.1/jquery.min.js">
</script>

<script type="text/javascript" src="https://www.google.com/jsapi">
</script>

<script type="text/javascript">
$(document).ready(function(){
  google.load('visualization', '1.0', {
    'packages':['corechart'],
    'callback': drawOccurrenceChart
  });

  function drawOccurrenceChart(){
    $.getJSON('/data/occurrences.json', function(data) {
      data.unshift(['Word', 'Occurrences']);
      var table = google.visualization.arrayToDataTable(data);
      var options = { 
        title: 'Frequency of words in genres',
        backgroundColor: {fill:'transparent'}
      };

      var chart = new google.visualization.PieChart(document.getElementById('words_chart'));
      chart.draw(table, options);
    });
  }
});
</script>


{{ page.title }}
----------------

<p class="meta">September 07 2012</p>

I'm taking a course on data mining this semester. Our first assignment: mine some data. The dataset and techniques don't matter; the point is to extract meaning in any way possible. I'm greenhorn data miner; hopefully I'll be able to look back at this post and laugh at my own naivete.

For my dataset I chose my own Google Music library. It's unique, big enough (7600+ songs), and well organized. Plus, it's a cinch to access with my [Google Music api](https://github.com/simon-weber/Unofficial-Google-Music-API).

My analysis was simple: I investigated the occurrences of words in genres. I figured the most frequent words would be genres themselves (eg 'metal' in 'power metal'), but there was also the chance of exposing common adjectives (eg 'post' in 'post-rock' and 'post-metal').

A few lines of Python later, and I had my results. The first thing I noticed: I listen to a lot of metal. A third of my songs are some kind of metal. If you put all the genre words into a hat, you'd pick 'metal' almost a quarter of the time. Next up: 'rock' and 'jazz'. Rounding out the top six are two adjectives - 'alternative' and 'progressive' - as well as 'accompaniment' (as in [Jamey Aebersold](http://en.wikipedia.org/wiki/Jamey_Aebersold)).

Metal bands also claim the longest genres in my library. <a href="http://en.wikipedia.org/wiki/Novembre_(band)">Novembre</a> is the champion, boasting this mouthful: 'Progressive atmospheric doom metal'.

Now that we've figured out I'm a jazz-playing metalhead, let's take a look at the least common words. 'Country' appears only once (and at the risk of sounding one-sided, it labels the fantastic [Slaughter of the Bluegrass](http://en.wikipedia.org/wiki/Slaughter_of_the_bluegrass)). There's a bunch of mispellings, too, like 'reggaer' and 'sountrack'.

Here's a quick chart of all the words I found:

<div id="words_chart" class="eleven columns alpha"> </div>

This assignment turned out to be a surprising amount of fun. For any other music lovers who want to take a dive into their libraries, I've got the [source on GitHub](https://github.com/simon-weber/Google-Music-genre-analysis).
