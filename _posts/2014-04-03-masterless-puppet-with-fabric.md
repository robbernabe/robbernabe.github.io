---
layout: post
title: "Masterless Puppet with Fabric"
date: 2014-04-03T11:07:37-04:00
updated: 2014-04-03T11:07:37-04:00
comments: True
tags:
  - fabric
  - puppet
  - bastion
---

Sometimes you have a small environment and don't require a Puppetmaster.  In cases like these,
I like using Fabric to complement my workflow. Here's a nice example of such a workflow:

<script src="https://gist.github.com/robbernabe/9956109.js"></script>

This small environment disallows public SSH access (except for the dev server), and instead all 
SSH access must be proxied through the bastion host. This is easily accomplished in your ~/.ssh/config file with a stanza like:

    {% highlight bash %}
Host dev
  HostName dev.test
  User rob
  ForwardAgent yes
  ProxyCommand  ssh rob@bastion-01.test nc %h %p {% endhighlight %}

Fabric will obey your ~/.ssh/config as long as you specify:

    {% highlight python %}
env.use_ssh_config = True{% endhighlight %}

However, in order to get the rsync_project task to work properly, you'll need to set the proper "ssh_opts".
