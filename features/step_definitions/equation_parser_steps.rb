Given /^I have loaded the algebraic equation parser$/ do
  require File.dirname(__FILE__) + '/../../samples/equation_parser'
  @parser_class = SmithereenSamples::EquationParser
end

Given /^I ask the algebraic equation parser for the answer to "([^\"]*)"$/ do |input|
  # Gherkin doesn't process escape sequences in strings, so ask ruby to do that:
  equation_parser_input = eval(%{"#{input}"})
  begin
    @result = @parser_class.new(equation_parser_input).parse
    @syntax_error = nil
  rescue Smithereen::ParseError => e
    @result = nil
    @syntax_error = e
  end
end
