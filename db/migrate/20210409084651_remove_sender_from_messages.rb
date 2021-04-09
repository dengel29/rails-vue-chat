class RemoveSenderFromMessages < ActiveRecord::Migration[6.1]
  def change
    change_table :messages do |t|
      t.remove_references :sender
    end
  end
end
