class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :uid
      t.text   :message
      t.boolean :read, :default=>false
      t.references :user
      t.datetime :sent_at
      t.datetime :read_at
      t.timestamps
    end
  end
end
