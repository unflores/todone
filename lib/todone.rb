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
 
		def initialize config_dir = nil, project_id = nil
			self.config_dir = config_dir
			@pp = Todone::PivotalPuller.new(project_id) if project_id
		end

		def add_project project
			return "Error: Missing project id or users." if project.nil? or project[:id].nil? or project[:users].nil?

			config[project[:id]] = project[:users].split(',')
			config.save config_dir
			return "Couldn't find the .git dir.\n" +
				"Go to your project directory and type the following:\n" +
				"echo 'todone open_tickets #{project[:id]} -m' > .git/hooks/pre-commit\n" +
				"chmod 751 #{Todone::Consts::HOOK_FILE}\n"	unless File.exists? File.join('.git','hooks')
		
			return self.add_hook project[:id]	
		end
		
		def add_hook project_id
			if File.exists? Todone::Consts::HOOK_FILE
				return "It looks like you're already using your pre-commit hook.\n" +
					"I was planning on putting something like the following in there:\n" +
					"todone open_tickets #{project_id} -m"
			else
				File.open(Todone::Consts::HOOK_FILE,'w') do |f|
					f.write("todone open_tickets #{project_id} -m")
				end
				FileUtils.chmod 0751, Todone::Consts::HOOK_FILE
				return "Your pre-commit hook has been updated."
			end 
		end

		def config
			@config ||= Todone::Config.load_config self.config_dir
		end

		def config_dir
			(@config_dir.nil? && Todone::Consts::CONFIG_DIR) || @config_dir
		end
		
		def open_tickets
			return "Error: No project id" if @pp.nil?
			@pp.get_stories("started")
		end
	end
end