class StageIntegration < ActiveRecord::Base
  belongs_to :stage
  belongs_to :integration, autosave: true
end
