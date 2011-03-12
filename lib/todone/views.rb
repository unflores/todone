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

	end
end
