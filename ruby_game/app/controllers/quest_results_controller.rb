class QuestResultsController < ApplicationController
  def show
    begin
      @progress = CharacterQuestProgress.find(params[:id])
      @quest = @progress.quest
      @character = @progress.character
      @success = @progress.quest_status == "completed"

      @rewards = []

      if @success && !@progress.reward_given
        @reward_xp = 50
        @character.experience ||= 0
        @character.experience += @reward_xp
        @character.save!

        @rewards = InventoryItem.where(character: @character).last(3)
        @progress.update!(reward_given: true)
        
        if status == :completed
          @character.gain_experience(200)  # Par exemple, 200 XP bonus de fin de quête
        end        
      end

    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : progression de quête introuvable (id=#{params[:id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Résultat de quête introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans QuestResultsController#show : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de l'affichage du résultat de la quête." and return
    end
  end
end
