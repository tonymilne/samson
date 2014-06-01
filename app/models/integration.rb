class Integration < ActiveRecord::Base
  has_many :stage_commands, autosave: true

  attr_accessor :id, :identifier, :name, :description, :enabled, :global_config

  def initialize(identifier, data)
    @identifier = identifier
    @name = data["name"]
    @description = data["description"]
    @global_config = data["global_config"]

    # @TODO: Need to merge in data from the database.
  end

  def enable
    self.enabled = true
  end

  def disable
    self.enabled = false
  end

  def self.integrations
    @integrations ||= begin
      integrations = []
      baseDir = "lib/integrations/"
      Dir.chdir(baseDir) do
        Dir.glob("*").each do |directory|
          identifier = directory
          yaml = YAML.load_file(File.join directory, "#{directory}.yml")
          integrations.push Integration.new identifier, yaml
        end
      end
      integrations
    end
  end

end
