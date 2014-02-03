class CreatePosCashFlows < ActiveRecord::Migration
  def change
    create_table :pos_cash_entries do |t|
      t.uuid       :uuid,             index: true
      t.references :admin_user,       index: true
      t.references :company,          index: true
      t.string     :entry_type,       index: true
      t.decimal    :amount,                       precision: 8, scale: 2
      t.decimal    :previous_balance,             precision: 8, scale: 2
      t.text       :description

      t.timestamps
    end
  end
end
