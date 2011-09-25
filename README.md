# tdop_math

tdop_math is a top down operator precedence parser for mathematical
expressions.  It uses Glen Vandenburg's generic top down operator
precedence parser, Smithereen.

## Usage

This gem depends on another gem that is still in development.
Consequently, it is not available as a built gem.

As far as I know, if you want to install this, you are going to need to pull down this repo and `include '<path-to-tdop_math.rb>'` manually. Once you have, you use it as follows:

    t = TDOPMath::Parser.new("sin(cos(2x))")
    f = t.parse   ## f == "Math.sin(Math.cos(2 * x))"


`tdop_math` reserves symbols `x`,`y` and `t` as variables.  It also
provides a basic list of functions, namely, `sin`, `cos`, `tan`, `sqrt`
and `exp`.  If you need to provide an alternate list of variables and
functions, you can do so as follows:

    t = TDOPMath::Parser.new("baz(foo(2a))",
                              :vars => ['a'],
                              :functions => {
                                'foo' => 'Math.foo',
                                'baz' => 'Math.baz'
                              })
    f = t.parse   ## "Math.baz(Math.foo(2 * a))"



## Copyright

Copyright (c) 2011 Navin Keswani <navin@novemberkilo.com>

Copyright smithereen - Glenn Vanderburg. See LICENSE for details.

[crockford]: http://javascript.crockford.com/tdop/tdop.html
