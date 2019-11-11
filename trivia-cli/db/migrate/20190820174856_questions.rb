class Questions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :question_text
      t.string :correct_answer
      t.string :incorrect_answer1
      t.string :incorrect_answer2
      t.string :incorrect_answer3
    end
  end
end
