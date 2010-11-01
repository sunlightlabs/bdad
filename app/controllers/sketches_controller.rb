class SketchesController < ApplicationController
  around_filter :set_gallery, :only => [:show, :edit, :new]

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
    @sketch = Sketch.new(:district => random_district)
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
    @gallery = Sketch.order("created_at DESC").limit(4)
  end

  def random_district
    unless District.count > 0
      raise "No districts found. Run `rake db:create_districts`"
    end
    District.find_random
  end

  def create_sketch
    Sketch.create!({
      :title    => params[:sketch][:title],
      :byline   => params[:sketch][:byline],
      :district => get_district,
      :token    => params[:sketch_token],
      :paths    => get_unsaved_sketch.paths,
    })
  end
  
  def update_sketch(sketch)
    sketch.title  = params[:sketch][:title]
    sketch.byline = params[:sketch][:byline]
    sketch.paths  = get_unsaved_sketch.paths
    sketch.save!
  end

  def get_district
    code = params[:combined_code]
    district = District.where(:combined_code => code).first
    raise "No District with code #{code}" unless district
    district
  end

  def get_unsaved_sketch
    token = params[:sketch_token]
    unsaved_sketch = UnsavedSketch.where(:token => token).first
    raise "No UnsavedSketch with token #{token}" unless unsaved_sketch
    unsaved_sketch
  end

end
