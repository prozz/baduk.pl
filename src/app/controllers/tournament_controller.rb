class TournamentController < ApplicationController

  layout "core"

  def index
    @ranks = Rank.find_ordered
    @player = Player.new
    @players = Player.find_confirmed 
  end

  def register
    @player = Player.new(params[:player])
    if @player.save
      Notifictions.deliver_tournament_registration @player.email, @player
      render :partial => 'confirmation', :object => @player
    else
      @ranks = Rank.find_ordered
      render :partial => 'form', :object => @player
    end
  end

  def confirm
    @player = Player.find_by_secret_code(params[:id])
    if @player.nil?
      render :nothing => true, :status => 404
    else
      @player.is_confirmed = true
      @player.save!
    end 
  end

  def unregister
    @player = Player.find_by_secret_code(params[:id])
    if @player.nil?
      render :nothing => true, :status => 404
    else
      @player.destroy
    end
  end

end
