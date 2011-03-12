$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'todone')

%w(cgi pivotal_puller config consts yaml fileutils).each{|requirement| require requirement}

module Todone
	class MessageProcessor
		attr :config
		attr_writer :config_dir

		include Todone::Consts

		class << self
			def needs_init? dir = Todone::Consts::CONFIG_DIR
				not File.exists? File.join(dir, Todone::Consts::CONFIG_FILE)
			end

			def init options
				return if options[:owner].nil? or options[:api_key].nil?
				dir = options.delete(:dir) || Todone::Consts::CONFIG_DIR
				conf_file = File.join(dir, Todone::Consts::CONFIG_FILE)
				
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
 
		def initialize opts = {}
			self.config_dir = opts[:config_dir]
			@pp = Todone::PivotalPuller.new(opts[:project_id]) if opts[:project_id]
		end

		def add_project project
			return 'missing_project' if project.nil? or project[:id].nil? or project[:users].nil?

			config[project[:id]] = project[:users].split(',')
			config.save config_dir
			return 'missing_hooks_dir' unless File.exists? File.join('.git','hooks')
		
			return self.add_hook project[:id]	
		end
		
		def add_hook project_id
			if File.exists? Todone::Consts::HOOK_FILE
				return 'exists_pre_commit_hook'
			else
				File.open(Todone::Consts::HOOK_FILE,'w') do |f|
					f.write("todone open_tickets #{project_id} -m")
				end
				FileUtils.chmod 0751, Todone::Consts::HOOK_FILE
				return "pre_commit_hook_updated" 
			end 
		end

		def config
			@config ||= Todone::Config.load_config self.config_dir
		end

		def config_dir
			(@config_dir.nil? && Todone::Consts::CONFIG_DIR) || @config_dir
		end
		
		def open_tickets
			return "missing_project_id" if @pp.nil?
			api_data = @pp.pull_stories("started")
			if api_data.class == Hash
				api_data.delete("error")
			else
				"pivotal_stories"
			end
		end
	end
end
