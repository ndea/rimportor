# Rimportor

Rimportor is a new and modern bulk importing gem.
It utilizes arel under the hood to generate insert statements.
By working directly on the model Rimportor is able to execute callbacks and validate the records before inserting them into the database - **which is missing in most importing gems**.

### Features
 - Import in batches
 - Validation of the bulk
 - Callback execution

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rimportor', '~> 0.3'
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
1000.times.each { users << User.new(some_params) }
User.rimport users # Imports your collection as a bulk insert to your database
```
But wait... what about validations and callbacks of my bulk?
Rimportor got you! Just add some configuration options for your rimport.
Let me show you what i mean.
```ruby
users = []
1000.times.each { users << User.new(some_params) }

# true if bulk valid and imported else false
User.rimport users, before_callbacks: true, 
                    after_callbacks: true, 
                    validate_bulk: true 
```
The rimport method returns true if your bulk is valid and all callbacks are executed. 
If an error occurs Rimportor won't insert your bulk in the database. 

And what if i want to insert my records in batches? Rimportor got your back on that too.
```ruby
users = []
1000.times.each { users << User.new(some_params) }
    
# Rimportor will insert the 1000 records in 100 chunks
User.rimport users, batch_size: 100
```

## Supported Databases

- MySQL

## Benchmarks

The below benchmarks were done with MySQL 5.6.26 on Mac OSX 10.11.1, test were run against the InnoDB engine. 
Following ActiveRecord model was used for this benchmark:
```ruby
# == Schema Information
#
# Table name: test_dummies
#
#  id          :integer          not null, primary key
#  lorem       :string(255)
#  lorem2      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
class TestDummy < ActiveRecord::Base
    validates_presence_of :lorem
end
```
Following statement was used for importing the records:
```ruby
TestDummy.rimport test_dummies, validate_bulk: true, batch_size: 5000
```
All times are displayed in seconds. Every record is validated and a batch size of 5000 together with 4 threads was used.

## [![](http://i.imgur.com/kJJWImi.png)](http://qurasoft.de)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
