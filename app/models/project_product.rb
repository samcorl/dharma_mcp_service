class ProjectProduct < ApplicationRecord
  belongs_to :project_idea
  belongs_to :product
end
