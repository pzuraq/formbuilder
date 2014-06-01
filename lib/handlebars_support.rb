require 'handlebars'

module HandlebarsSupport
  def compile_template(template)
    handlebars = Handlebars::Context.new

    handlebars.register_helper(:section) do |context, block|
      if context[:block_chain][context[:block_chain].length-1] != 'form' && context[:block_chain][context[:block_chain].length-1] != 'branch'
        raise "Sections must be within blocks or without a parent (sections cannot be contained directly within sections)"
      end

      current_count = context[:section_count][context[:section_count].length-1]
      context[:block_chain].push :section
      context[:section_count].push 0

      render = block.fn(context)

      context[:block_chain].pop
      context[:section_count].pop
      context[:section_count][context[:section_count].length-1] += 1

      "<div id=\"s#{current_count}\" class=\"section\" data-bind=\"with:s#{current_count},fadeVisible:s#{current_count}().display\">#{render}</div>"
    end

    handlebars.register_helper(:branch) do |context, block|
      options = block[:hash]

      if context[:block_chain][context[:block_chain].length-1] != 'section'
        raise "Branches must be contained directly within a section (braches cannot be contained directly within other branches)"
      elsif !options[:if]
        raise "Branches must have branch conditions ('if' attribute)"
      end

      current_count = context[:section_count][context[:section_count].length-1]
      context[:block_chain].push :branch
      context[:section_count].push 0

      render = block.fn(context)

      context[:block_chain].pop
      context[:section_count].pop
      context[:section_count][context[:section_count].length-1] += 1

      "<div id=\"b#{current_count}\" class=\"branch\" data-bind=\"with:b#{current_count},fadeVisible:b#{current_count}().required\" data-branch=\"#{options[:if]}\">#{render}</div>"
    end

    handlebars.register_helper(:question) do |context, block|
      options = block[:hash]

      context[:question_name] = options[:name]
      context[:validations] = {
        required: options[:required] ? YAML.load(options[:required]) : true
      }.to_json
      render = block.fn(context)

      "<div class=\"form-group\">#{render}</div>"
    end

    handlebars.register_helper(:radio) do |context, block|
      options = block[:hash]
      name = "name=\"ans[#{context[:question_name]}]\""
      binding = "data-bind=\"checked:#{context[:question_name]}\""
      value = "value=\"#{options[:value]}\""
      validations = "data-validations='#{context[:validations]}'"

      "<label class=\"radio\"><input type=\"radio\" #{name} #{value} #{validations} #{binding}>#{block.fn(context)}</label>"
    end

    handlebars.register_helper(:checkbox) do |context, block|
      options = block[:hash]
      name = "name=\"ans[#{context[:question_name]}][]\""
      binding = "data-bind=\"checked:#{context[:question_name]}\""
      value = "value=\"#{options[:value]}\""
      validations = "data-validations='#{context[:validations]}'"

      "<label class=\"checkbox\"><input type=\"checkbox\" #{name} #{value} #{validations} #{binding}>#{block.fn(context)}</label>"
    end

    handlebars.register_helper(:textfield) do |context, block|
      options = block[:hash]
      name = "name=\"ans[#{context[:question_name]}]\""
      binding = "data-bind=\"value:#{context[:question_name]}\""
      prompt = "placeholder=\"#{options[:prompt]}\""
      validations = "data-validations='#{context[:validations]}'"
      klass = "class=\"form-control\""

      "<input type=\"text\" #{name} #{prompt} #{validations} #{binding} #{klass} />"
    end

    handlebars.register_helper(:textarea) do |context, block|
      options = block[:hash]
      name = "name=\"ans[#{context[:question_name]}]\""
      binding = "data-bind=\"value:#{context[:question_name]}\""
      prompt = "placeholder=\"#{options[:prompt]}\""
      validations = "data-validations='#{context[:validations]}'"
      klass = "class=\"form-control\""

      "<textarea #{name} #{prompt} #{validations} #{binding} #{klass}></textarea>"
    end

    handlebars.register_helper(:select) do |context, block|
      options = block[:hash]
      name = "name=\"ans[#{context[:question_name]}]\""
      binding = "data-bind=\"value:#{context[:question_name]}\""
      prompt = "<option value=\"\" default disabled>#{options[:prompt]}</option>"
      validations = "data-validations='#{context[:validations]}'"
      klass = "class=\"form-control\""

      "<select #{name} #{validations} #{binding} #{klass}>#{prompt}#{block.fn(context)}</select>"
    end

    handlebars.register_helper(:option) do |context, block|
      options = block[:hash]
      value = options[:value] ? "value=\"ans[#{options[:value]}]\"" : ""
      binding = "data-bind=\"value:#{context[:question_name]}\""
      validations = "data-validations='#{context[:validations]}'"

      "<option #{value}>#{block.fn(context)}</option>"
    end

    handlebars.register_helper(:label) do |context, block|
      "<label for=\"ans[#{context[:question_name]}]\">#{block.fn(context)}</label>"
    end

    if template then handlebars.compile(template).call(:section_count => [0], :block_chain => [:form]).html_safe end
  end
end
