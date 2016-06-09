class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name,		null: false, default: ""
      t.string :last_name,		null: false, default: ""
      t.string :email,			null: false, default: ""

      t.timestamps null: false
    end
  end
end
