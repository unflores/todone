done
====

Done is a command-line tool that gives you the ability to better integrate git with your project manager(which is currently only allowed to be pivotal tracker). Also, Done is, somewhat ironically, a work in progress.

Requirements
------------

* Ruby = 1.9.2
* Rubygems = 1.3.7

Installation & Setup
--------------------

	$ printf "[commit]\ntemplate = ~/.gitmessage.txt" > ~/.gitconfig
	$ touch ~/.gitmessage.txt
	$ gem install done
	$ cd git_pj_directory
	$ done add_project

done add_project
----------------

adds a hook for pre-commit that pulls in open stories from pivotal tracker in order to standardize the user's commit messages

done who
--------

displays who done will filter by when grabbing information via pivotal

done day_stats
--------------------------
	  
grabs all of the tickets/chores/bugs from pivotal tracker that have been completed for the current day.

done daily_update
-----------------

prints out a template for the daily update a user will have
