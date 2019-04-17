class RegistrationsController < Devise::RegistrationsController

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # If we've got only avatar
    if account_update_params == account_update_avatar_params
      return resource.update_without_password(account_update_avatar_params)
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

  private
  def sign_up_params
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end

  def account_update_params
    params.require(:user).permit(:username, :password, :password_confirmation, :avatar)
  end

  def account_update_avatar_params
    params.require(:user).permit(:avatar)
  end

  def new_avatar
    return true
  end
end
