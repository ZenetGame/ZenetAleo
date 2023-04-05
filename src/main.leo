program zenet.aleo {

    struct Board {
        cell_state: u32,
        occupant: u32,
        p1_turn: bool,
    }

    // Returns true if i-th bit of number is 1
    inline get_bit(number: u32, i: u8) -> bool {
        // The bug happens with either of these two ways of calculating the mask:
        // let mask: u32 = 2u32 ** i;
        let mask: u32 = 1u32 << i;
        // return number.and(mask) > 0u32;
        return true;
    }

    // Returns occupant of i-th cell according to the following convention:
    // i-th cell is empty: returns 0u8
    // i-th cell is occupied by player 1: returns 1u8
    // i-th cell is occupied by player 2: returns 2u8
    inline get_cell_occupant(board: Board, i: u8) -> u8 {
        let is_occupied: bool = get_bit(board.cell_state, i);
        if is_occupied {
            return get_bit(board.occupant, i) ? 1u8 : 0u8 + 1u8;
        } else {
            return 0u8;
        }
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

    inline opponent(player: u8) -> u8 {
        return player == 1u8 ? 2u8 : 1u8;
    }

    transition new() -> Board {
        return Board {
            cell_state: 1023u32, // 00 0000000000 0000000000 1111111111
            occupant: 682u32, // 00 0000000000 0000000000 1010101010
            p1_turn: true, // player 1 always starts
        };
    }

    transition make_move(player: u8, origin_cell: u8, dice: u8, board: Board) -> Board {
        let target_cell: u8 = origin_cell + dice;
        assert(player == 1u8 || player == 2u8); // Player ID is valid 
        assert(1u8 <= dice && dice <= 5u8); // Dice result is valid
        assert(get_cell_occupant(board, origin_cell) == player); // Origin cell is not empty and piece belongs to current player
        assert(get_cell_occupant(board, target_cell) != player); // Target cell doesn't contain a piece from current player
        if get_cell_occupant(board, target_cell) == opponent(player) { // If the target cell contains a piece from the opponent player
            if ! piece_is_protected(board, target_cell) { // If the target cell doesn't contain a protected piece
                exchange_pieces(board, origin_cell, target_cell); // Exchange player1's and player2's pieces
            } else {
                // Return some error
            }
        } else {
            // move_piece(cell, target_cell, board); // Move player's piece from the origin cell to the target cell
        }
        return board;
    }

    function piece_is_protected(board: Board, cell: u8) -> bool {
        let player: u8 = get_cell_occupant(board, cell);
        assert(player != 0u8);              // The cell is not empty
        if (26u8 <= cell && cell <= 30u8) {
            return true;                    // Pieces on cells 26 through 30 are always protected    
        }
        assert(1u8 < cell && cell < 26u8); // It makes no sense to check for protectedness for cells outside this range
        let prev_cell_occ: u8 = get_cell_occupant(board, cell - 1u8);
        let next_cell_occ: u8 = get_cell_occupant(board, cell + 1u8);
        if (prev_cell_occ == player || next_cell_occ == player) { // If there are at least two pieces together
            return true;
        } else {
            return false;
        }
    }

    inline exchange_pieces(board: Board, cell1: u8, cell2: u8) {
        let occ1: u8 = get_cell_occupant(board, cell1);
        let occ2: u8 = get_cell_occupant(board, cell2);
        set_cell_occupant(board, cell1, occ2);
        set_cell_occupant(board, cell2, occ1);
    }

    inline set_cell_occupant(board: Board, cell: u8, occ: u8) {

    }

}