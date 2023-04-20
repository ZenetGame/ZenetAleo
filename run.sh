#!/bin/bash
# First check that Leo is installed.
if ! command -v leo &> /dev/null
then
    echo "leo is not installed."
    exit
fi

# 1: Initializing Player 1
echo "
###############################################################################
########                                                               ########
########                 STEP 1: Initializing Player 1                 ########
########                                                               ########
###############################################################################
"
echo "{
  \"program\": \"zenet.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkpBUbGmWy43eKufUDiyHJc4VNMofLWBi1CgTq9GxoqNA3H\",
      \"view_key\": \"AViewKey1eN3KuiU4bHKDJo5yM3WXm9RZWkg9hBPxG6yyKe6rnKJh\",
      \"address\": \"aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3\"
  },
  \"license\": \"MIT\"
}" > program_p1.json

export PLAYER1_ADDRESS=aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3
echo "✅ Successfully initialized Player 1."

# 2: Initializing Player 2
echo "
###############################################################################
########                                                               ########
########                 STEP 2: Initializing Player 2                 ########
########                                                               ########
###############################################################################
"
echo "{
  \"program\": \"zenet.aleo\",
  \"version\": \"0.0.0\",
  \"description\": \"\",
  \"development\": {
      \"private_key\": \"APrivateKey1zkp7pHk17hq6cWoKQWJxAzHPwCupD6RECDjQZJk8t12BdEn\",
      \"view_key\": \"AViewKey1ouyBkb64s8m6BnBf1e6ibVUpL2Bx28mgVFLwD9ndbQK3\",
      \"address\": \"aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj\"
  },
  \"license\": \"MIT\"
}" > program_p2.json

export PLAYER2_ADDRESS=aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj
echo "✅ Successfully initialized Player 2."

# Create a new game.
echo "
###############################################################################
########                                                               ########
########              STEP 3: Creating a new game of Zenet             ########
########                 Player 1 creates a new game                   ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"

# Player 1 creates a new game of Zenet and specifies player 2 as the opponent.
cat program_p1.json > program.json
leo run new $PLAYER2_ADDRESS

# Player 1 throws a 3 with their dice.
echo "
###############################################################################
########                                                               ########
########            STEP 4: Player 1 makes their first move            ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0>| 2 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1<| 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 9u8 3u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 1023u32.private,
  cell_occ: 682u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 7890800848858615990577674120820649470995847806539552791604837931200094078541group.public
}"

# Player 2 throws a 1 with their dice.
echo "
###############################################################################
########                                                               ########
########            STEP 5: Player 2 makes their first move            ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 0>|           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 2<|           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p2.json > program.json
leo run make_move 10u8 1u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 2815u32.private,
  cell_occ: 682u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 1004757177813353300822404771547701633947006730478073655279174959646155183747group.public
}"

# Player 2 plays again because they threw a 1.
echo "
###############################################################################
########                                                               ########
########               STEP 6: Player 2 moves again                    ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2<|<1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 11u8 1u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 3327u32.private,
  cell_occ: 1194u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 4690870848934773469079502278409118772518817469594601138224794335084520280518group.public
}"

# Player 2 plays again because they threw a 1.
echo "
###############################################################################
########                                                               ########
########                STEP 7: Player 2 moves again                   ########
########                        Dice roll: 5                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 0>| 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2<| 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 8u8 5u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 3327u32.private,
  cell_occ: 2218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 6253988530938785790439441431526714595230824765720776138754054138472794167427group.public
}"

# Player 2 plays again because they threw a 5.
echo "
###############################################################################
########                                                               ########
########                STEP 8: Player 2 moves again                   ########
########                        Dice roll: 2                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0>| 1 |>2 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 6u8 2u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 7295u32.private,
  cell_occ: 6186u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 1360964342624937223480310004498861222944995430813378620449009068059298906317group.public
}"

# Player 1 plays next
echo "
###############################################################################
########                                                               ########
########                  STEP 9: Player 1 moves                       ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2>|>1 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p1.json > program.json
leo run make_move 7u8 1u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 7391u32.private,
  cell_occ: 6282u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 4648419441858357408883486902975267928571056081285772427130512948096998661477group.public
}"

# Player 1 plays again because they threw a 1. This time the move is invalid because
# player 2's pieces in cells 12 and 13 are protected.
echo "
###############################################################################
########                                                               ########
########           STEP 10: Player 1 attempts an invalid move           ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 1 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2<|<1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 11u8 1u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 7391u32.private,
  cell_occ: 6218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 3948426659535155817986387150244593916337145649397527561770766560222778603929group.public
}"

# Because the previous move was invalid, Player 1 tries a different move with the same dice roll.
echo "
###############################################################################
########                                                               ########
########               STEP 11: Player 1 amends his move                ########
########                        Dice roll: 1                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 0>|>1 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 2 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 8u8 1u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 7391u32.private,
  cell_occ: 6218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 3948426659535155817986387150244593916337145649397527561770766560222778603929group.public
}"

# Player 1 plays again because they threw a 1.
echo "
###############################################################################
########                                                               ########
########               STEP 12: Player 1 moves again                   ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 0 | 1 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 1<| 2 | 2 |<0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run make_move 11u8 3u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 7519u32.private,
  cell_occ: 6218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 4666265433961380448505648614738966685722508005289322014626060572623089873655group.public
}"

# Player 2 plays next.
echo "
###############################################################################
########                                                               ########
########                 STEP 13: Player 2 moves                       ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 0 | 2 | 0 | 1 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 2<| 0 | 1 |<0 | 2 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p2.json > program.json
leo run make_move 13u8 3u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 14687u32.private,
  cell_occ: 6218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 5731086421104771502536010217708377290136681316803967986602526194450695880466group.public
}"

