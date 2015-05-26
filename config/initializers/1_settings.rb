class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env
end


# Default settings
Settings['ldap'] ||= Settingslogic.new({})
Settings.ldap['enabled'] = false if Settings.ldap['enabled'].nil?
Settings.ldap['allow_username_or_email_login'] = false if Settings.ldap['allow_username_or_email_login'].nil?


Settings['omniauth'] ||= Settingslogic.new({})
Settings.omniauth['enabled']      = false if Settings.omniauth['enabled'].nil?
Settings.omniauth['providers']  ||= []

Settings['csv'] ||= Settingslogic.new({})
