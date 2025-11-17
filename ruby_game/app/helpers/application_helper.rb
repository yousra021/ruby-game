module ApplicationHelper
    def status_badge_class(status)
        case status
        when "En cours" then "text-yellow-400"
        when "Terminée" then "text-green-400"
        when "Échouée" then "text-red-500"
        else "text-gray-400"
        end
    end      

    def action_badge(action)
        if action.include?("réussi")
          "text-green-400"
        elsif action.include?("échoué")
          "text-red-400"
        else
          "text-gray-400"
        end
    end      
end
