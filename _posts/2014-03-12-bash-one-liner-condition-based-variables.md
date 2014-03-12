---
layout: post
title: "Bash one-liners: Condition-based variables"
date: 2014-03-12T11:21:27-04:00
updated: 2014-03-12T11:21:27-04:00
comments: True
tags:
- bash
---

Here's a useful way to set variables based on a condition using bash:

    {% highlight bash %}
    [[ $(/bin/ls /etc/init/celery.conf 2> /dev/null ) ]] && CELERY=YES || CELERY=NO {% endhighlight %}

In this case I'm simply checking to see if an upstart configuration file exists, but you can replace with any condition. I like
this method better than a multi-line if statement like so:

    {% highlight bash %}
    if [ -f /etc/init/celery.conf ]; then
        CELERY=YES
    else
        CELERY=NO
    fi {% endhighlight %}

That just looks ugly to me and takes up too much space.
