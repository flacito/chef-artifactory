require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :error
  config.platform  = 'redhat'
  config.version   = '6.3'
end
