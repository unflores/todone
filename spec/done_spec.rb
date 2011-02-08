require 'helper'

describe '#add_project' do

	describe "#init" do
		it "should update username and api_key" do
			false.should == true
		end
	end
	
	describe "#add_project" do
    it "should create new config if none exists" do
		
			false.should == true
    end

    it " should add the api_key to config if it is not present" do
			false.should == true
    end
		
		it " should add username to config if it is not in config" do
			false.should == true
		end
		
		it " should add a project to config if it is not present" do
			false.should == true
		end
		
		it " should edit a project in config if project is present" do
			false.should == true
		end
		
		it " should add a hook to .git/hooks/pre-commit if not present" do
			false.should == true
		end
  end

end
