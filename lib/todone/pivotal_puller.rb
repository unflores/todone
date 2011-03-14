require 'httparty' 
require 'cgi'
module Todone
	class PivotalPuller
		include HTTParty
		base_uri 'www.pivotaltracker.com'
		headers 'X-TrackerToken' => 'fcce1b9f7291fded1bcea2fb9a19bd96'
		
		def initialize project_id
			@project_id = project_id
		end

		def pull_stories state
			return { "error" => "invalid_state" } unless ['started'].include? state
			filter = CGI.escape("state:#{state}")
			PivotalPuller.get("/services/v3/projects/#{@project_id}/stories?filter=#{filter}")['stories'] || []
			rescue 
				return { "error" => "api_problem" }
		end		
	end

end

