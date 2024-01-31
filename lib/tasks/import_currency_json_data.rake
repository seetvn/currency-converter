# lib/tasks/import_currency_json_data.rake

namespace :import do
    desc 'Import data from JSON'
    task currency_json_data: :environment do
      json_path = Rails.root.join('data/data.json')
  
      data = JSON.parse(File.read(json_path))
  
      data.each do |date, currencies|
        puts date
        puts "---------------"
        date_ = Date.parse(date)
        puts date_
        currencies.each do |currency, value|
          Currency.create!(
            date: date_,
            source_currency: 'EUR',
            target_currency: currency,
            exchange_rate: 1 / value
          )
        end
      end
    end
  end
  