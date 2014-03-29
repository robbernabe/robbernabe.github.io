---
layout: post
title: "Multi-machine Vagrant Environments"
date: 2014-03-28T16:32:05-04:00
updated: 2014-03-28T16:32:05-04:00
comments: True
tags:
  - vagrant
---

Vagrant is a really powerful tool. I use it frequently for testing various things related 
to my work at <a href="https://www.payperks.com/">PayPerks</a>. One of the most powerful features is multi-machine environments.

Multi-machine environments allow you to recreate any piece of infratstructure with little effort, while using existing provisioning code from your software-defined infrastructure. For example, the Vagrantfile below creates a single application server, two database servers, and a bastion host:

{% highlight ruby %}
# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Multi-machine Vagrantfile inspired by https://gist.github.com/markba/2404910

Vagrant.configure("2") do |config|

  boxes = [
    { :name => :app01,      :ip => "192.168.33.100", :http_fwd => 8880 , :https_fwd => 4443 },
    { :name => :db01,       :ip => "192.168.33.101" },
    { :name => :db02,       :ip => "192.168.33.102" },
    { :name => :bastion01,  :ip => "192.168.33.103" },
  ]

  vm_default = proc do |cnf|
    cnf.vm.box = "precise64"
    cnf.vm.box_url = "http://files.vagrantup.com/precise64.box"
  end

  puppet_default = proc do |puppet|
    puppet.manifest_file  = "site.pp"
    puppet.manifests_path = "manifests"
    puppet.module_path    = "modules"
    puppet.options        = "--verbose --debug"
  end

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      vm_default.call(config)

      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "768"]
        vb.gui = true if opts[:gui]
      end

      config.vm.host_name = "%s.servicekit.io" % opts[:name].to_s

      config.vm.network   "forwarded_port", guest: 80, host: opts[:http_fwd] if opts[:http_fwd]
      config.vm.network   "forwarded_port", guest: 443, host: opts[:https_fwd] if opts[:https_fwd]
      config.vm.network   "private_network", ip: opts[:ip]
      config.vm.provision :shell, path: "install-puppet.sh"

      config.vm.provision :puppet do |puppet|
        puppet_default.call(puppet)
      end

    end
  end

end

{% endhighlight %}

The real magic happens here because of Vagrant's tight integration with various provisioners. With a simple "vagrant up", I can start the process of creating the instances and let the provisioner take over to configure them. In this case, I'm able to utliize the same puppet manifests that I'm using in production to provision this local environment. The result: a copy of this particular piece of infrastructure on my local machine. I <i class="fa-header fa fa-heart"></i> Vagrant :)
