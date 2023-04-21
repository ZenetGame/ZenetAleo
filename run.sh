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

# Player 1 makes their first move.
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
leo run move 9u8 3u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 1023u32.private,
  cell_occ: 682u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 7890800848858615990577674120820649470995847806539552791604837931200094078541group.public
}" "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  positions: 0u32.private,
  _nonce: 1260228892496565700320197992505338749301641373211925149244050801561814298023group.public
}"

# Player 2 makes their first move.
echo "
###############################################################################
########                                                               ########
########            STEP 5: Player 2 makes their first move            ########
########                        Dice roll: 2                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 1>|           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2<| 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p2.json > program.json
leo run move 10u8 2u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 2815u32.private,
  cell_occ: 682u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 1004757177813353300822404771547701633947006730478073655279174959646155183747group.public
}" "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  positions: 0u32.private,
  _nonce: 1464789014133543903436410348591640130929288960599214445445608713474398327142group.public
}"

# Player 1 plays next
echo "
###############################################################################
########                                                               ########
########                  STEP 6: Player 1 moves                       ########
########                        Dice roll: 2                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 0>| 2 |>1 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p1.json > program.json
leo run move 7u8 2u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 2815u32.private,
  cell_occ: 2218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 5863476156890724550843040600428608701027004669580939694903504655995771483413group.public
}" "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  positions: 0u32.private,
  _nonce: 1260228892496565700320197992505338749301641373211925149244050801561814298023group.public
}"

# Player 2 plays next. This time the move is invalid because player 1's pieces
# in cells 9 and 10 are protected.
echo "
###############################################################################
########                                                               ########
########           STEP 7: Player 2 attempts an invalid move (!)       ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2>| 0 | 2 |>1!| 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 2 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p2.json > program.json
leo run move 6u8 3u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 3007u32.private,
  cell_occ: 2218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 6036362203879019831447420913205711606507044057841403559941745037099209138823group.public
}" "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  positions: 0u32.private,
  _nonce: 1464789014133543903436410348591640130929288960599214445445608713474398327142group.public
}"

# Because the previous move was invalid, Player 2 tries a different move with the same dice roll.
# Because the piece lands on cell #15, the piece becomes invisible.
echo "
###############################################################################
########                                                               ########
########               STEP 8: Player 2 amends their move              ########
########                        Dice roll: 3                           ########
########                 Piece becomes invisible (*)                   ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 2 | 1 | 1 |           ########
########           | 0 | 0 | 0 | 0 | 0 |*2<| 0 | 0 |<0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run move 12u8 3u8 "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  cell_state: 3007u32.private,
  cell_occ: 2218u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 6036362203879019831447420913205711606507044057841403559941745037099209138823group.public
}" "{
  owner: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  gates: 0u64.private,
  positions: 0u32.private,
  _nonce: 1464789014133543903436410348591640130929288960599214445445608713474398327142group.public
}"

# Player 1 plays next.
echo "
###############################################################################
########                                                               ########
########                   STEP 9: Player 1 moves                      ########
########                        Dice roll: 5                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 2 | 1 | 0>|           ########
########           | 0 | 0 | 0 | 0 | 0|*2*1<|0 | 0 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
cat program_p1.json > program.json
leo run move 10u8 5u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 959u32.private,
  cell_occ: 170u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 3971141806004630156214927014705437696910167048885340997783637456580646347901group.public
}" "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  positions: 0u32.private,
  _nonce: 2790178789406900946219076845702115358906487119661751887534651560275067222863group.public
}"

# Player 1 plays next again (because they rolled a 5).
echo "
###############################################################################
########                                                               ########
########                STEP 10: Player 1 moves again                  ########
########                        Dice roll: 3                           ########
########                                                               ########
########           | 1 | 2 | 1 | 2 | 1 | 2 | 0 | 2 | 1 | 0 |           ########
########           | 0 | 0 |*1 | 0 | 0 |*2<| 0 | 0 | 0 | 0 |           ########
########           | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |           ########
########                                                               ########
###############################################################################
"
leo run move 15u8 3u8 "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  cell_state: 447u32.private,
  cell_occ: 170u32.private,
  p1: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  p2: aleo1qttvkxx3expu6ueqlwrydt7v0xjpqzmayeqsqlyha8d74u6q5srqfun7cj.private,
  _nonce: 6953544847073588504911484642740252760443414457882456614014267802834665825998group.public
}" "{
  owner: aleo172xc22y5jfzun0ezw7yfc55203sy6ufdvcugysqdw2ajpw86uc9q57enk3.private,
  gates: 0u64.private,
  positions: 16384u32.private,
  _nonce: 5534725919850591397624943268698904780675877366552744519372352966937424067149group.public
}"

