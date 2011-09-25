require 'rubygems'
require 'smithereen'

module TDOPMath
  class EquationParserLexer < Smithereen::Lexer

    def initialize(s, options)
      @vars = options[:vars] || ['x', 'y', 't']
      super(s)
    end

    def produce_next_token
      return nil if i >= length

      rest = s[i..-1]

      case rest
      when /\A\s+/m
        move $&.size
        produce_next_token
      when /\A\d+\.\d+/           then make_token(:decimal,   $&)
      when /\A\d+/                then make_token(:integer,   $&)
      when /\A\+/                 then make_token(:+,         $&)
      when /\A-/                  then make_token(:-,         $&)
      when /\A\*/                 then make_token(:*,         $&)
      when /\A\//                 then make_token(:/,         $&)
      when /\A\^/                 then make_token(:'^',       $&)
      when /\A\(/                 then make_token(:'(',       $&)
      when /\A\)/                 then make_token(:')',       $&)
      when /\A[[:alpha:]]+/       then process_string($&)
      end
    end

    def process_string(str)
      if @vars.include? str
        make_token(:variable, str)
      else
        make_token(:name, str)
      end
    end

  end

  class EquationParserGrammar < Smithereen::Grammar


    def initialize(options)
      super()

      @@fns = options[:functions] || {
        'sin' => 'Math.sin',
        'cos' => 'Math.cos',
        'tan' => 'Math.tan',
        'sqrt' => 'Math.sqrt',
        'exp' =>  'Math.exp'
      }

      @@consts = options[:constants] || {
        'pi' => 'Math::PI',
        'e'  => 'Math::E'
      }

    end

    deftoken :decimal, 1000 do
      def value
        @value ||= text.to_s
      end

      prefix { value }
    end

    deftoken :integer, 1000 do
      def value
        @value ||= text.to_s
      end

      prefix { value }
    end

    deftoken :variable, 1000 do
      def value
        @value ||= text.to_s
      end

      prefix { value }

      infix { |left| "#{left} * #{value}" }

    end

    deftoken :name, 1000 do
      def value
        @value ||= text
      end

      prefix do
        v = value
        if @@consts.keys.include? v
          expr ||= @@consts[ v ]
        elsif @@fns.keys.include? v
          expr ||= v
        else
          raise ::Smithereen::ParseError.new("Unknown symbol", v)
        end

        expr
      end

      infix do |left|
        v = value
        if @@consts.keys.include? v
          expr ||= @@consts[ v ]
        elsif @@fns.keys.include? v
          expr ||= v
        else
          raise ::Smithereen::ParseError.new("Unknown symbol", v)
        end

       "#{left} * #{expr}"
      end

    end

    deftoken :+, 10 do
      infix {|left| "#{left} + #{expression(lbp)}" }
    end

    deftoken :*, 20 do
      infix {|left| "#{left} * #{expression(lbp)}" }
    end

    deftoken :/, 20 do
      infix {|left| "#{left} / #{expression(lbp)}" }
    end

    deftoken :-, 10 do
      prefix { "(-1 * #{expression(lbp)})" }
      infix {|left| "#{left} - #{expression(lbp)}" }
    end

    deftoken :'^', 30 do
      infix {|left| "#{left}**#{expression(lbp - 1)}" }
    end

    deftoken :'(', 50 do
      prefix do
        '(' + expression.tap{ advance_if_looking_at! :')' } + ')'
      end
      infix do |left|
        raise ::Smithereen::ParseError.new("Expected a function name", left) unless String === left

        if looking_at? :name
          args = delimited_sequence(:'(',:')') { expression(0) }
          arg = if @@fns.keys.include? left
                  @@fns[left] + '(' + args[0] + ')'
                else
                  raise ::Smithereen::ParseError.new("Unrecognized function", left)
                end
        elsif looking_at? :variable or looking_at? :integer or looking_at? :decimal or looking_at? :name
          arg = expression(lbp)
          advance_if_looking_at(:')') or raise ::Smithereen::ParseError.new("Missing closing parenthesis", nil)
          if @@fns.keys.include? left
              @@fns[left] + '(' + arg + ')'
          else
            raise ::Smithereen::ParseError.new("Unrecognized function", left)
          end
        else
          raise ::Smithereen::ParseError.new("Unknown symbol", left)
        end

      end
    end

    deftoken :')', 0

  end

  class Parser < Smithereen::Parser
    def initialize(s, options = {})
      super(EquationParserGrammar.new(options), EquationParserLexer.new(s, options))
    end
  end
end
