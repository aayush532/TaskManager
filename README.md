# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
    - git clone 
    - cd TaskManager
    - bundle install
    - set your email and password in .env file to start using email service

* Database creation
    - database file configuration(set db name, username and password)
    - rails db:create
    - rails db:migrate

* Run server
    - run% rails server

* Database initialization
    - Sign up to create a user and login with it

* How to run the test suite
    - run% bundle exec rspec (to test the unit test cases)

* Services (job queues, cache servers, search engines, etc.)
    - app has 2 jobs which uses rufus scheduler to send deadline alerts,
        I have not used sidekiq because my windows OS was not allowing me to install redis on windows, i could have used WSL2 to install redis on windows, but this windows system belongs to my friend and he didn't allowed me to do so.

