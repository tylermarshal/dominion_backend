class Card < ApplicationRecord
  has_many :game_cards

  enum set: [:dominion,
             :intrigue,
             :seaside,
             :prosperity,
             :hinterlands,
             :dark_ages,
             :adventures,
             :empires,
             :nocturne,
             :alchemy,
             :cornucopia,
             :guilds,
             :promo]
end
