require 'handlebars'

class HomeController < ApplicationController
  def index
    handlebars = Handlebars::Context.new
    handlebars.register_helper(:section) do |context, block|
      context[:section_count] = context[:section_count] ? context[:section_count] + 1 : 1
      "<div id=\"section#{context[:section_count]}\" class=\"section\">#{block.fn(context)}</div>"
    end
    handlebars.register_helper(:question) do |context, block|
      options = block[:hash]

      "#{options[:test_val]}#{block.fn(context)}"
    end
    @rendered = handlebars.compile("{{#section}}{{#question test_val=\"test\"}}aoeu{{/question}}{{/section}}{{#section}}Testing{{/section}}").call
  end
end
