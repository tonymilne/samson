class Integration < ActiveRecord::Base

  attr_accessor :name, :description, :global_config, :yaml

  def enable
    self.enabled = true
  end

  def disable
    self.enabled = false
  end

  def self.installed_integrations
    @installed_integrations ||= begin
      integrations = []
      baseDir = "lib/integrations/"
      Dir.chdir(baseDir) do
        Dir.glob("*").each do |directory|
          identifier = directory
          data = YAML.load_file(File.join directory, "#{directory}.yml")
          data["identifier"] = identifier
          data["global_config"] = data["global_config"] || []
          integrations.push data
        end
      end

      integrations
    end
  end

end
