# Dominion Backend

## Endpoints

POST '/games',
body:
```
{competitors: [player_ids]}
```

output:
```
{
  :game_id=> integer,
  :competitors=>[integers],
  :game_cards=> {
    :supply
  },
  :trash=>[],
  :status=>"active",
  :decks=>
    [{:id=>integer,
      :competitor_id=>integer,
      :draw=>
       ["copper",
        "copper",
        "estate",
        "estate",
        "estate",
        "copper",
        "copper",
        "copper",
        "copper",
        "copper"],
      :discard=>[],
      :deck_makeup=>{:copper=>7, :estate=>3}
      }]
}
```

POST '/games/:id/turns', body:
```
{
  decks: [
    {
      deck_id: deck_1_id,
      draw: deck_1_new_draw,
      discard: deck_1_new_discard
      },
    {
      deck_id: deck_2.id,
      draw: deck_2.draw,
      discard: deck_2.discard
      }
  ],
  turn: {
    competitor_id: deck_1.competitor.id,
    coins: 3,
    cards_played: cards_played,
    cards_gained: cards_gained,
    cards_trashed: cards_trashed
    }
  }
```

output: status 200, if ok. 
