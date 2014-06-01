class Admin::IntegrationsController < ApplicationController
  before_filter :authorize_super_admin!

  def index
    @integrations = Array.new
    @integrations.push Integration.new identifier: :example, name: :example
  end

  def show
    @identifier = params[:identifier]
  end

  # Updates
  # - enabled (true / false)
  # - config values
  def update
    integration = Integration.first(params[:identifier])
    # Create an integration db record if one doesn't already exist for this integration.
    if integration.nil?
      integration = Integration.new identifier: params[:identifier]
    end

    if integration.update_attributes(integration_params)
      redirect_to admin_integrations_path
    else
      flash[:error] = integrations.errors.full_messages
      render :edit
    end
  end

  protected

  def integration_params
    params.require(:integration).permit(
      :enabled,
      :config
    )
  end

end
