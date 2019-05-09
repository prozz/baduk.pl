require File.dirname(__FILE__) + '/../spec_helper'

include SpecHelper

describe GamesController, :shared => true do # {{{

  before :each do
    session[:user] = nil
  end

  it "should allow browsing games" do
    get 'index'
    response.should be_success
    response.should render_template('games/list')
    assigns[:games].should_not be_nil
  end

  it "should show tag cloud when needed" do
    get 'list'
    response.should be_success
    assigns[:tags].should_not be_nil
  end

  it "should allow showing all games tagged with some keyword" 
  #do
  #  Game.should_receive(:find_tagged_with).with("keyword").and_return(Game.new)
  #  get 'tagged_with', { :id => 'keyword' }
  #  response.should be_success
  #  assigns[:games].should_not be_nil
  #end
  it "should allow showing single game" do
    game = Game.new valid_game_attributes
    Game.should_receive(:find).with("#{game.id}").and_return(game)
    get 'show', { :id => "#{game.id}" }
    response.should be_success
    response.should render_template('games/show')
    assigns[:game].should eql(game) 
  end

  it "should show 404 page for games that not exists"

  it "should allow downloading chosen games" do
    game = Game.new valid_game_attributes 
    Game.should_receive(:find).with("#{game.id}").and_return(game)
    get 'download', { :id => "#{game.id}" }
    response.should be_success
    response.headers['Content-Type'].should eql('application/x-go-sgf')
    response.headers['Content-Disposition'].should eql("attachment; filename=\"#{game.id}.sgf\"")
  end
end # }}}

describe GamesController, " while logged out" do # {{{
  it_should_behave_like "GamesController"

  before :each do
    session[:user] = nil
  end

  it "should not show form for adding new games" do
    get 'new'
    response.should redirect_to('login')
  end

  it "should not allow creating new game" do
    post 'create', { :some_stupid_params => 'foo' }
    response.should redirect_to('login')
  end
end # }}}

describe GamesController, " while logged in" do # {{{
  it_should_behave_like "GamesController"

  before :each do
    @user = User.new
    @user.attributes = valid_user_attributes
    session[:user] = @user 
  end

  it "should allow adding new games" do
    get 'new'
    response.should be_success
    response.should render_template('games/new')
  end

  it "should allow render new game form via ajax request" do
    get 'new_game_form'
    response.should be_success
    response.should render_template('games/_form')
  end
  it "should allow adding games via pasting (no errors)" do
    attrs = valid_game_attributes.except(:id, :owner).with_stringified_keys
    game = Game.new attrs
    Game.should_receive(:new).with(attrs).and_return(game)
    game.should_receive(:save).and_return(true)
    controller.expect_render(:partial => 'created', :object => game)
    post 'create', { :game => { :description => game.description, :sgf => game.sgf } }
    game.owner.login.should eql(session[:user].login)
  end

  it "should allow adding games via pasting (errors case)" do
    attrs = valid_game_attributes.except(:id, :owner, :description).with_stringified_keys
    game = Game.new attrs
    Game.should_receive(:new).with(attrs).and_return(game)
    game.should_receive(:save).and_return(false)
    controller.expect_render(:partial => 'form', :object => game)
    post 'create', { :game => { :sgf => game.sgf } }
  end

  it "should allow adding games via file upload"

  it "should not break if games is both pasted and file is chosen"

  it "should allow tag a game with some keyword" do 
    game = Game.new 
    tag_list = TagList.new
    Game.should_receive(:find).with("1").and_return(game)
    game.should_receive(:tag_list).and_return(tag_list)
    tag_list.should_receive(:add).with("keyword")
    game.should_receive(:save)
    controller.expect_render(:partial => 'tag', :collection => tag_list)
    post "add_tag", { :id => "1", :tag => "keyword" }
  end

  it "should allow to add comment to a game" do
    comment = Comment.new
    game = Game.new
    Comment.should_receive(:new).and_return(comment)
    Game.should_receive(:find).with("1").and_return(game)
    comment.should_receive(:save)
    controller.expect_render(:partial => 'comment', :collection => game.comments)
    post "add_comment", { :id => "1", :comment => "comment" }
  end

end # }}}
