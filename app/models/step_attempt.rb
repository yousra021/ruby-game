class StepAttempt < ApplicationRecord
  belongs_to :character
  belongs_to :quest_step

  enum result: { fail: 'fail', success: 'success' }
  enum choice: { riddle: 'riddle', combat: 'combat' }

  validates :attempt_count, inclusion: { in: [1, 2] }
end
