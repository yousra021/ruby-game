class CompletedStep < ApplicationRecord
  belongs_to :character
  belongs_to :quest_step
end
