class GamesController < ApplicationController
  layout 'core'
  verify :method => :post, :only => [ :create ],
         :redirect_to => { :action => :list }

  before_filter :login_required, :only => [ "new", "create", "add_tag", "add_comment", "show_and_add_comment", "set_game_description", "delete" ]

  def not_found
    @page_title = 'Archiwum gier - Nieznaleziono gry'
    render :controller => 'games', :action =>'not_found'
  end

  # ajax stuff {{{
  # ajax call
  def new_game_form
    @game = Game.new
    session[:sgf] = nil
    render :partial => 'form', :object => @game
  end

  # ajax call
  def upload_sgf 
    sgf = params[:sgf].read
    if Game.validate_sgf sgf
      game = Game.new
      game.sgf = sgf
      script = render_to_string(:partial => 'file_uploaded', :locals => { :game => game } )
      session[:sgf] = sgf
    else
      script = render_to_string(:partial => 'file_unrecognized')
    end
    respond_to_parent("document.getElementById('file-form-div').innerHTML = '#{escape_javascript script}';document.getElementById('game_description').focus();")
  end

  # ajax call
  def add_tag
    @game = Game.find(params[:id])
    tag_list = @game.tag_list
    tag_list.add fix_tags(params[:ta][:gs])
    @game.save # no saving simply means tag was empty
    render :partial => 'tag', :collection => tag_list, :locals => { :game => @game } 
  end

  # ajax call
  def remove_tag
    @game = Game.find(params[:id])
    tag_list = @game.tag_list
    tag_list.remove fix_tags(params[:tag])
    @game.save
    render :partial => 'tag', :collection => tag_list, :locals => { :game => @game } 
  end
  
  # ajax call
  def add_comment
    game = Game.find(params[:id])
    comment = Comment.new
    comment.comment = params[:comment]
    comment.author = session[:user]
    comment.game = game
    comment.save # not saving simply means comment was empty
    render :partial => 'comment', :collection => game.comments
  end

  # ajax call
  def set_game_description
    game = Game.find(params[:id])
    old_desc = game.description
    game.description = params[:value]
    if game.save
      render :text => game.description, :layout => false
    else
      render :text => old_desc, :layout => false
    end
  end

 def auto_complete_for_ta_gs
    criteria = '%' + params[:ta][:gs].strip + '%'
    @entries = Tag.find(:all, :conditions => ["upper(name) like upper(?)", criteria], :order => 'name', :limit => 20)
    render :partial=> "autocomplete_tags" 
  end

  # }}}

  def new
    @page_title = "Archiwum gier - Nowa gra"
    session[:sgf] = nil
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
    @game.sgf = session[:sgf]
    @game.owner = session[:user]
    @game.tag_list.add fix_tags(params[:ta][:gs])

    if @game.sgf =~ /WR\[\s*\d\s*p\s*\]/ or @game.sgf =~ /BR\[\s*\d\s*p\s*\]/ 
      @game.tag_list.add "pro"
    end

    if @game.save
      render :partial => 'created', :object => @game
    else
      render :partial => 'form', :object => @game
    end
  end

  def delete
    @game = Game.find(params[:id])
    if @game.owner_id == session[:user].id
      @game.destroy
    end
    redirect_to :action => 'list'
  end

  def index
    list
  end

  def list
    @title_suffix = "Wszystkie"
    @page_title = "Archiwum gier - #{@title_suffix}"
    render_list Game.paginate(:all, :include => 'owner', :order => "uploaded_at desc", :page => params[:page])
  end

  def my
    @title_suffix = "Moje"
    @page_title = "Archiwum gier - #{@title_suffix}"
    if session[:user].nil?
      redirect_to :action => 'list'
    else
      render_list Game.paginate_for_user(session[:user].id, params[:page])
    end
  end
  
  def added_by 
    @user = User.find_by_login(params[:id])
    if @user.nil?
      redirect_to :action => 'list'
    else
      @title_suffix = "dodane przez '#{@user.login}'"
      @page_title = "Archiwum gier - #{@title_suffix}"
      render_list Game.paginate_for_user(@user.id, params[:page])
    end
  end
  
  def tags
    @page_title = "Archiwum gier - Słowa kluczowe"
  end

  def tagged_with
    @title_suffix = "#{params[:id]}"
    @page_title = "Archiwum gier - #{@title_suffix}"
    page = params[:page] || 1
    @results = WillPaginate::Collection.create(page, Game.per_page) do |pager|
      result = Game.find_tagged_with(params[:id], :order => "uploaded_at desc", :limit => pager.per_page, :offset => pager.offset)
      pager.replace(result)
      unless pager.total_entries
        pager.total_entries = Game.find_tagged_with(params[:id]).size
      end
    end
    render_list @results
  end

  def search
    @search = Search.new(:pharse => params[:pharse])
    if @search.save
        @title_suffix = "'#{@search.pharse}'"
        @page_title = "Archiwum gier - #{@title_suffix}"
        render_list Game.paginate(:all, :order => "uploaded_at desc", :conditions => ["sgf ilike ? or description ilike ?", "%#{@search.pharse}%", "%#{@search.pharse}%" ], :page => params[:page])
    else
      index 
    end
  end


  # this one is protected by password, so user will be taken to login page and
  # redirected back to suitable game for commenting, is some anchor required?
  def show_and_add_comment
    show
    render :action => 'show'
  end

  def show
    @game = Game.find(params[:id])
    @page_title = "Archiwum gier - ##{@game.id} - #{@game.description}"
    rescue ActiveRecord::RecordNotFound
      not_found
  end

  def embed
    @embed = true
    player
  end
  
  def player
    @game = Game.find(params[:id])
    @page_title = "Archiwum gier - ##{@game.id} - #{@game.description}"
    render :controller => 'games', :action => 'player', :layout => false
    rescue ActiveRecord::RecordNotFound
      @page_title = 'Nieznaleziono gry'
      render :controller => 'games', :action => 'not_found', :layout => false
  end
  
  def download
    @game = Game.find(params[:id])
    send_data @game.sgf, :filename => "baduk.pl.#{@game.id}.sgf", :type =>  "application/x-go-sgf"
    rescue ActiveRecord::RecordNotFound
      not_found
  end


  protected
    def render_list collection
      @games = collection
      render :action => 'list'
    end

    def fix_tags tags
      t = tags.split(/,/)
      t.each { |tag|
        tag.gsub!(/[^ążźćśęńłóa-zA-Z0-9\s]/, '')
        tag.strip!
      }
      t
    end
end
