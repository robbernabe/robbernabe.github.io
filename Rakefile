require "date"
dir = File.expand_path(File.dirname(__FILE__))

task :default => "jekyll:devserver"

def makeslug(title)
    titleslug = title.gsub(" ", '-').gsub(/[^A-Za-z0-9_-]/, '').downcase
    now = DateTime.now
    return "#{now.strftime('%F')}-#{titleslug}"
end

namespace :bundle do
    desc "Update bundles"
    task :install do
        sh "bundle install"
    end
end

namespace :jekyll do
    desc "Generate the site"
    task :generate => "bundle:install" do
        sh "bundle exec jekyll build"
    end

    desc "Run a local development server"
    task :devserver => "bundle:install" do
        sh "bundle exec jekyll serve --watch"
    end
end

namespace :post do
    desc "Create a new post"
    task :new do
        if ENV['title'].nil?
            print "Please enter the post title: "
            ENV['title'] = $stdin.gets
        end
        title = ENV['title'].chomp
        now = DateTime.now
        post = "#{dir}/_posts/#{makeslug(title)}.md"
        File.open(post, 'w') do |f|
            f.write(<<postend)
---
layout: post
title: "#{title}"
date: #{now.strftime('%FT%T%:z')}
updated: #{now.strftime('%FT%T%:z')}
tags:
  - untagged
---

{% excerpt %}
{% endexcerpt %}

postend
        end
        sh "#{ENV['EDITOR']} #{post}"
        # sh "git add #{post}"
    end

    desc "Rename a post"
    task :rename do
        if ENV['old'].nil?
            print "Please enter the filename of the old post: "
            ENV['old'] = $stdin.gets
        end
        if ENV['title'].nil?
            print "Please enter the (new) post title: "
            ENV['title'] = $stdin.gets
        end
        oldpath = "#{dir}/_posts/#{ENV['old'].chomp}"
        title = ENV['title'].chomp
        newpath = "#{dir}/_posts/#{makeslug(title)}.md"

        sh "git mv #{oldpath} #{newpath}"
        sh "sed -i -e 's|^title: \".*\"$|title: \"#{title}\"|' #{newpath}"
    end
end
