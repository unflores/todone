module Todone
	module Views

		def missing_project
		 "Error: Missing project id or users."	
		end

		def missing_git_dir
			"Couldn't find the .git dir.\n" +
			"Go to your project directory and type the following:\n" +
			"echo 'todone open_tickets #{project[:id]} -m' > .git/hooks/pre-commit\n" +
			"chmod 751 #{Todone::Consts::HOOK_FILE}\n"
		end

		def missing_project_id
			"Error: No project id"
		end

		def exists_pre_commit_hook
			"It looks like you're already using your pre-commit hook.\n" +
			"I was planning on putting something like the following in there:\n" +
			"todone open_tickets #{project_id} -m"

		end
		
		def updated_pre_commit_hook
			"Your pre-commit hook has been updated."	
		end
		
		def show_pivotal_stories stories
			#TODO: merge post-commit into precommit
			#TODO: resque from getaddrinfo: nodename nor servname provided, or not known (SocketError)
=begin	def last_msg
			last_commit = `git log -n1`.split("\n")
			3.times{ last_commit.shift }
			last_commit_msg = "#\n#==================Last Commit===============\n"
			last_commit_msg << last_commit.collect{|line| "##{line}"}.join("\n")+"\n"
		end
=end
			pre_commit_msg = "#==================Open Tickets================\n"

			unless stories.nil?
				stories.each do |story|
					pre_commit_msg << "#[ ##{story['id']}] for #{story['name']}\n"
				end
				pre_commit_msg
			end
		end

		def missing_view method
			"The method: #{method} does not currently have a view associated with it."
		end
	end
end
