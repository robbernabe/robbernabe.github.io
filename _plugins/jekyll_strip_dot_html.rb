module Jekyll
  module AssetFilter
    def strip_dot_html(input)      
	  return nil if input.nil?
      if @context.registers[:site].config['strip_dot_html']
        input.gsub(/(.*)\.html$/, '\1')
      else
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
