require 'helper'
require 'httparty' 


describe Todone::PivotalPuller do
	describe "self#pull_stories" do
		it "should return stories when they are available" do
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> [{"id"=> 'valid_id'}]})
			pp = Todone::PivotalPuller.new( :project_id => 100000, :api_key => 'blabbityboo' )
			pp.pull_stories('started').class.to_s.should == 'Array'
		end
		
		# TODO: figure out how to test this, api_key stored in config, don't want to stub the call, is this important?
		it "should return an empty array when a bad project_id is given" do
			#pp = Todone::PivotalPuller.new( :project_id => 1, :api_key => 'blabbityboo' )
			#pp.pull_stories('started').class.to_s.should == 'Array'
		end
		
		it "should return an empty array when no stories are available" do
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> []})
			pp = Todone::PivotalPuller.new( :project_id => 100000, :api_key => 'blabbityboo' )
			pp.pull_stories('started').class.to_s.should == 'Array'
		end
		
		it "should return an error if a bad state is requested" do
			pp = Todone::PivotalPuller.new( :project_id => 100000, :api_key => 'blabbityboo' )
			pp.pull_stories('unnavailable_state')['error'].should == 'invalid_state'
		end

		it "should return error when site unreachable" do
			Todone::PivotalPuller.stubs(:get).raises(SocketError)
			pp = Todone::PivotalPuller.new( :project_id => 100000, :api_key => 'blabbityboo' )
			pp.pull_stories('started')['error'].should == 'api_problem'
		end

		it "should return an array of stories if given the state: unscheduled, started, unstarted, accepted or delivered" do
			Todone::PivotalPuller.stubs(:get).returns({'stories'=> [{"id"=> 'valid_id'}]})
			pp = Todone::PivotalPuller.new( :project_id => 100000, :api_key => 'blabbityboo' )
			%w(unscheduled started unstarted accepted delivered).each do |state|
				return_statement = pp.pull_stories(state)
				return_statement.class.should == Array
				return_statement[0]['id'].should_not == nil
			end
		
		end
	end
end
