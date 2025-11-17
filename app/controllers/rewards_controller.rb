class RewardsController < ApplicationController
  before_action :require_login

  def choose
    character = current_character

    begin
      item = Equipment.find_by(id: params[:item_id])

      if item.nil?
        return redirect_to dashboard_index_path, alert: "❌ Objet introuvable."
      end

      if InventoryItem.exists?(character: character, equipment: item)
        return redirect_to dashboard_index_path, alert: "⚠️ Tu as déjà cet objet dans ton inventaire."
      end

      InventoryItem.create!(character: character, equipment: item, equipped: false)
      redirect_to dashboard_index_path, notice: "🎁 Objet ajouté à ton inventaire."
    rescue => e
      $stderr.puts "Erreur dans RewardsController#choose : #{e.message}"
      redirect_to dashboard_index_path, alert: "Erreur lors de la sélection de la récompense."
    end
  end
end
