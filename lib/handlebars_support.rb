require 'handlebars'

module HandlebarsSupport
  def compile_template(template)
    handlebars = Handlebars::Context.new

    handlebars.register_helper(:section) do |context, block|
      options = block[:hash]

      if_stmt = options[:if] ? options[:if] : 'true'
      context[:conditional_chain].push(if_stmt)

      section_name = "section#{context[:section_count]}"
      conditional = context[:conditional_chain].map{|v| "(#{v})" }.join('&&')

      if context[:section_count] == 0
        navigation = "<div class=\"col-sm-12 top15 center-text\">
                        <button class=\"btn btn-default btn-lg btn-block btn-start\" ng-click=\"next(0)\">
                          Begin the Questionnaire <span class=\"icon-arrow-right2\"></span>
                        </button>
                      </div>"
      elsif options[:last]
        navigation = "<div class=\"prev-container\">
                        <button class=\"btn btn-default btn-prev col-xs-12\" ng-click=\"prev(#{context[:section_count]})\">
                          <span class=\"icon-arrow-left\"></span> Prev
                        </button>
                      </div>
                      <div class=\"col-xs-12 top15 center-text\">
                        <button type=\"submit\" class=\"btn btn-default btn-lg btn-block btn-submit\" ng-show=\"#{section_name}.$valid\">
                          Submit <span class=\"icon-download2\"></span>
                        </button>
                      </div>"
      else
        navigation = "<div class=\"prev-container\">
                        <button class=\"btn btn-default btn-prev col-xs-12\" ng-click=\"prev(#{context[:section_count]})\">
                          <span class=\"icon-arrow-left\"></span> Prev
                        </button>
                      </div>
                      <div class=\"next-container\">
                        <button class=\"btn btn-default btn-next btn-block\" ng-show=\"#{section_name}.$valid\" ng-click=\"next(#{context[:section_count]})\">
                          Next <span class=\"icon-arrow-right2\"></span>
                        </button>
                      </div>"
      end


      render = block.fn(context)

      context[:section_count] += 1
      context[:conditional_chain].pop

      "<div ng-form name=\"#{section_name}\" ng-conditional=\"#{conditional}\" ng-show=\"#{section_name}.$show\" class=\"section\">#{render}#{navigation}</div>"
    end

    handlebars.register_helper(:lead) do |context, block|
      "<p class=\"lead\">#{block.fn(context)}</p>"
    end

    # handlebars.register_helper(:branch) do |context, block|
    #   options = block[:hash]
    #
    #   if context[:block_chain][context[:block_chain].length-1] != 'section'
    #     raise "Branches must be contained directly within a section (braches cannot be contained directly within other branches)"
    #   elsif !options[:if]
    #     raise "Branches must have branch conditions ('if' attribute)"
    #   end
    #
    #   current_count = context[:section_count][context[:section_count].length-1]
    #   context[:block_chain].push :branch
    #   context[:section_count].push 0
    #
    #   render = block.fn(context)
    #
    #   context[:block_chain].pop
    #   context[:section_count].pop
    #   context[:section_count][context[:section_count].length-1] += 1
    #
    #   "<div id=\"b#{current_count}\" class=\"branch\" data-bind=\"with:b#{current_count},fadeVisible:b#{current_count}().required\" data-branch=\"#{options[:if]}\">#{render}</div>"
    # end

    handlebars.register_helper(:conditional) do |context, block|
      options = block[:hash]

      context[:conditional_chain].push options[:if] if options[:if]

      render = block.fn(context)

      context[:conditional_chain].pop if options[:if]

      "#{render}"
    end

    handlebars.register_helper(:followup) do |context, block|
      options = block[:hash]

      context[:conditional_chain].push options[:if] if options[:if]

      conditional = context[:conditional_chain].map{|v| "(#{v})" }.join('&&')

      render = block.fn(context)

      context[:conditional_chain].pop if options[:if]

      "<div class=\"followup\" ng-show=\"#{conditional}\">#{render}</div>"
    end

    handlebars.register_helper(:question) do |context, block|
      options = block[:hash]

      context[:question_name] = name = options[:name]

      if options[:required]
        context[:conditional_chain].push options[:required]
      elsif options[:if]
        context[:conditional_chain].push options[:if]
      end

      render = block.fn(context)

      if options[:required] or options[:if]
        context[:conditional_chain].pop
      end

      "<div class=\"form-group top15\">#{render}</div>"
    end

    handlebars.register_helper(:radio) do |context, block|
      options = block[:hash]

      name = context[:question_name]
      context[:option_parent] = 'radio'
      conditional = context[:conditional_chain].map{|v| "(#{v})" }.join('&&')

      render = block.fn(context)

      "#{render}<input name=\"#{name}\" type=\"hidden\" ng-model=\"ans.#{name}\" ng-required=\"#{conditional}\"/>"
    end

    handlebars.register_helper(:checkbox) do |context, block|
      options = block[:hash]

      name = context[:question_name]
      context[:option_parent] = 'checkbox'
      conditional = context[:conditional_chain].map{|v| "(#{v})" }.join('&&')

      render = block.fn(context)

      "#{render}<input name=\"#{name}\" type=\"hidden\" ng-model=\"ans.#{name}\" ng-required=\"#{conditional}\"/>"
    end

    handlebars.register_helper(:option) do |context, block|
      options = block[:hash]
      value = options[:value]
      name = context[:question_name]

      if context[:option_parent] == 'radio'
        model = "ng-model=\"ans.#{name}\" btn-radio=\"'#{value}'\""
        klass = "fm-radio btn btn-default"
        icon = "{true:'icon-radio-checked', false:'icon-radio-unchecked'}[ans.#{name}=='#{value}']"

      elsif context[:option_parent] == 'checkbox'
        model = "ng-model=\"ans.#{name}.#{value}\" btn-checkbox"
        klass = "fm-checkbox btn btn-default"
        icon = "{true:'icon-checkbox-checked2', false:'icon-checkbox-unchecked3'}[ans.#{name}.#{value} || false]"
      end

      render = block.fn(context)

      "<div class=\"col-sm-12\">
        <button class=\"#{klass}\" #{model} uncheckable>
          <span class=\"icon\" ng-class=\"#{icon}\"></span>#{render}
        </button>
      </div>"
    end

    handlebars.register_helper(:textfield) do |context, block|
      options = block[:hash]
      name = context[:question_name]
      placeholder = options[:placeholder]
      conditional = context[:conditional_chain].map{|v| "(#{v})" }.join('&&')


      "<div class=\"col-sm-12 top15\">
        <input type=\"text\" name=\"#{name}\" ng-model=\"ans.#{name}\" placeholder=\"#{placeholder}\" class=\"form-control better-placeholder\" ng-required=\"#{conditional}\"/>
      </div>"
    end

    handlebars.register_helper(:datepicker) do |context, block|
      options = block[:hash]
      name = context[:question_name]
      placeholder = options[:placeholder]
      conditional = context[:conditional_chain].map{|v| "(#{v})" }.join('&&')


      "<div class=\"col-sm-12 top15\">
        <input type=\"text\" name=\"#{name}\" ng-model=\"ans.#{name}\" placeholder=\"#{placeholder}\" class=\"form-control better-placeholder\" pick-a-date ng-required=\"#{conditional}\"/>
      </div>"
    end

    # handlebars.register_helper(:textarea) do |context, block|
    #   options = block[:hash]
    #   name = "name=\"ans[#{context[:question_name]}]\""
    #   binding = "data-bind=\"value:#{context[:question_name]}\""
    #   prompt = "placeholder=\"#{options[:prompt]}\""
    #   validations = "data-validations='#{context[:validations]}'"
    #   klass = "class=\"form-control\""
    #
    #   "<textarea #{name} #{prompt} #{validations} #{binding} #{klass}></textarea>"
    # end

    # handlebars.register_helper(:select) do |context, block|
    #   options = block[:hash]
    #   name = "name=\"ans[#{context[:question_name]}]\""
    #   binding = "data-bind=\"value:#{context[:question_name]}\""
    #   prompt = "<option value=\"\" default disabled>#{options[:prompt]}</option>"
    #   validations = "data-validations='#{context[:validations]}'"
    #   klass = "class=\"form-control\""
    #
    #   "<select #{name} #{validations} #{binding} #{klass}>#{prompt}#{block.fn(context)}</select>"
    # end
    #
    # handlebars.register_helper(:option) do |context, block|
    #   options = block[:hash]
    #   value = options[:value] ? "value=\"ans[#{options[:value]}]\"" : ""
    #   binding = "data-bind=\"value:#{context[:question_name]}\""
    #   validations = "data-validations='#{context[:validations]}'"
    #
    #   "<option #{value}>#{block.fn(context)}</option>"
    # end

    handlebars.register_helper(:label) do |context, block|
      "<label for=\"ans[#{context[:question_name]}]\">#{block.fn(context)}</label>"
    end

    if template then handlebars.compile(template).call(:section_count => 0, :conditional_chain => ['true']).html_safe end
  end
end
