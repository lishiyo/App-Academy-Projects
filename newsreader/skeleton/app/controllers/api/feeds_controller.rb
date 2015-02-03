class Api::FeedsController < ApplicationController
  def index
    render :json => Feed.all
  end

  def show
    render :json => Feed.find(params[:id]), include: :latest_entries
  end

  def create
    feed = Feed.find_or_create_by_url(feed_params[:url])
    if feed
      render :json => feed
    else
      render :json => { error: "invalid url" }, status: :unprocessable_entity
    end
  end

  def destroy
    @feed = Feed.find(params[:id])
    @feed.destroy
    render json: nil
  end

  def new
    @feed = Feed.new
    render json: @feed
  end

  def favorite
    @feed = Feed.find(params[:id])
    feedfav = UserFeedFavorite.new(feed_id: @feed.id, user_id: current_user.id)
    if feedfav.save
      render json: feedfav
    else
      render json: feedfav.errors.full_messages
    end
  end

  private

  def feed_params
    params.require(:feed).permit(:title, :url)
  end
end
