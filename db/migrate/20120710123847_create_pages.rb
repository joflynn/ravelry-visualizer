class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :slug
      t.string :title
      t.text :body
      t.string :visibility

      t.timestamps
    end
  end
end
