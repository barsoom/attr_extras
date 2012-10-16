# attr\_extras

Takes some of the boilerplate out of some common Ruby patterns and complements `attr` (`attr_accessor`), `attr_reader` and `attr_writer` nicely.

Lets you do:

``` ruby
class MyClass
  attr_init :foo, :bar
  attr_reader_private :foo

  def oof
    foo.reverse  # Uses the private method.
  end
end

x = MyClass.new("Foo!", "Bar!")
x.oof  # => "!ooF"
```

## Installation

Add this line to your application's `Gemfile`:

    gem 'attr_extras'

And then execute:

    bundle

Or install it yourself as:

    gem install attr_extras

## License
