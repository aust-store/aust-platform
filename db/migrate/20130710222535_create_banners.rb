class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.references :company, index: true
      t.string :image
      t.string :title
      t.string :url
      t.string :position

      t.timestamps
    end
  end
end
