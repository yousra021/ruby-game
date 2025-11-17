class Gamemaster::QuestsController < ApplicationController
  before_action :require_gamemaster!
  before_action :set_quest, only: %i[edit update destroy]

  def index
    @quests = Quest.all
  rescue => e
    $stderr.puts "Erreur dans index (QuestsController) : #{e.message}"
    redirect_to root_path, alert: "Erreur lors du chargement des quêtes."
  end

  def new
    @quest = Quest.new
    1.times do
      step = @quest.quest_steps.build
      step.build_riddle
      step.build_npc
    end
  rescue => e
    $stderr.puts "Erreur dans new (QuestsController) : #{e.message}"
    redirect_to gamemaster_quests_path, alert: "Erreur lors de la création d’une nouvelle quête."
  end

  def create
    @quest = Quest.new(quest_params)
    @quest.creator = current_user
    if @quest.save
      redirect_to gamemaster_quests_path, notice: 'Quête créée'
    else
      render :new, status: :unprocessable_entity
    end
  rescue => e
    $stderr.puts "Erreur dans create (QuestsController) : #{e.message}"
    redirect_to gamemaster_quests_path, alert: "Erreur lors de la création de la quête."
  end

  def show
    begin
      @quest = Quest.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      $stderr.puts "Quête introuvable (id=#{params[:id]}) : #{e.message}"
      redirect_to gamemaster_quests_path, alert: "Quête introuvable." and return
    rescue => e
      $stderr.puts "Erreur dans show (QuestsController) : #{e.message}"
      redirect_to gamemaster_quests_path, alert: "Erreur lors de l'affichage de la quête." and return
    end
  end

  def edit
    # @quest déjà défini dans set_quest
  end

  def update
    if @quest.update(quest_params)
      redirect_to gamemaster_quests_path, notice: 'Quête mise à jour'
    else
      render :edit, status: :unprocessable_entity
    end
  rescue => e
    $stderr.puts "Erreur dans update (QuestsController) : #{e.message}"
    redirect_to gamemaster_quests_path, alert: "Erreur lors de la mise à jour de la quête."
  end

  def destroy
    @quest.destroy
    redirect_to gamemaster_quests_path, notice: 'Quête supprimée'
  rescue => e
    $stderr.puts "Erreur dans destroy (QuestsController) : #{e.message}"
    redirect_to gamemaster_quests_path, alert: "Erreur lors de la suppression de la quête."
  end

  def new_step_template
    begin
      request.format = :html
      @step = QuestStep.new
      @step.build_riddle
      @step.build_npc

      builder = ActionView::Helpers::FormBuilder.new(
        "quest[quest_steps_attributes][#{params[:index]}]",
        @step,
        view_context,
        {}
      )

      render partial: 'quest_step_fields', locals: { f: builder }
    rescue => e
      $stderr.puts "Erreur dans new_step_template : #{e.message}"
      render plain: "Erreur lors du rendu du formulaire d’étape.", status: :internal_server_error
    end
  end

  private

  def require_gamemaster!
    redirect_to root_path unless current_user&.gamemaster?
  rescue => e
    $stderr.puts "Erreur dans require_gamemaster! : #{e.message}"
    redirect_to root_path, alert: "Erreur de permission MJ."
  end

  def set_quest
    @quest = Quest.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    $stderr.puts "Quête introuvable (id=#{params[:id]}) : #{e.message}"
    redirect_to gamemaster_quests_path, alert: "Quête introuvable." and return
  rescue => e
    $stderr.puts "Erreur dans set_quest : #{e.message}"
    redirect_to gamemaster_quests_path, alert: "Erreur lors du chargement de la quête." and return
  end

  def quest_params
    params.require(:quest).permit(
      :title, :description, :reward_experience,
      quest_steps_attributes: [
        :id, :description, :base_experience, :has_riddle, :has_combat, :_destroy,
        { riddle_attributes: [:id, :question, :correct_answer, :wrong_answers, :_destroy] },
        { npc_attributes: [:id, :name, :health, :strength, :_destroy] }
      ]
    )
  end
end
