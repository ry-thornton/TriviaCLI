class Question < ActiveRecord::Base
    has_many :games
    has_many :users, through: :games

    def self.question_text
        Question.question_text
    end

    
end