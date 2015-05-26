module LoginHelpers
  # Internal: Create and log in as a user of the specified role
  #
  # role - User role (e.g., :admin, :user)

  # Internal: Login as the specified user
  #
  # user - User instance to login with
  def login_with(user)
    visit '/login?lang=en'
    find('#standard').click_link 'a'
    within ('#standard-login-form') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => 'secret'
      click_button 'Log in'
    end
    Thread.current[:current_user] = user
  end

  # Requires Javascript driver.
  def logout
    find(:css, ".fa.fa-sign-out").click
  end
end
