class QuestFinished < StandardError
    attr_reader :progress
    def initialize(progress)
      @progress = progress
      super("Quest finished")
    end
end  