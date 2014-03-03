# The original code for this is courtesy of 
# http://blog.darkrefraction.com/2012/jekyll-excerpt-plugin.html

module JekyllPlugin

  class Excerpt < Liquid::Block

    def render(context)
      # Get the current post's post object
      id = context["page"]["id"]
      posts = context.registers[:site].posts

      post = posts[posts.index {|post| post.id == id}]

      # Put the block contents into the post's excerpt field,
      postdata = super
      post.data["excerpt"] = postdata

      # Put the same contents into the page variable as well so it can be
      # accessed from more places
      context["page"]["excerpt"] = postdata

      # Render excerpt markdown to html here instead of in a template so we
      # so we can modify the opening p tag to include a css 'excerpt' class
      html = Maruku.new(postdata).to_html.sub('<p>', '<p class="excerpt">')
    end
  end

end

Liquid::Template.register_tag('excerpt', JekyllPlugin::Excerpt)
