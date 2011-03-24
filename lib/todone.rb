$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'todone')

%w(cgi pivotal_puller config consts views yaml fileutils).each{|requirement| require requirement}

module Todone
	class MessageProcessor
		attr :config
		attr_writer :config_dir
		include Todone::Consts
		include Todone::Views

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
			
			def load_project_id
				File.open(Todone::MessageProcessor.git_config) do |file| 
					file.each_line do |line| 
						if line.slice('[pivotal]')
							return file.gets.tr("\s\t\n",'').split('=').last
						end
					end
				end
			end
				
			def commit_msg_file
				File.join(git_dir,'COMMIT_EDITMSG')
			end

			def git_dir
				if Dir.getwd.split('/').last == 'hooks' then '..'
				elsif Dir.exists? '.git' then '.git'
				end
			end
			
			def git_config; File.join(git_dir,'config') end

		end
 
		def initialize opts = {}
			self.config_dir = opts[:config_dir]
			@project_id = opts[:project_id] || Todone::MessageProcessor.load_project_id
			@pp = Todone::PivotalPuller.new(project_id) if @project_id
		end

		def add_project project
			return 'missing_project' if project.nil? or project[:id].nil? or project[:users].nil?
			save_project_id project[:id]
			config[project[:id]] = project[:users].split(',')
			config.save config_dir
			return ['missing_hooks_dir', {:project => project}] unless File.exists? File.join('.git','hooks')
		
			return self.add_hook project[:id]	
		end
		
		def add_hook project_id
			if File.exists? Todone::Consts::HOOK_FILE
				return ['exists_pre_commit_hook',{:project_id => project_id}]
			else
				File.open(Todone::Consts::HOOK_FILE,'w') do |f|
					f.write("todone tickets #{project_id} -m")
				end
				FileUtils.chmod 0751, Todone::Consts::HOOK_FILE
				return "pre_commit_hook_updated" 
			end 
		end

		def save_project_id project_id
			`git config -f .git/config pivotal.project-id #{project_id}`
		end
		

		def config
			@config ||= Todone::Config.load_config self.config_dir
		end

		def config_dir
			(@config_dir.nil? && Todone::Consts::CONFIG_DIR) || @config_dir
		end
		
		def tickets
			return ["missing_project_id"] if @pp.nil?
			api_data = @pp.pull_stories("started")
			if api_data.class == Hash
				api_data.delete("error")
			else
				["show_pivotal_stories", :stories => api_data]
			end
		end
		
		def write_tickets opts = {} 
			file = opts[:file] || Todone::MessageProcessor.commit_msg_file
			if File.exists? file
				File.open(file, 'r+') do |f| 
					original_message = f.read
					f.pos = 0
					f.write( view_tickets + original_message  )
				end
			else
				puts missing_write_file( :file => file )
			end
		end
		

		def method_missing(method_id, *args)
			super unless match = /view_(.*)/.match(method_id.to_s) and Todone::MessageProcessor.method_defined?(match[1])
			method = match[1]
			view, data = self.send(method, *args)
			return self.send('missing_view',:method=> method) unless Todone::Views.method_defined? view
			
			self.send(view, data)
		end
	end
end
