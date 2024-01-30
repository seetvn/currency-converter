json.extract! currency, :id, :source_currency, :target_currency, :exchange_rate, :date, :created_at, :updated_at
json.url currency_url(currency, format: :json)
