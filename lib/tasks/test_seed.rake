namespace :db do
  namespace :test do
    task prepare: :environment do
      CSV.foreach('./public/cards.csv', headers: true, header_converters: :symbol) do |row|
        row[:attack] = 0 if row[:attack] == nil
        puts "#{row[:name]} Added"
        Card.create(name: row[:name], cost: row[:cost], attack: row[:attack], set: row[:expansion].downcase)
      end
    end
  end
end
