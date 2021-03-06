class RegistrationsController < Devise::RegistrationsController

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # If we've got only avatar
    if account_update_params == account_update_avatar_params
      respond_with resource, location: after_update_path_for(resource)
      return resource.update_without_password(account_update_avatar_params)
    end

    # if we've got only username and fullname
    if account_update_params == account_update_bio_params
      respond_with resource, location: after_update_path_for(resource)
      return resource.update_without_password(account_update_bio_params)
    end

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def edit
    unless params[:change_password].present?
      redirect_back fallback_location: current_user
    else
      respond_to do |format|
        format.html {
          @edit_password = params[:change_password] == "true"
          render :layout => 'edit_profile'
        }
      end
    end
  end

  private
  def sign_up_params
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end

  # it should has all params that may possibly be here
  # to compare to other params methods
  # to choose the way we want handle this query 
  def account_update_params
    params.require(:user).permit(:username, :fullname, :status, :current_password, :password, :password_confirmation, :avatar)
  end

  def account_update_avatar_params
    params.require(:user).permit(:avatar)
  end

  def account_update_bio_params
    params.require(:user).permit(:username, :fullname, :status)
  end

  protected
  def after_update_path_for(resource)
    user_path(resource)
  end
end
