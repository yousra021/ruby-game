class Riddle < ApplicationRecord
  belongs_to :quest_step

  # Retourne un tableau avec la bonne réponse et les mauvaises réponses
  def answers
    wrongs = JSON.parse(wrong_answers || "[]")
    (wrongs + [correct_answer]).shuffle
  end
end
