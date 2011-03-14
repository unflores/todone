todone
====

ToDone is a command-line tool that gives you the ability to better integrate git with your project manager(which is currently only allowed to be pivotal tracker). Also, Todone is, somewhat ironically, a work in progress.

Requirements
------------

* Ruby = 1.9.2
* Rubygems = 1.3.7

Installation & Setup
--------------------

	$ gem install todone
	$ cd git_pj_directory
	$ todone add_project

todone add_project
----------------

adds a hook for pre-commit that pulls in open stories from pivotal tracker in order to standardize the user's commit messages

todone users
--------

displays who todone will filter by when grabbing information via pivotal

todone tickets
--------------------------
	  
grabs all of the tickets/chores/bugs from pivotal tracker that are open or have been modified for the current day.

todone daily_update
-----------------

prints out a template for the daily update a user will have
