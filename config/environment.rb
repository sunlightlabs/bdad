# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bdad::Application.initialize!

Mime::Type.register "image/svg+xml", :svg
