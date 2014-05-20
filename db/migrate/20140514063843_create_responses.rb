class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :respondent_id
      t.hstore :answers
      t.integer :form_id

      t.timestamps
    end
  end
end
