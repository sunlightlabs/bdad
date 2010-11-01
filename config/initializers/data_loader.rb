module Bdad
  class Application
    data_directory = Rails.root.join('public', 'javascripts', 'data')
    h = {}

    def decode_json_file(filename, prefix)
      contents = File.read(filename).gsub(/^#{prefix}/, '')
      ActiveResource::Formats::JsonFormat.decode(contents)
    end

    districts_file = data_directory.join('districts.js')
    if districts_file.file?
      h[:districts] = decode_json_file(districts_file.to_s, "DISTRICTS=")
    else
      puts "\nDistricts data file not found at #{states_file}."
      exit!
    end

    states_file = data_directory.join('states.js')
    if states_file.file?
      h[:states] = decode_json_file(states_file.to_s, "STATES=")
    else
      puts "\nStates data file not found at #{states_file}."
      exit!
    end

    config.data = h
  end
end
