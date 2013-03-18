class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :title
      t.text :body
      t.integer :company_id

      t.timestamps
    end
    add_index :pages, :company_id
  end
end
