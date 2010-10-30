class WelcomeController < ApplicationController

  def index
    redirect_to new_sketch_path
  end

end
