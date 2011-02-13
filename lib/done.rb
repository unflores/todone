$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'done')

%w(config consts yaml fileutils).each{|requirement| require requirement}

module Done
	class MessageProcessor
		attr :config
		attr_writer :config_dir

		include Done::Consts

		class << self
			def needs_init? dir = Done::Consts::CONFIG_DIR
				not File.exists? File.join(dir, Done::Consts::CONFIG_FILE)
			end

			def init options
				dir = options.delete(:dir) || Done::Consts::CONFIG_DIR
				conf_file = File.join(dir, Done::Consts::CONFIG_FILE)
				
				FileUtils.mkdir_p dir unless File.exists? dir
				unless File.exists? conf_file
					File.open(conf_file, 'w') do |f|
						YAML.dump({ 
								:owner    => options[:owner], 
								:api_key  => options[:api_key]
							}, f)
					end
				end

			end
		end
 
		def initialize config_dir = nil
			self.config_dir = config_dir
		end

		def add_project project
			return if project.nil? or project[:id].nil? or project[:users].nil?
			config[project[:id]] = project[:users].split(',')
			config.save config_dir
			true
		end

		def config
			@config ||= Done::Config.load_config self.config_dir
		end

		def config_dir
			(@config_dir.nil? && Done::Consts::CONFIG_DIR) || @config_dir
		end

	end
end
