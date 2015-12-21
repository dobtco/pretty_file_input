require 'pretty_file_input/version'
require 'fortitude'

module PrettyFileInput
  class Engine < ::Rails::Engine
    initializer 'pretty_file_input.load_views' do |app|
      require 'pretty_file_input/views/component'
    end
  end

  module Views
    mattr_accessor :base_view_class
    self.base_view_class = 'Views::Base'
  end
end
