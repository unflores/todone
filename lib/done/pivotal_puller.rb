require 'httparty' 
module Done
	class PivotalPuller
		include HTTParty
		base_uri 'www.pivotaltracker.com'
		headers 'X-TrackerToken' => 'fcce1b9f7291fded1bcea2fb9a19bd96'
		
		def initialize project_id
			@project_id = project_id
		end

		def pull_stories state
			return "error: invalid state" unless ['started'].include? state
			filter = CGI.escape("state:#{state}")
			PivotalPuller.get("/services/v3/projects/#{PROJECT_ID}/stories?filter=#{filter}")['stories']
			rescue
				return "Error: Could Not connect"
		end		
	end

end
#TODO: merge post-commit into precommit
#TODO: resque from getaddrinfo: nodename nor servname provided, or not known (SocketError)
=begin	def last_msg
		last_commit = `git log -n1`.split("\n")
		3.times{ last_commit.shift }
		last_commit_msg = "#\n#==================Last Commit===============\n"
		last_commit_msg << last_commit.collect{|line| "##{line}"}.join("\n")+"\n"
	end
=end
=begin
	pre_commit_msg = "#==================Open Tickets================\n"

	unless stories.nil?
		stories.each do |story|
			pre_commit_msg << "#[ ##{story['id']}] for #{story['name']}\n"
		end
puts pre_commit_msg
#		File.open("#{ENV['HOME']}/.gitmessage.txt", 'w') do |f|
#			f.write("\n\n")
#			f.write(pre_commit_msg)
#			f.write(last_msg)
#		end
=end
