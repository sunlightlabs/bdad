class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_analytics

  private

  def render_401
    render 'public/401.html', :status => 401, :layout => false
  end

  def render_404
    render 'public/404.html', :status => 404, :layout => false
  end

  def set_analytics
    @analytics_key = Bdad::Application.config.analytics_key
  end

end
