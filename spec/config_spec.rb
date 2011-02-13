require 'helper'
require 'yaml'

describe Config do
	context "class" do
		describe "self#load_config" do
			before(:each) { FSHelp::ensure_fresh_config! }
			after(:each)  { clean_test_config! }
			
			it "should properly load the config file" do
				 Done::Config.load_config(FSHelp::CONFIG_DIR).to_hash.should == YAML.load(File.open(FSHelp::ABS_CONFIG_FILE).read)
			end
		end
  end
	context "instance" do
    before(:each) do 
      @config = Done::Config.new
      @hash = { :foo => "bar", :baz => "widget" }
    end
		
		describe "#update!" do 
			it "should properly update and return its data variable" do
				@config.update! @hash
				@config.to_hash.should == @hash
			end
		end

		describe "self#new" do
			it "should properly instantiate with data" do
				config = Done::Config.new @hash
				@hash.should ==  config.to_hash
			end
		end
		
		describe "hash setter" do
			it "should work with object getter" do
				@config[:foo] = "bar"
				"bar".should == @config[:foo]
			end
		end
		
		describe "object setter" do
			it "should work with object getter" do
				@config.foo = "bar"
				"bar".should == @config.foo
			end
		end
	
		describe "#save" do
			it "should write out a yaml version of the @data attribute" do
				FSHelp::ensure_fresh_config!
				hash = { :user => :dr_rumack, :nickname => 'Shirley' }
				config = Done::Config.new hash
				config.save FSHelp::CONFIG_DIR
				YAML.load(File.open(FSHelp::ABS_CONFIG_FILE).read).to_hash.should == config.to_hash
			end
		end

		describe "#to_hash" do
			it "should return a recursively hashified version of the @data attribute" do
				#this hash should cover my bases as far as being deep
				hash = {	
					:frank_drebbin => {
						:guns => ['gun1','gun2','crome_dome'],
						:friends=> {
							:nordberg => { :football_skills => 'teh_best' } 
						} 
					} 
				}
				Done::Config.new(hash).to_hash.should == hash
			end
		end
	end
end
