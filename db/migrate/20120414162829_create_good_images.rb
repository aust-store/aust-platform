class CreateGoodImages < ActiveRecord::Migration
  def change
    create_table :good_images do |t|
      t.references :good

      t.timestamps
    end
    add_index :good_images, :good_id
  end
end
