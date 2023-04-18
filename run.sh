#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# Create a new game.
echo "
###############################################################################
########                                                               ########
########              STEP 0: Creating a new game of Zenet             ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run new

# Player 1 throws a 3 with their dice.
echo "
###############################################################################
########                                                               ########
########            STEP 1: Player 1 makes their first move            ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0>| 2 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1<| 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 9u8 3u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 1023u32.private,
  cell_occ: 682u32.private,
  p1_turn: true.private,
  _nonce: 2211352591481216869974761042943926316920009114309197613392516214590527947905group.public
}"

# Player 2 throws a 1 with their dice.
echo "
###############################################################################
########                                                               ########
########            STEP 2: Player 2 makes their first move            ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 0>|           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2<|           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 10u8 1u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 2815u32.private,
  cell_occ: 682u32.private,
  p1_turn: false.private,
  _nonce: 819669052207318550600105543085517677223240755383352883095188001438841914122group.public
}"

# Player 2 plays again because they threw a 1.
echo "
###############################################################################
########                                                               ########
########              STEP 3: Player 2 makes their 2nd move            ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2<|<1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 11u8 1u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 3327u32.private,
  cell_occ: 1194u32.private,
  p1_turn: false.private,
  _nonce: 530687729361293047609424578747373152479478357819109354284124405035513443451group.public
}"

# Player 2 plays again because they threw a 1.
echo "
###############################################################################
########                                                               ########
########              STEP 4: Player 2 makes their 3nd move            ########
########                        Dice roll: 5                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 0>| 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2<| 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 8u8 5u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 3327u32.private,
  cell_occ: 2218u32.private,
  p1_turn: false.private,
  _nonce: 6457528236497109100517835077997751934061396568663653309205195879048195237312group.public
}"

# Player 2 plays again because they threw a 5.
echo "
###############################################################################
########                                                               ########
########              STEP 5: Player 2 makes their 4nd move            ########
########                        Dice roll: 2                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0>| 1 |>2 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 6u8 2u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 7295u32.private,
  cell_occ: 6186u32.private,
  p1_turn: false.private,
  _nonce: 8190958915859650468094601569160766974606666243938391903233365104358053601340group.public
}"

# Player 1 plays next
echo "
###############################################################################
########                                                               ########
########              STEP 6: Player 1 makes their 2nd move            ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2>|>1 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 7u8 1u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 7391u32.private,
  cell_occ: 6282u32.private,
  p1_turn: true.private,
  _nonce: 7295833790962080468987204364601856474881845389697841472640249680790397000763group.public
}"

# Player 1 plays again because they threw a 1. This time the move is invalid because
# player 2's pieces in cells 12 and 13 are protected.
echo "
###############################################################################
########                                                               ########
########              STEP 6: Player 1 makes an invalid move           ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 1 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2<|<1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 11u8 1u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 7391u32.private,
  cell_occ: 6218u32.private,
  p1_turn: true.private,
  _nonce: 1213820386119861809034758939634988085626295023031510437358167258061011897523group.public
}"

# Because the previous move was invalid, Player 1 tries a different move with the same dice roll.
echo "
###############################################################################
########                                                               ########
########              STEP 7: Player 1 makes their 3rd move            ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 0>|>1 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 8u8 1u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 7391u32.private,
  cell_occ: 6218u32.private,
  p1_turn: true.private,
  _nonce: 7623306659118199990230677334715937255230044943762260939607933465444088608967group.public
}"

# Player 1 plays again because they threw a 1.
echo "
###############################################################################
########                                                               ########
########              STEP 8: Player 1 makes their 3rd move            ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 0 | 1 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 1<| 2 | 2 |<0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 11u8 3u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 7519u32.private,
  cell_occ: 6218u32.private,
  p1_turn: true.private,
  _nonce: 1709666655798966980517685407722298498496445520598886201720204101505346713871group.public
}"

# Player 2 plays next.
echo "
###############################################################################
########                                                               ########
########              STEP 9: Player 2 makes their 5th move            ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 0 | 1 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 2<| 0 | 1 |<0 | 2 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 13u8 3u8 "{
  owner: aleo10jfhm5jjg7fdgpeapdfxp8eeevfdulxm595z8w5vryevu3cgpg8qwl5r2g.private,
  gates: 0u64.private,
  cell_state: 14687u32.private,
  cell_occ: 6218u32.private,
  p1_turn: false.private,
  _nonce: 4279982311959306443017200915145501815035282765110718638962881672142855847836group.public
}"

