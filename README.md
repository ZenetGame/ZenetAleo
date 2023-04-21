# The Game of Zenet


## The original Senet game

Senet is one of the oldest known board games, originating in ancient Egypt around 3100 BCE. It was a popular game among all social classes, from pharaohs to commoners.

Senet boards have been found in tombs, including the tomb of Tutankhamun, indicating its cultural significance and association with the afterlife.

It's a two-player game, played on a rectangular board with 30 squares arranged in three rows of ten. Each player has five pawns, which they move across the board according to the roll of casting sticks or dice.

The objective is to be the first player to move all their pawns off the board, symbolizing the journey through the afterlife. Players must navigate through a series of special squares with unique properties or rules, representing various stages of the afterlife journey. Some squares allow players to move forward, some send players back, and some block movement entirely.

<img alt="zenet" width="700" src=".resources/ancient-senet-board.png">


## Zenet: The Modern Version

In Zenet, there's an added element of mystery and magic, as pieces can become invisible after landing on a specific tile.

This new rule of invisibility increases the complexity and strategy of the game, as players must adapt their moves and tactics based on hidden information.

To maintain privacy and ensure fair gameplay, Zenet uses zero-knowledge proofs to verify the legality of moves without revealing the actual positions of the invisible pieces.

Using zero-knowledge proofs in Zenet adds an extra layer of intrigue and excitement, as players must constantly adapt to the hidden aspects of the game and make strategic decisions based on incomplete information.

### Some benefits of Using Zero-Knowledge Proofs in Zenet:
- Privacy: Players' moves involving invisible pieces remain hidden, preserving the element of mystery and surprise throughout the game.
- Security: Zero-knowledge proofs protect against cheating, ensuring that all moves are legal and follow the rules of the game without disclosing sensitive information.
- Trust: The use of cryptographic techniques like zero-knowledge proofs establishes trust between players, as they can be confident that their opponent is not gaining an unfair advantage.


## Implementation Details

Zenet boards are represented by 32-bit unsigned integers. The first 30 bits represent the 30 cells in a Zenet board.

We use two 32-bit integers:

- `cell_state`: `0` means the cell is empty, `1` means the cell is occupied.

- `cell_occ`: `0` means the occupant is Player 1, `1` means it's Player 2.

When referring to individual cells, we use a 8-bit integer, with the following convention:
- `0u8`: Empty cell
- `1u8`: Player 1
- `2u8`: Player 2

For both `cell_state` and `cell_occ`, the less-significant bit (LSB) represents the first tile or cell, while the most-significant bit (MSB) represents the last one.

The board's initial configuration is always the same: each player starts with five game pieces, which are placed alternately in the first ten cells of the board.

So, the initial values for `cell_state` and `cell_occupant`, are as follows:

- `cell_state` = `00000000000000000000001111111111` = `1032u32`
- `cell_occ` = `00000000000000000000001010101010` = `682u32`

<img alt="zenet" width="700" src=".resources/data-structures.png">

### Records

The state of the game is kept on-chain with the help of two different records:
A `Board` record that represents a Zenet board.

An `InvisiblePieces` record, that represents the invisible pieces for each player.

The ownership of the `Board` is determined by the player whose turn is next, This means that both players are aware of the positions of each other's visible pieces, but not their invisible pieces. 

For that reason, each player must keep track of their own invisible pieces. To ensure fairness and prevent cheating, the positions of these invisible pieces are kept private using an `InvisiblePieces` record for each player.

```javascript
record Board {
    owner: address,
    gates: u64,
    cell_state: u32,
    cell_occ: u32,
    p1: address,
    p2: address
}

record InvisiblePieces {
    owner: address,
    gates: u64,
    positions: u32
}
```


### Transitions

There are two different transitions implemented in the game of Zenet:

- `new()`: Creates a new `Board` and two `InvisiblePieces` records, one for each player.
- `move()`: Consumes a `Board` record, an `InvisiblePieces` record, an origin cell and a dice roll and generates an updated `Board` record, along with an updated `InvisiblePieces` record for the current player.

```javascript
transition new(
    opponent: address
) -> (Board, InvisiblePieces, InvisiblePieces)

transition move(
    origin_cell: u8, 
    dice: u8, 
    board: Board, 
    ip: InvisiblePieces
) -> (Board, InvisiblePieces) 
```

## Records and Transitions Diagram
<img alt="zenet" width="1412" src=".resources/zenet-diagram.png">

## How to Build

To compile this Leo program, run:
```bash
leo build
```

## How to Run
<details open><summary>Commands and Playing the Game</summary>




