module Done
  ##
  # Simple container module for constants.
  #
  # @author A Flores
  module Consts
    ## Name of the general (defaults) config file
    CONFIG_FILE = 'config.yml'
    ## Default configuaration storage directory
    CONFIG_DIR = File.join(ENV['HOME'], '.done')
    ## Default general (defaults) config file location
    CONFIG = File.join(CONFIG_DIR, CONFIG_FILE)
		## where the hook file is
		HOOK_FILE = File.join('.git','hooks','pre-commit')
	end
end
