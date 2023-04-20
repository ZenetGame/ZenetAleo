program zenet.aleo {

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

    struct Cells {
        state: u32,
        occupant: u32,
    }

    // Returns true if i-th bit of 'number' is '1'
    inline get_bit(number: u32, i: u8) -> bool {
        let mask: u32 = 1u32 << i-1u8;
        return number.and(mask) > 0u32;
    }

    // Sets the i-th bit of 'number' to 'bit'
    inline set_bit(number: u32, i: u8, bit: bool) -> u32{
        let mask: u32 = 1u32 << i-1u8;
        if bit {
            return number.or(mask);
        } else {
            return number.and(mask.not());
        }
    }

    // Returns occupant of i-th cell according to the following convention:
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

    inline set_cell_occupant(cells: Cells, cell: u8, occ: u8) -> Cells {
        let bit: bool = occ == 2u8;  // if occ==1u8 (player1) then bit=0, if occ==2u8 (player2) then bit=1;
        return Cells {
            state: set_bit(cells.state, cell, true), // the cell is now occupied by a player, thus cell_state = 1
            occupant: set_bit(cells.occupant, cell, bit),
        };
    }

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

    function get_opponent(board: Board) -> address {
        if board.owner == board.p1 {
            return board.p2;
        } else {
            return board.p1;
        }
    }

    function xor_(x: bool, y: bool) -> bool {
        return (x && !y) || (!x && y); 
    }

    // Returns true if the piece that the current player chose to move
    // indeed belongs to the current player.
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

    function piece_is_protected(cells: Cells, cell: u8) -> bool {
        if (26u8 <= cell && cell <= 30u8) {
            return true;                    // Pieces on cells 26 through 30 are always protected    
        }
        let player: u8 = get_cell_occupant(cells, cell);
        if player == 0u8 {
            return false;
        }
        let prev_cell_occ: u8 = get_cell_occupant(cells, cell - 1u8);
        let next_cell_occ: u8 = get_cell_occupant(cells, cell + 1u8);
        if (prev_cell_occ == player || next_cell_occ == player) { // If there are at least two pieces together
            return true;
        } else {
            return false;
        }
    }

    function move_piece(cells: Cells, origin_cell: u8, target_cell: u8) -> Cells {
        let occ: u8 = get_cell_occupant(cells, origin_cell);
        cells = set_cell_occupant(cells, target_cell, occ);
        cells = clear_cell(cells, origin_cell);
        return cells;
    }

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
    // to be invisible after being moved. 
    function update_invisible_pieces(ip_positions: u32, origin_cell: u8, target_cell: u8) -> u32 {
        if get_bit(ip_positions, origin_cell) {
            set_bit(ip_positions, origin_cell, false);
            set_bit(ip_positions, target_cell, true);
        }
        return ip_positions;
    }

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
                positions: 0u32

        },
            InvisiblePieces {
                owner: opponent_address,
                gates: 0u64,
                positions: 0u32

        });
    }

    transition make_move(origin_cell: u8, dice: u8, board: Board, ip: InvisiblePieces) -> (Board, InvisiblePieces) {
        assert (validate_board(board, ip));
        let cells: Cells = add_invisible_pieces(board, ip);
        assert(piece_is_valid(origin_cell, board.owner, board.p1, board.p2, cells));
        assert(1u8 <= dice && dice <= 5u8); // Dice result is valid
        let player: u8 = get_cell_occupant(cells, origin_cell);
        assert(player == 1u8 || player == 2u8); // The origin cell is not empty
        assert(! xor_(board.owner == board.p1, player == 1u8)); // The piece to be moved belongs to the current player
        let target_cell: u8 = origin_cell + dice;
        let target_cell_occupant: u8 = get_cell_occupant(cells, target_cell);
        assert(target_cell_occupant != player); // Target cell doesn't contain a piece from current player
        let target_empty: bool = target_cell_occupant == 0u8; 
        let protected: bool = piece_is_protected(cells, target_cell);
        let valid_move: bool = !target_empty && !protected || target_empty && !protected;
        assert( valid_move );
        if target_empty {  // If target cell is empty
            cells = move_piece(cells, origin_cell, target_cell); // Move player's piece from the origin cell to the target cell
        } else { // If the target cell contains a piece from the opponent player
            cells = exchange_pieces(cells, origin_cell, target_cell); // Exchange player1's and player2's pieces
        }
        let ip_positions: u32 = update_invisible_pieces(ip.positions, origin_cell, target_cell);
        let next_player: address = board.owner;
        if dice == 2u8 || dice == 3u8 {    // If dice is 2 or 3, the other player plays. If it's 1, 4 or 5, the same player plays again
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