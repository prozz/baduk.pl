class StaticContentController < ApplicationController
  NO_CACHE = [] # all will be cached
  TITLES = { "whatsnew" => "Co nowego?", "faq" => "FAQ", "contact" => "Kontakt" }.freeze

  def index
    @page_title = TITLES[params[:path].to_s]
    if template_exists? path = 'static_content/' + params[:path].to_s
      render_cached path
    elsif template_exists? path += '/index'
      render_cached path
    else
      raise ::ActionController::RoutingError, "Recognition failed for #{request.path.inspect}"
    end
  end

  private
  def render_cached(path)
    if NO_CACHE.include? path
      render :template => path
    else
      key = path.gsub('/', '-')
      unless content = read_fragment(key)
        content = render_to_string :template => path, :layout => false
        write_fragment(key, content)
      end
      render :text => content, :layout => true
    end
  end

end
