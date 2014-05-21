module ApplicationHelper
  def link_to_li(body, url, html_options = {})
    active = "active" if current_page?(url)
    content_tag :li, class: active do
      link_to body, url, html_options
    end
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
