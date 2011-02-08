$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'done')

%w(config consts).each{|requirement| require requirement}

module Done
	class MessageProcessor
		attr :config
		attr_writer :config_dir

		def initialize config_dir = nil
			self.config_dir = config_dir
		end

		def config
      @config ||= Done::Config.load_config self.config_dir
    end
    
		def config_dir
      (@config_dir.nil? && Done::Consts::CONFIG_DIR) || @config_dir
    end
	end
end
