require 'httparty' 
require 'cgi'
module Todone
	class PivotalPuller
		include HTTParty
		base_uri 'www.pivotaltracker.com'
		
		
		def initialize opts 
			@project_id = opts[:project_id]
			Todone::PivotalPuller.headers 'X-TrackerToken' => opts[:tracker_token]
		end

		def pull_stories state
			return { "error" => "invalid_state" } unless %w(started unstarted accepted delivered unscheduled).include? state
			filter = CGI.escape("state:#{state}")
			PivotalPuller.get("/services/v3/projects/#{@project_id}/stories?filter=#{filter}")['stories'] || []
			rescue 
				return { "error" => "api_problem" }
		end		
	end

end

