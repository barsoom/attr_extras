[![Build status](https://secure.travis-ci.org/barsoom/attr_extras.png)](https://travis-ci.org/#!/barsoom/attr_extras/builds)

# attr\_extras

Takes some boilerplate out of Ruby, lowering the barrier to extracting small focused classes, without [the downsides of using `Struct`](http://thepugautomatic.com/2013/08/struct-inheritance-is-overused/).

Instead of

``` ruby
class InvoiceBuilder
  def initialize(invoice, employee)
    @invoice, @employee = invoice, employee
  end

  private

  attr_reader :invoice, :employee
end
```

you can just do

``` ruby
class InvoiceBuilder
  pattr_initialize :invoice, :employee
end
```

This nicely complements Ruby's built-in `attr_accessor`, `attr_reader` and `attr_writer`.

Supports positional arguments as well as optional and required hash arguments.

Also provides conveniences for creating value objects, method objects, query methods and abstract methods.


## Usage

* [`pattr_initialize`](#pattr_initialize)
* [`vattr_initialize`](#vattr_initialize)
* [`attr_initialize`](#attr_initialize)
* [`attr_private`](#attr_private)
* [`attr_value`](#attr_value)
* [`static_facade`](#static_facade)
* [`method_object`](#method_object)
* [`attr_implement`](#attr_implement)
* [`attr_query`](#attr_query)
* [`attr_id_query`](#attr_id_query)



### `pattr_initialize`

`pattr_initialize :foo, :bar` defines both initializer and private readers: shortcut for

``` ruby
attr_initialize :foo, :bar
attr_private :foo, :bar
```

Example:

``` ruby
class Item
  pattr_initalize :name, :price

  def price_with_vat
    price * 1.25
  end
end

Item.new("Pug", 100).price_with_vat  # => 125.0
```

The [`attr_initialize`](#attr_initialize) notation for hash arguments is also supported: `pattr_initialize :foo, [:bar, :baz!]`


### `vattr_initialize`

`vattr_initialize :foo, :bar` defines initializer, public readers and [value object identity](#attr_value): shortcut for

``` ruby
attr_initialize :foo, :bar
attr_value :foo, :bar
```

Example:

``` ruby
class Country
  vattr_initialize :code
end

Country.new("SE") == Country.new("SE")  # => true
Country.new("SE").code  # => "SE"
```

The `attr_initialize` notation for hash arguments is also supported: `vattr_initialize :foo, [:bar, :baz!]`


### `attr_initialize`

`attr_initialize :foo, :bar` defines an initializer that takes two arguments and assigns `@foo` and `@bar`.

`attr_initialize :foo, [:bar, :baz!]` defines an initializer that takes one regular argument, assigning `@foo`, and one hash argument, assigning `@bar` (optional) and `@baz` (required).

`attr_initialize [:bar, :baz!]` defines an initializer that takes one hash argument, assigning `@bar` (optional) and `@baz` (required).

`attr_initialize` can also accept a block which will be invoked after initialization. This is useful for calling `super` appropriately in subclasses or initializing private data as necessary.


### `attr_private`

`attr_private :foo, :bar` defines private readers for `@foo` and `@bar`.


### `attr_value`

`attr_value :foo, :bar` defines public readers for `@foo` and `@bar`.

It also defines object equality: two value objects of the same class with the same values will be considered equal (with `==` and `eql?`, in `Set`s, as `Hash` keys etc).

It does not define writers, because [value objects](http://en.wikipedia.org/wiki/Value_object) are typically immutable.


### `static_facade`

`static_facade :allow?, :user` defines a `.allow?` class method that delegates to an instance method by the same name, having first provided `user` as a private reader.

This is handy when a class-method API makes sense but you still want [the refactorability of instance methods](http://blog.codeclimate.com/blog/2012/11/14/why-ruby-class-methods-resist-refactoring/).

Example:

``` ruby
class PublishingPolicy
  static_facade :allow?, :user
  static_facade :disallow?, :user

  def allow?
    user.admin? && …
  end

  def disallow?
    !allow?
  end
end

PublishingPolicy.allow?(user)
```

`static_facade :allow?, :user` is a shortcut for

``` ruby
pattr_initialize :user

def self.allow?(user)
  new(user).allow?
end
```

The `attr_initialize` notation for hash arguments is also supported: `static_facade :allow?, :user, [:user_agent, :ip!]`

You don't have to specify arguments/readers if you don't want them: just `static_facade :tuesday?` is also valid.


### `method_object`

*NOTE: v4.0.0 made a breaking change! `static_facade` does exactly what `method_object` used to do; the new `method_object` no longer accepts a method name argument.*

`method_object :foo` defines a `.call` class method that delegates to an instance method by the same name, having first provided `foo` as a private reader.

This is a special case of `static_facade` for when you want a [Method Object](http://refactoring.com/catalog/replaceMethodWithMethodObject.html), and the class name itself will communicate the action it performs.

Example:

``` ruby
class CalculatePrice
  method_object :order

  def call
    total * factor
  end

  private

  def total
    order.items.map(&:price).inject(:+)
  end

  def factor
    1 + rand
  end
end

class Order
  def price
    CalculatePrice.call(self)
  end
end
```

`method_object :foo` is a shortcut for

``` ruby
static_facade :call, :foo
```

which is a shortcut for

``` ruby
pattr_initialize :foo

def self.call(foo)
  new(foo).call
end
```

The `attr_initialize` notation for hash arguments is also supported: `method_object :foo, [:bar, :baz!]`

You don't have to specify arguments/readers if you don't want them: just `method_object` is also valid.


### `attr_implement`

`attr_implement :foo, :bar` defines nullary (0-argument) methods `foo` and `bar` that raise e.g. `"Implement a 'foo()' method"`.

`attr_implement :foo, [:name, :age]` will define a binary (2-argument) method `foo` that raises `"Implement a 'foo(name, age)' method"`.

This is suitable for [abstract methods](http://en.wikipedia.org/wiki/Abstract_method#Abstract_methods) in base classes, e.g. when using the [template method pattern](http://en.wikipedia.org/wiki/Template_method_pattern).

It's more or less a shortcut for

``` ruby
def my_method
  raise "Implement me in a subclass!"
end
```

though it is shorter, more declarative, gives you a clear message and handles edge cases you might not have thought about (see tests).


### `attr_query`

`attr_query :foo?, :bar?` defines query methods like `foo?`, which is true if (and only if) `foo` is truthy.


### `attr_id_query`

`attr_id_query :foo?, :bar?` defines query methods like `foo?`, which is true if (and only if) `foo_id` is truthy. Goes well with Active Record.


## Philosophy

Findability is a core value.
Hence the long name `attr_initialize`, so you see it when scanning for the initializer;
and the enforced questionmarks with `attr_id_query :foo?`, so you can search for that method.


## Why not use `Struct` instead of `pattr_initialize`?

See: ["Struct inheritance is overused"](http://thepugautomatic.com/2013/08/struct-inheritance-is-overused/)


## Why not use `private; attr_reader :foo` instead of `attr_private`?

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


## Running the tests

Run then with:

`rake`

Or to see warnings (try not to have any):

`RUBYOPT=-w rake`


## Contributors

* [Henrik Nyh](https://github.com/henrik)
* [Joakim Kolsjö](https://github.com/joakimk)
* [Victor Arias](https://github.com/victorarias)
* [Teo Ljungberg](https://github.com/teoljungberg)
* [Kim Persson](https://github.com/lavinia)
* [Joe Ferris](https://github.com/jferris)


## License

[MIT](LICENSE.txt)
