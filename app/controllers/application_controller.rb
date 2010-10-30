class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  
  def render_404
    render 'public/404.html', :status => 404, :layout => false
  end
end
