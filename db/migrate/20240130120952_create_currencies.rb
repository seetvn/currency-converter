class CreateCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :currencies do |t|
      t.string :source_currency
      t.string :target_currency
      t.float :exchange_rate
      t.date :date

      t.timestamps
    end
  end
end
