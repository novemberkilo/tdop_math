Given /^I have loaded the tdop_math$/ do
  require File.dirname(__FILE__) + '/../../lib/tdop_math'
  @parser_class = TDOPMath::Parser
end

Given /^I ask the tdop_math parser for the answer to "([^\"]*)"$/ do |input|
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

Given /^I evaluate the tdop_math parser answer to "([^\"]*)"$/ do |input|
  equation_parser_input = eval(%{"#{input}"})
  begin
    @result = eval(@parser_class.new(equation_parser_input).parse)
    @syntax_error = nil
  rescue Smithereen::ParseError => e
    @result = nil
    @syntax_error = e
  end
end

Then /^I should see "([^\"]*)"$/ do |expected_result|
  @result.should == ( expected_result =~ /\./ ? expected_result.to_f : expected_result.to_i )
end

Then /^I should see string "([^\"]*)"$/ do |expected_result|
  @result.should == expected_result
end

Then /^I should get the error "([^\"]*)"$/ do |expected_message|
  @syntax_error.message.should match(Regexp.new("^#{Regexp.escape(expected_message)}: "))
end
