module Done
  ##
  # Simple container module for constants.
  #
  # @author A Flores
  module Consts
    ## Name of the general (defaults) config file
    CONF_FILE = 'config.yml'
    ## Default configuaration storage directory
    CONF_DIR = File.join(ENV['HOME'], '.done')
    ## Default general (defaults) config file location
    CONF = File.join(CONF_DIR, CONF_FILE)
  end
end
