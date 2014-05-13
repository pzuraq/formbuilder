class CreateTableTests < ActiveRecord::Migration
  def change
    create_table :table_tests do |t|
      t.string :test_column
    end
  end
end
