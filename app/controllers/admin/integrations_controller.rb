require 'yaml'

class Admin::IntegrationsController < ApplicationController
  before_filter :authorize_super_admin!

  def index
    @integrations = Integration.integrations
  end

  def show
    identifier = params[:identifier]
    @integration = Integration.integrations.detect {|integration| integration.identifier == identifier }
    # Create the integration if it is nil.
    # @integration ||= Integration.new identifier, {}
  end

  def create
    Rails.logger.info "attempting to create a new integration record"
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
