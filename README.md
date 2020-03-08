# SingletonClassHelpers

This gem makes available the following methods to modules/classes as a refinement:

- translated_name: translates singleton class pointers in the class name to a more human readable name
- singleton_of: returns the class from which the class is the singleton class

## Motivation

Let's say that you are tracing class definitions with TracePoint.
```ruby
tracepoint = TracePoint.new(:class) do |tp|
  puts tp.self
  #Do interesting stuff
end
tracepoint.enable
```

When executing this code:
```ruby
class TestClass
  class << self
    def some_method
    end

    class AnotherClass
    end
  end
end
```

The trace will print:

>  TestClass

>  #<Class:TestClass>

>  #<Class:0x00007fc2bf97fc00>::AnotherClass


Singleton classes are anonymous classes in the sense that are not assigned to a constant.

When accessed directly, their name will contain the class for which they are the singleton class.

The name of modules/classes defined in a singleton class will contain a named pointer to the singleton class.

This gem helps you to decipher class names that contain singleton_class pointers, making it easier to trace class definitions.

When using the refinement, the above tracepoint will print:

>  TestClass

>  #<Class:TestClass>

>  #<Class:TestClass>::AnotherClass


Additionally, when introspecting a singleton class, you may want to know the class to which it is the singleton class.

```ruby
class AClass
end

sc = AClass.singleton_class
# #<Class:AClass>

sc.singleton_of
# AClass
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'singleton_class_helpers'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install singleton_class_helpers

## Requirements

Ruby 2.4+

## Usage

Activate the refinement in the scope you want to be the methods available.

```ruby
using SingletonClassHelpers::Refinement
```

Use the available helpers on modules/classes.

### How to read the translated name

A transate name like:
```
#<Class:#<Class:FirstClass>::FirstModule>::SimpleClass
```

can be better read from right to left as follows:
 - SimpleClass defined in FirstModule's singleton class which is defined in singleton class of FirstClass.

## Why using a refinement?

“Monkey patching” or prepending methods to classes make changes global, and can cause side-effects.

When tracing programs, one may want to make sure that the tracer doesn't break funcionality.
 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dunkelbraun/singleton_class_helpers. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/singleton_class_helpers/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SingletonClassHelpers project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/dunkelbraun/singleton_class_helpers/blob/master/CODE_OF_CONDUCT.md).
