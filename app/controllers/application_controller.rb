class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private
    def not_authenticated
      redirect_to login_url, :alert => "Not logged in!"
    end

    def is_moderator?
      @group.try(:moderators).try(:include?, current_user)
    end

    def is_editor?
      @group.try(:editors).try(:include?, current_user)
    end

    def is_super?
      @group.try(:owner) == current_user
    end

    def can_edit?
      is_super? or is_moderator? or is_editor?
    end

    def can_delete?
      is_super? or is_moderator?
    end
end
