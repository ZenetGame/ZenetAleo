program zenet.aleo {

    // Zenet boards are represented by 32-bit, unsigned integers. The board
    // contains 30 cells, so a u32 works just fine.
    // There are two u32 fields: 
    // cell_state: represents whether or not a given cell is occupied or not:
    //   - cell_state = 0 -> free
    //   - cell_state = 1 -> occupied
    // cell_occ: represents who is the occupant: 
    //   - cell_occ = 0 -> player 1
    //   - cell_occ = 1 -> player 2
    
    record Board {
        owner: address,
        gates: u64,
        cell_state: u32,
        cell_occ: u32,
        p1: address,
        p2: address
    }

    // Given that the ownership of the board is passed back and forth between 
    // both players, we use a separate record to keep track of each player's
    // invisible pieces. The 'positions' field is also a 32-bit integer:
    //  - positions = 1 -> there's an invisible piece at that position
    //  - positions = 0 -> there's no invisible piece at that position
    record InvisiblePieces {
        owner: address,
        gates: u64,
        positions: u32
    }

    // This struct allows us to pass the state and occupant of a cell
    // with a single variable.
    struct Cells {
        state: u32,
        occupant: u32,
    }

    // Auxiliary function that returns true if i-th bit of 'number' is '1'
    inline get_bit(number: u32, i: u8) -> bool {
        let mask: u32 = 1u32 << i-1u8;
        return number.and(mask) > 0u32;
    }

    // Auxiliary function that sets the i-th bit of 'number' to 'bit'
    inline set_bit(number: u32, i: u8, bit: bool) -> u32{
        let mask: u32 = 1u32 << i-1u8;
        if bit {
            return number.or(mask);
        } else {
            return number.and(mask.not());
        }
    }

    // Function to get the occupant of the i-th cell according to the following convention:
    // i-th cell is empty: returns 0u8
    // i-th cell is occupied by player 1: returns 1u8
    // i-th cell is occupied by player 2: returns 2u8
    inline get_cell_occupant(cells: Cells, i: u8) -> u8 {
        let is_occupied: bool = get_bit(cells.state, i);
        if is_occupied {
            return get_bit(cells.occupant, i) ? 2u8 : 1u8;
        } else {
            return 0u8;
        }
    }

    // Function to set the occupant of a cell. Takes care of setting both the 'state' and
    // 'occupant' fields accordingly.
    inline set_cell_occupant(cells: Cells, cell: u8, occ: u8) -> Cells {
        // if occ==1u8 (player1) then bit=0, if occ==2u8 (player2) then bit=1;
        let bit: bool = occ == 2u8;
        return Cells {
            state: set_bit(cells.state, cell, true), // the cell is now occupied by a player, thus state = 1
            occupant: set_bit(cells.occupant, cell, bit),
        };
    }

    // Function to clear a cell.
    inline clear_cell(cells: Cells, cell: u8) -> Cells {
        return Cells {
            state: set_bit(cells.state, cell, false),
            occupant: set_bit(cells.occupant, cell, false),
        };
    }

    inline get_cell_type(i: u8) -> u8 {
        if i == 15u8 {          // Cell #15 = House of Second Life
            return 1u8;         
        } else if i == 20u8 {   // Cell #20 = House of Invisibility
            return 2u8;
        } else if i == 26u8 {   // Cell #26 = House of Beauty
            return 3u8;
        } else if i == 27u8 {   // Cell #27 = House of Waters
            return 4u8;
        } else if i == 28u8 {   // Cell #28 = House of Three Judges
            return 5u8;
        } else if i == 29u8 {   // Cell #29 = House of Two Judges
            return 6u8;
        } else if i == 30u8 {   // Cell #30 = House of Horus
            return 7u8;
        } else {
            return 0u8;
        }
    }

    // Used to get the opponent's address
    function get_opponent(board: Board) -> address {
        if board.owner == board.p1 {
            return board.p2;
        } else {
            return board.p1;
        }
    }

    // Returns true if the piece that the current player chose to move
    // in fact belongs to the current player.
    function piece_is_valid(origin_cell: u8, owner: address, p1: address, p2: address, cells: Cells) -> bool {
        let player: u8 = get_cell_occupant(cells, origin_cell);
        if player == 1u8 {
            return owner == p1;
        } else if player == 2u8 {
            return owner == p2;
        } else {
            return false;
        }
    }

    // In Zenet, an opponent's protected piece cannot be the target of a move,
    // which means that it cannot be exchanged for the current player's piece.
    // This function returns true if the piece located at a given cell is protected.
    function piece_is_protected(cells: Cells, cell: u8) -> bool {
        // Pieces on cells 26 through 30 are always protected
        if (26u8 <= cell && cell <= 30u8) {
            return true;    
        }
        // If the cell is empty, it makes no sense to ask for protectedness, so
        // we return false.
        let occ: u8 = get_cell_occupant(cells, cell);
        if occ == 0u8 {
            return false;
        }
        // If any of the two adjacent cells contain a piece from the same
        // player, then the piece is protected.
        let prev_cell_occ: u8 = get_cell_occupant(cells, cell - 1u8);
        let next_cell_occ: u8 = get_cell_occupant(cells, cell + 1u8);
        if (prev_cell_occ == occ || next_cell_occ == occ) {
            return true;
        } else {
            return false;
        }
    }

    // This function moves a piece from one cell to another.
    function move_piece(cells: Cells, origin_cell: u8, target_cell: u8) -> Cells {
        let occ: u8 = get_cell_occupant(cells, origin_cell);
        cells = set_cell_occupant(cells, target_cell, occ);
        cells = clear_cell(cells, origin_cell);
        return cells;
    }

    // This function exchanges the positions of two pieces.
    function exchange_pieces(cells: Cells, origin_cell: u8, target_cell: u8) -> Cells {
        let origin_cell_occ: u8 = get_cell_occupant(cells, origin_cell);
        let target_cell_occ: u8 = get_cell_occupant(cells, target_cell);
        cells = set_cell_occupant(cells, origin_cell, target_cell_occ);
        cells = set_cell_occupant(cells, target_cell, origin_cell_occ);
        return cells;
     }

    // Returns true if the resulting board after the opponent's move is consistent
    // with the current player's invisible pieces. For example, the opponent might
    // have moved a piece to a cell where there is an invisible piece that belongs
    // to the current player.
    function validate_board(board: Board, ip: InvisiblePieces) -> bool {
        if board.owner == board.p1 {
            return board.cell_state.and(board.cell_occ.and(ip.positions)) == 0u32;
        } else {
            return board.cell_state.and(ip.positions.and(board.cell_occ.not())) == 0u32;
        }
     }

    // Adds the current player's invisible pieces to the board, so that 
    // the current player can make their move. These invisible pieces
    // will be removed afterwards, before sending the board to the 
    // opponent.
    function add_invisible_pieces(board: Board, ip: InvisiblePieces) -> Cells {
        let cell_state: u32 = board.cell_state.or(ip.positions);
        let cell_occ: u32 = board.cell_occ;
        if board.owner == board.p2 {
            cell_occ = board.cell_occ.or(ip.positions);
        }
        return Cells {
            state: cell_state,
            occupant: cell_occ
        };
     }

    // If the piece on the origin cell is invisible, then it needs to continue
    // to be invisible after being moved. This function moves the corresponding
    // '1' from the origin bit to the target bit in the 'position' field.
    function update_invisible_pieces(ip_positions: u32, origin_cell: u8, target_cell: u8) -> u32 {
        if get_bit(ip_positions, origin_cell) {
            set_bit(ip_positions, origin_cell, false);
            set_bit(ip_positions, target_cell, true);
        }
        return ip_positions;
    }

    // Creates a new Board record and sets the owner to the caller, which from
    // now on will be known as player 1. It returns two InvisiblePieces records,
    // one for each player. Both are initialized to 0u32 (there are no invisible
    // pieces at the start).
    // The initial position of the pieces is as follows, where '0' means empty, '1'
    // means player 1 and '2' means player 2:
    // 
    // | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 | 1 | 2 |
    // | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
    // | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 
    // 
    // The corresponding values of 'cell_state' and 'cell_occ' are
    //
    //   - cell_state:
    //
    //  LSB
    //   |
    //   v
    // | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 | 0 | 1 |
    // | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |    =   1010101010b = 682
    // | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
    //                                       ^
    //                                       |
    //                                      MSB
    //
    //   - cell_occ:
    //
    // | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
    // | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |    =   1111111111b = 1023
    // | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
    // 
    transition new(opponent: address) -> (Board, InvisiblePieces, InvisiblePieces) {
        let opponent_address: address = opponent;
        return (Board {
            owner: self.caller,
            gates: 0u64,
            cell_state: 1023u32, // 00 0000000000 0000000000 1111111111
            cell_occ: 682u32, // 00 0000000000 0000000000 1010101010
            p1: self.caller,
            p2: opponent_address,
        },
            InvisiblePieces {
                owner: self.caller,
                gates: 0u64,
                positions: 0u32 // there are no invisible pieces at the start of a game

        },
            InvisiblePieces {
                owner: opponent_address,
                gates: 0u64,
                positions: 0u32 // there are no invisible pieces at the start of a game

        });
    }

    // This function is used to execute a move. It consumes two records:
    //   - Board: the current state of the board as generated by the last player to play
    //   - InvisiblePieces: the current positions for the invisible pieces of the current player
    //
    // It also produces two new records:
    //   - Board: the board after executing the move. If the move was invalid, the board
    //                     will remain the same. The owner of this record is the player whose turn is next 
    //   - InvisiblePieces: the updated InvisiblePieces record after executing the move.
    //
    transition make_move(origin_cell: u8, dice: u8, board: Board, ip: InvisiblePieces) -> (Board, InvisiblePieces) {
        // Validates that the board coming from the opponent is consistent with the invisible
        // pieces of the current player (if any). The owner of this record is the player that executed this move.
        assert (validate_board(board, ip));
        
        // Adds the invisible pieces from the current player to the board to execute the move
        let cells: Cells = add_invisible_pieces(board, ip);

        // Validates that the origin cell contains a piece that belongs to the current player.
        assert(piece_is_valid(origin_cell, board.owner, board.p1, board.p2, cells));

        // Validates that the dice result is valid according to the rules of the game.
        assert(1u8 <= dice && dice <= 5u8);
        
        // Validates that the origin cell is not empty
        let player: u8 = get_cell_occupant(cells, origin_cell);
        assert(player == 1u8 || player == 2u8);

        // Validates that the target cell doesn't contain a piece from current player
        let target_cell: u8 = origin_cell + dice;
        let target_cell_occupant: u8 = get_cell_occupant(cells, target_cell);
        assert(target_cell_occupant != player);

        // Validates that either the target cell is empty or it contains
        // an unprotected piece from the opponent.
        let target_empty: bool = target_cell_occupant == 0u8; 
        let protected: bool = piece_is_protected(cells, target_cell);
        let valid_move: bool = !target_empty && !protected || target_empty && !protected;
        assert( valid_move );
        
        // If the target cell is empty, then the current player's piece is moved to
        // the target cell. If the target cell is not empty (it contains an
        // unprotected opponent's piece) it exchanges the pieces.
        if target_empty {  // If target cell is empty
            cells = move_piece(cells, origin_cell, target_cell);
        } else {
            cells = exchange_pieces(cells, origin_cell, target_cell);
        }

        // Updates the invisible pieces record according to reflect the current move.
        let ip_positions: u32 = update_invisible_pieces(ip.positions, origin_cell, target_cell);

        // By default, the next player is the current player.
        let next_player: address = board.owner;

        // If dice is 2 or 3, the opponent plays next. If it's 1, 4 or 5, the current player plays again.
        if dice == 2u8 || dice == 3u8 {
            next_player = get_opponent(board);
        }
        return ( Board {
                        owner: next_player,
                        gates: board.gates,
                        cell_state: cells.state,
                        cell_occ: cells.occupant,
                        p1: board.p1,
                        p2: board.p2
                    },
                    InvisiblePieces {
                        owner: ip.owner,
                        gates: ip.gates,
                        positions: ip_positions
                    }
                );
    }

}