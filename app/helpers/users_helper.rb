module UsersHelper
  def can_login_human(user)
    user.login ? @style = "font-weight: bold; color: green;" : @style = ""
    "<div style='#{@style}'>#{user.login ? t(:_yes_) : t(:_no_) }</div>"
  end
  def read_only_human(user)
    user.read_only ? @style = "font-weight: bold; color: green;" : @style = ""
    "<div style='#{@style}'>#{user.read_only ? t(:_yes_) : t(:_no_) }</div>"
  end
  def is_admin_human(user)
    user.admin ? @style = "font-weight: bold; color: red;" : @style = ""
    "<div style='#{@style}'>#{user.admin ? t(:_yes_) : t(:_no_) }</div>"
  end
end
