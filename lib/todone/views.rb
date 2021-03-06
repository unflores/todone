module Todone
	module Views

		def missing_project
		 "Error: Missing project id or users."	
		end

		def missing_hooks_dir data
			"Couldn't find the .git dir.\n" +
			"Go to your project directory and type the following:\n" +
			"echo 'todone tickets #{data[:project][:id]} -m' > .git/hooks/pre-commit\n" +
			"chmod 751 #{Todone::Consts::HOOK_FILE}\n"
		end

		def missing_project_id
			"Error: No project id"
		end

		def exists_prepare_commit_msg_hook data
			"It looks like you're already using your pre-commit hook.\n" +
			"I was planning on putting something like the following in there:\n" +
			"todone tickets #{data[:project_id]} -m"

		end
		
		def updated_prepare_commit_msg_hook
			"Your pre-commit hook has been updated."	
		end
		
		def show_pivotal_stories data
			#TODO: merge post-commit into precommit
			#TODO: resque from getaddrinfo: nodename nor servname provided, or not known (SocketError)
=begin	def last_msg
			last_commit = `git log -n1`.split("\n")
			3.times{ last_commit.shift }
			last_commit_msg = "#\n#==================Last Commit===============\n"
			last_commit_msg << last_commit.collect{|line| "##{line}"}.join("\n")+"\n"
		end
=end
			prepare_commit_msg = "\n#==================Open Tickets================\n"
			unless data[:stories].nil?
				data[:stories].each do |story|
					prepare_commit_msg << "#[#{story['id']}] #{story['name']}\n"
				end
				prepare_commit_msg
			end
		end
		
		def missing_write_file data
			"The file you are trying to write to '#{data[:file]}' does not exist"
		end
		
		def missing_view data
			"The method: #{data[:method]} does not currently have a view associated with it."
		end

		def api_problem data
			"There was a problem connecting to the PivotalTracker API." 
		end
	end
end
