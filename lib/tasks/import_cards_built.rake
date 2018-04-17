require 'csv'

task import_cards_built: :environment do
  CSV.foreach('./public/cards_built_2018-04-07.csv', headers: true, header_converters: :symbol) do |row|
    row[:attack] = 0 if row[:attack] == nil
    puts "#{row[:name]} Added"
    Card.create(name: row[:name], cost: row[:cost], attack: row[:attack], set: row[:expansion].downcase)
  end
end
