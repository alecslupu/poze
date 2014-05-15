class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :user, index: true
      t.string :image
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
