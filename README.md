# Getting Started

You will need [Vagrant](http://www.vagrantup.com/) installed.

- Clone the repo
- Run `vagrant up` in the repo directory
- Run `vagrant ssh` -> `cd /vagrant` -> `bundle install`. This installs all of the rails dependencies on the VM.
- After bundler completes, run `rake db:migrate`. This typically performs any migrations (database changes) that haven’t been completed yet. Right now there is only one, it enables HSTOREs.
- Finally, run `bundle exec rails s`. This will start the rails server.
- On your browser go to http://localhost:3000/, you should see the rails welcome page.
