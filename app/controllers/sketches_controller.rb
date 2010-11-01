class SketchesController < ApplicationController
  before_filter :set_gallery, :only => [:show, :edit, :new]
  include SketchesHelper

  def index
    @sketches = Sketch.recent
  end

  def show
    @sketch = Sketch.where(:token => params[:id]).first
    render_404 && return unless @sketch
  end

  def edit
    @sketch = Sketch.where(:token => params[:id]).first
    render_404 && return unless @sketch
  end

  def new
    district = random_district
    @sketch = Sketch.new({
      :district => district,
      :title    => fun_title(district),
      :byline   => "Your Name Here",
    })
  end

  def create
    @sketch = create_sketch
    redirect_to sketch_path(@sketch)
  end
  
  def update
    @sketch = Sketch.where(:token => params[:id]).first
    render_404 && return unless @sketch
    update_sketch(@sketch)
    redirect_to sketch_path(@sketch)
  end

  private

  def set_gallery
    @gallery = Sketch.order("created_at DESC").limit(8)
  end

  def random_district
    unless District.count > 0
      raise "No districts found. Run `rake db:create_districts`"
    end
    District.find_random
  end

  def create_sketch
    sketch = Sketch.new({
      :title    => params[:sketch][:title],
      :byline   => params[:sketch][:byline],
      :district => get_district,
      :token    => params[:sketch_token],
    })
    add_paths(sketch)
    sketch.save!
    sketch
  end
  
  def update_sketch(sketch)
    sketch.title  = params[:sketch][:title]
    sketch.byline = params[:sketch][:byline]
    add_paths(sketch)
    sketch.save!
  end

  def get_district
    code = params[:combined_code]
    district = District.where(:combined_code => code).first
    raise "No District with code #{code}" unless district
    district
  end

  def add_paths(sketch)
    unsaved_sketch = get_unsaved_sketch
    sketch.paths = unsaved_sketch.paths if unsaved_sketch
  end

  def get_unsaved_sketch
    UnsavedSketch.where(:token => params[:sketch_token]).first
  end

end
