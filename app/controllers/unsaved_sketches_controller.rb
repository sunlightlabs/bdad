class UnsavedSketchesController < ApplicationController

  def index
    @unsaved_sketches = UnsavedSketch.recent
  end
  
  def show
    unsaved_sketch = UnsavedSketch.where(:token => params[:id]).first
    render_404 && return unless unsaved_sketch
    render :json => {
      :id            => unsaved_sketch.id,
      :awards        => get_awards(unsaved_sketch),
      :combined_code => unsaved_sketch.district.combined_code,
      :created_at    => unsaved_sketch.created_at,
      :paths         => unsaved_sketch.paths,
      :population    => get_population(unsaved_sketch),
      :updated_at    => unsaved_sketch.updated_at,
    }
  end

  # A (perhaps evil) hybrid of create and update
  def create
    missing_params = missing_parameters
    if missing_params.present?
      render(:text => 'Missing parameters: ' + missing_params.join(', '),
        :status => 401) && return
    end
    unsaved_sketch = process_unsaved_sketch
    render :json => {
      'population' => get_population(unsaved_sketch),
      'awards'     => get_awards(unsaved_sketch),
    }
  end

  protected

  def process_unsaved_sketch
    unsaved_sketch = UnsavedSketch.where(:token => params[:token]).first
    if !unsaved_sketch
      district = District.where(:combined_code => params[:combined_code]).first
      unsaved_sketch = UnsavedSketch.new({
        :token    => params[:token],
        :district => district,
      })
    end
    unsaved_sketch.paths = params[:paths]
    unsaved_sketch.save!
    unsaved_sketch
  end

  def missing_parameters()
    missing = []
    [:combined_code, :paths, :token].each do |key|
      missing << key.to_s unless params[key]
    end
    missing
  end

  def get_population(unsaved_sketch)
    unsaved_sketch.population
  end

  # TODO
  def get_awards(unsaved_sketch)
    []
  end

end
