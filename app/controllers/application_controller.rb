class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private
    def not_authenticated
      redirect_to login_url, :alert => "Not logged in!"
    end

    def is_moderator?
      if supergroups = @group.try(:supergroups)
        current_user.moderates.where(group_id: supergroups.keys).first
      end
    end

    def is_editor?
    if supergroups = @group.try(:supergroups)
        current_user.edits.where(group_id: supergroups.keys).first
      end
    end

    def is_super?
      current_user == @group.try(:owner)
    end

    def can_edit?
      is_super? or is_moderator? or is_editor?
    end

    def can_delete?
      is_super? or is_moderator?
    end
end
