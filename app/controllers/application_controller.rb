class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def render_401
    render 'public/401.html', :status => 401, :layout => false
  end

  def render_404
    render 'public/404.html', :status => 404, :layout => false
  end

end
