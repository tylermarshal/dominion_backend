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

  non_kingdom_cards = [
    'Copper',
    'Curse',
    'Estate',
    'Silver',
    'Duchy',
    'Gold',
    'Province',
    'Platinum',
    'Colony'
  ]

  scope :kingdom, -> {
    where.not(name: non_kingdom_cards)
  }
end
