class StepsController < ApplicationController
  def result
    begin
      @step = QuestStep.find(params[:step_id])
      @success = ActiveModel::Type::Boolean.new.cast(params[:success])
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Erreur : étape introuvable (id=#{params[:step_id]}) - #{e.message}"
      redirect_to dashboard_path, alert: "Étape introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans StepsController#result : #{e.message}"
      redirect_to dashboard_path, alert: "Erreur lors de l’affichage du résultat." and return
    end
  end
end
