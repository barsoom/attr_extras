# attr\_extras

Takes some boilerplate out of Ruby and complements `attr` (`attr_accessor`), `attr_reader` and `attr_writer` nicely by providing:

**`attr_init :foo, :bar`**<br>
Defines an initializer that takes two arguments and assigns `@foo` and `@bar`.

**`attr_private :foo, :bar`**<br>
Defines private readers for `@foo` and `@bar`.


## Example

``` ruby
class MyClass
  attr_init :foo, :bar
  attr_private :foo

  def oof
    foo.reverse
  end
end

x = MyClass.new("Foo!", "Bar!")
x.oof  # => "!ooF"
x.foo  # NoMethodError: private method `foo' called.
```


## Installation

Add this line to your application's `Gemfile`:

    gem "attr_extras"

And then execute:

    bundle

Or install it yourself as:

    gem install attr_extras


## License

Copyright (c) 2012 Barsoom AB

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
