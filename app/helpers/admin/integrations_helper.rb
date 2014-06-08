module Admin::IntegrationsHelper

  def show_enabled integration
    value = "disabled"
    if integration.nil?
      return value
    end

    if defined? integration
      value = integration.enabled ? "enabled" : "disabled"
    end
    value
  end

  # @TODO: the json should probably be converted to a hash in the controller/model
  def value_from_config config, key
    hash = JSON.parse config
    hash[key] || ""
  end

end
