class Currency < ApplicationRecord
    validates_uniqueness_of :date, scope: [:source_currency, :target_currency]
end
