# lib/tasks/import_json_data.rake

namespace :import do
    desc 'Import data from JSON'
    task json_data: :environment do
      json_path = Rails.root.join('data/data.json')
  
      data = JSON.parse(File.read(json_path))
  
      data.each do |date, currencies|
        puts date
        puts "---------------"
        date_ = Date.parse(date)
        puts date_
        currencies.each do |currency, value|
          TestCurrency.create!(
            date: date_,
            source_currency: currency,
            target_currency: 'EUR',
            exchange_rate: value
          )
        end
      end
    end
  end
  