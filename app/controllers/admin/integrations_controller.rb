require 'yaml'

class Admin::IntegrationsController < ApplicationController
  before_filter :authorize_super_admin!

  def index
    @installed_integrations = Integration.installed_integrations
    @integrations = Integration.all.index_by(&:identifier)
  end

  def show
    identifier = params[:identifier]

    @installed_integration = Integration.installed_integrations.detect {|integration| integration["identifier"] == identifier }

    if @installed_integration.nil?
      flash[:error] = "Intergration not found."
      redirect_to root_path
    end

    @integration = Integration.where(identifier: identifier).first_or_initialize
  end

  # Updates
  # - enabled (true / false)
  # - config values
  def update
    integration = Integration.where(identifier: params[:identifier]).first_or_create do |obj|
      obj.identifier = params[:identifier]
      obj.enabled = false
      obj.config = "{}"
    end

    attributes = integration_params
    attributes[:config] = params[:config].to_json

    if integration.update_attributes(attributes)
      flash[:notice] = "Integration updated."
      redirect_to admin_integrations_path
    else
      flash[:error] = integrations.errors.full_messages
      render :show
    end
  end

  protected

  def integration_params
    params.require(:integration).permit(
      :enabled,
      # :config
    )
  end

  # TODO: This could be used to restric the config values
  # to match the keys defined in the integration yaml.
  def config_params installed_integration
    installed_integration["global_config"]
    #.each do |config|
    #  config.each do |field, label|

    params.require(:config).permit(
      # permit only the config keys...
    )
  end

end
