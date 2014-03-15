[![Build status](https://secure.travis-ci.org/barsoom/attr_extras.png)](https://travis-ci.org/#!/barsoom/attr_extras/builds)

# attr\_extras

Takes some boilerplate out of Ruby, lowering the barrier to extracting small focused classes, without [the downsides of using `Struct`](http://thepugautomatic.com/2013/08/struct-inheritance-is-overused/).

Instead of

```
class InvoiceBuilder
  def initialize(invoice, employee)
    @invoice, @employee = invoice, employee
  end

  private

  attr_reader :invoice, :employee
end
```

you can just do

```
class InvoiceBuilder
  pattr_initialize :invoice, :employee
end
```

This nicely complements Ruby's built-in `attr_accessor`, `attr_reader` and `attr_writer`.


## Usage

`attr_initialize :foo, :bar`<br>
Defines an initializer that takes two arguments and assigns `@foo` and `@bar`.

`attr_initialize :foo, [:bar, :baz!]`,
Defines an initializer that takes one regular argument, assigning `@foo`, and one hash argument, assigning `@bar` (optional) and `@baz` (required).

`attr_initialize [:bar, :baz!]`,
Defines an initializer that takes one hash argument, assigning `@bar` (optional) and `@baz` (required).

`attr_private :foo, :bar`<br>
Defines private readers for `@foo` and `@bar`.

`pattr_initialize :foo, :bar`<br>
Defines both initializer and private readers. The `[]` notation for hash arguments is also supported.

`attr_value :foo, :bar`<br>
NOTE: experimental. Likely to be renamed, modified or removed soon.<br>
Defines both initializer and public readers. Does not define writers as value objects are typically immutable. Defines object equality: two value objects of the same class with the same values are equal.

`method_object :fooable?, :foo`<br>
Defines a `.fooable?` class method that takes one argument (`:foo`) and delegates to an instance method that can access `foo` as a private reader, useful for [method objects](http://refactoring.com/catalog/replaceMethodWithMethodObject.html). The `[]` notation for hash arguments is also supported.

You don't have to specify readers if you don't want them: `method_object :fooable?` is also valid.

`attr_id_query :foo?, :bar?`<br>
Defines query methods like `foo?`, which is true iff `foo_id` is truthy. Goes well with Active Record.

`attr_query :foo?, :bar?`<br>
Defines query methods like `foo?`, which is true iff `foo` is truthy.

Findability has been a central consideration.
Hence the long name `attr_initialize`, so you see it when scanning for the initializer;
and the enforced questionmarks with `attr_id_query :foo?`, so you can search for that method.


## Example

``` ruby
class MyClass
  pattr_initialize :foo, :bar
  attr_id_query :item?
  attr_query :oof?

  def oof
    foo.reverse
  end

  def item_id
    123
  end
end

x = MyClass.new("Foo!", "Bar!")
x.oof    # => "!ooF"
x.foo    # NoMethodError: private method `foo' called.
x.item?  # => true
x.oof?   # => true


class MyMethodObject
  method_object :fooable?,
    :foo

  def fooable?
    foo == :some_value
  end
end

MyMethodObject.fooable?(:some_value)     # => true
MyMethodObject.fooable?(:another_value)  # => false


class MyHashyObject
  attr_initialize :foo, [:bar, :baz]
  attr_reader :bar
end

x = MyHashyObject.new("Foo!", bar: "Bar!", baz: "Baz!")
x.bar  # => "Bar!"


class MyValueObject
  attr_value :foo, :bar
end

x = MyValueObject.new(5, 10)
x.foo  # => 5
x.bar  # => 10
x.foo = 20  # NoMethodError: undefined method `foo=''`
```

## Why not use `Struct`?

See: ["Struct inheritance is overused"](http://thepugautomatic.com/2013/08/struct-inheritance-is-overused/)


## Why not use `private; attr_reader :foo`?

Instead of `attr_private :foo`, you could do `private; attr_reader :foo`.

Other than being more to type, declaring `attr_reader` after `private` will actually give you a warning (deserved or not) if you run Ruby with warnings turned on.

If you don't want the dependency on `attr_extras`, you can get rid of the warnings with `attr_reader :foo; private :foo`. Or just define a regular private method.


## Installation

Add this line to your application's `Gemfile`:

    gem "attr_extras"

And then execute:

    bundle

Or install it yourself as:

    gem install attr_extras


## License

Copyright (c) 2012 [Barsoom AB](http://barsoom.se)

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
