# Run tests against several ruby versions.

24 = 2.4.9
25 = 2.5.7
26 = 2.6.5
27 = 2.7.0
set_ruby_version = RBENV_VERSION=$($*)

test: ruby-test-24 ruby-test-25 ruby-test-26 ruby-test-27
ruby-test-%:
	$(set_ruby_version) gem list -i bundler || gem install bundler
	$(set_ruby_version) bundle install
	$(set_ruby_version) bundle exec rake
