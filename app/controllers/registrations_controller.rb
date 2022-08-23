class RegistrationsController < Devise::RegistrationsController
  
  # nested form in User>registration>new for an adopter or staff account
  # no attributes need to be accepted, just create new account with user_id reference
  def new
    build_resource({})
    resource.build_adopter_account
    resource.build_staff_account
    respond_with self.resource
  end

  private

  def sign_up_params
    params.require(:user).permit(:username,
                                 :first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :signup_role,
                                 :password_confirmation,
                                 adopter_account_attributes: [:user_id],
                                 staff_account_attributes: [:user_id])
  end

  def account_update_params
    params.require(:user).permit(:username,
                                 :first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :signup_role,
                                 :current_password)
  end

  # redirect new registration by adopter to adopter_profiles#new
  def after_sign_up_path_for(resource)
    if resource.adopter_account
      new_profile_path
    else
      root_path
    end
    # send email
  end
end

# see here for setting up redirects after login for each user type
# https://stackoverflow.com/questions/58296569/how-to-signup-in-two-different-pages-with-devise