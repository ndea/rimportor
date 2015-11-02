# Rimportor

Import your records blazingly fast. Are you searching for a fast bulk import? Well here you go!
Rimportor is a new and modern bulk import gem for your rails apps. 
At this point you might ask why Rimportor is so fast? 
Well Rimportor uses concurrency to build a big insert statement and then commits this statement in one transaction to the database.
Let's start the tour

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rimportor', '~> 0.2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rimportor

## Usage
Rimportor adds to every ActiveRecord model an additional method called rimport. This method then takes a collection of your records you want to persist.
Let me give you an example.
```ruby
users = []
1000.times.each { User.new(some_params) }
User.rimport users # Imports your collection as a bulk insert to your database
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request