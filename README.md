# Dominion Backend

This repo is backend API for the the Dominion with Friends mobile phone application built with React Native. This API is built using Ruby on Rails with multiple endpoints that provide the game with the needed data. The game is built "Words with Friends" style, which allow a user to start a game and play their turn. The game state at that point is then captured and POSTed to the backend. A notification is sent to the player who's turn is next and they make a GET request to retreive the game state and their hand. This process repeats until the game ends and a notifiction is provided to declare a winner.

On Heroku: https://dominion-backend.herokuapp.com/api/v1

## Endpoints

### Create a Game

POST '/games',
Body:
```
{competitors: [player_ids]}
```

Example Output:
```
{
    "game_id": 40,
    "players": [
        "WalterWhite",
        "Umber"
    ],
    "competitors": [
        11,
        28
    ],
    "game_cards": {
        "copper": 46,
        "curse": 10,
        "silver": 40,
        "gold": 30,
        "estate": 8,
        "duchy": 8,
        "province": 8,
        "laboratory": 10,
        "harbinger": 10,
        "festival": 10,
        "moneylender": 10,
        "vassal": 10,
        "smithy": 10,
        "moat": 10,
        "chapel": 10,
        "village": 10,
        "market": 10
    },
    "trash": [],
    "status": "active",
    "current_player": 11,
    "turn_order": [
        11,
        28
    ],
    "attack_queue": {
        "11": [],
        "28": []
    },
    "score": {
        "WalterWhite": 3,
        "Umber": 3
    },
    "decks": [
        {
            "id": 85,
            "player_id": 11,
            "username": "WalterWhite",
            "draw": [
                "copper",
                "copper",
                "copper",
                "estate",
                "copper",
                "copper",
                "estate",
                "estate",
                "copper",
                "copper"
            ],
            "discard": [],
            "deck_makeup": {
                "copper": 7,
                "estate": 3
            }
        },
        {
            "id": 86,
            "player_id": 28,
            "username": "Umber",
            "draw": [
                "copper",
                "estate",
                "copper",
                "copper",
                "copper",
                "copper",
                "copper",
                "estate",
                "estate",
                "copper"
            ],
            "discard": [],
            "deck_makeup": {
                "copper": 7,
                "estate": 3
            }
        }
    ],
    "turns": []
}
}
```

### POST a Turn

POST '/games/:id/turns', Body:
```
{
  supply: gameStateRaw.supply,
  trash: gameStateRaw.trash,
  attack_queue: gameStateRaw.attackQueue,
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
    coins: 3,
    cards_played: cards_played,
    cards_gained: cards_gained,
    cards_trashed: cards_trashed
    }
  }
```

output: status 200, if ok. 


### User Sign Up

POST 'api/v1/signup', Body:
```
{
  username: username,
  password: password,
  phone_number: phoneNumber
}
```

### Add a Friend

POST '/api/v1/friends', Body:
```
{
  player_id: your_id,
  friend_name: friend_fusername
}
```
Example Response:
```
{
    "id": 11,
    "username": "WalterWhite",
    "token": null,
    "active_games": [
        {
            "id": 40,
            "players": [
                "WalterWhite",
                "Umber"
            ],
            "current": "WalterWhite"
        }
    ],
    "complete_games": [
        {
            "id": 20,
            "players": [
                "WalterWhite",
                "Maxscores"
            ]
        }
    ],
    "friends": [
        {
            "id": 10,
            "username": "Maxscores"
        }
    ]
}
```

### User Login

GET '/api/v1/login?username={username}&password={password}`'

Example Output:

```
{
    "id": 28,
    "username": "Umber",
    "token": token,
    "active_games": [
        {
            "id": 37,
            "players": [
                "Maxscores",
                "Umber"
            ],
            "current": "Umber"
        },
        {
            "id": 40,
            "players": [
                "WalterWhite",
                "Umber"
            ],
            "current": "WalterWhite"
        }
    ],
    "complete_games": [],
    "friends": [
        {
            "id": 10,
            "username": "Maxscores"
        },
        {
            "id": 11,
            "username": "WalterWhite"
        }
    ]
}
```

### GET Player Information

GET '/api/v1/players/{id}'

Example Output:
```
{
    "id": 28,
    "username": "Umber",
    "token": token,
    "active_games": [
        {
            "id": 37,
            "players": [
                "Maxscores",
                "Umber"
            ],
            "current": "Umber"
        },
        {
            "id": 40,
            "players": [
                "WalterWhite",
                "Umber"
            ],
            "current": "WalterWhite"
        }
    ],
    "complete_games": [],
    "friends": [
        {
            "id": 10,
            "username": "Maxscores"
        },
        {
            "id": 11,
            "username": "WalterWhite"
        }
    ]
}
```

## Contributing
Contributions are welcome. We use [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/2159424) to manage tasks. If you're familiar with the game or want to contribute in other areas feel free to take a card and submit a PR. We'll review it as them come.
