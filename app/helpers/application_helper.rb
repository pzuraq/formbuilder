module ApplicationHelper
  def link_to_li(body, url, html_options = {})
    active = "active" if current_page?(url)
    content_tag :li, class: active do
      link_to body, url, html_options
    end
  end

  def is_moderator?
    if logged_in?
      if supergroups = @group.try(:supergroups)
        current_user.moderates.where(group_id: supergroups.keys.push(@group.id)).first
      end
    end
  end

  def is_editor?
    if logged_in?
      if supergroups = @group.try(:supergroups)
        current_user.edits.where(group_id: supergroups.keys.push(@group.id)).first
      end
    end
  end

  def is_super?
    if logged_in?
      current_user == @group.try(:owner)
    end
  end

  def can_edit?
    is_super? or is_moderator? or is_editor?
  end

  def can_delete?
    is_super? or is_moderator?
  end
end
