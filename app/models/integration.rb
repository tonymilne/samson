class Integration < ActiveRecord::Base
  has_many :stage_commands, autosave: true

  attr_accessor :identifier, :name

  def enable
    self.enabled = true
  end

  def disable
    self.enabled = false
  end

end
