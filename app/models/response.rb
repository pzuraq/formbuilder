class Response < ActiveRecord::Base
  belongs_to :form

  belongs_to :respondent, class_name: 'User'

end
