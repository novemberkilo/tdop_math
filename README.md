# tdop_math

tdop_math is a top down operator precedence parser for mathematical
expressions.  It uses Glen Vandenburg's generic top down operator
precedence parser, Smithereen.

## Usage

This gem depends on another gem that is still in development.
Consequently, it is not available as a built gem.

As far as I know, if you want to install this, you are going to need to pull down this repo and `include '<path-to-tdop_math.rb>'` manually.

Once you have, you use it as follows:

    u = "sin(cos(2x))"  ## or some user input algebraic expression
    t = TDOPMath::Parser.new(u)
    f = t.parse   ## f == "Math.sin(Math.cos(2 * x))"

`tdop_math` reserves symbols `x`,`y` and `t` as variables.  It also
provides a basic list of functions, namely, `sin`, `cos`, `tan`, `sqrt`
and `exp`.  If you need to provide an alternate list of variables and
functions, you can do so as follows:

    u = "baz(foo(2a))"  ## or some user input algrebraic expression
    t = TDOPMath::Parser.new(u,
                             :vars => ['a'],
                             :functions => {
                                'foo' => 'Foo::foo',
                                'baz' => 'Baz::baz'
                              })
    f = t.parse   ## f == "Baz::baz(Foo::foo(2 * a))"

You can use `tdop_math` wherever you need a user to input an algebraic expression, comprising of a known set of functions and variables. This
could find use in apps in maths education or science/data analytics.  I hope the community finds it useful - my motivation was mainly
to build it as an exercise, along my path to becoming a better programmer.

## Copyright

Copyright (c) 2011 Navin Keswani <navin@novemberkilo.com>

Copyright smithereen - Glenn Vanderburg. See LICENSE for details.

[crockford]: http://javascript.crockford.com/tdop/tdop.html
