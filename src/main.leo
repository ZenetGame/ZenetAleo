program zenet.aleo {

    struct Board {
        cell_state: u32,
        occupant: u32,
        p1_turn: bool,
    }

    struct Result {
        valid_move: bool
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
    inline get_cell_occupant(board: Board, i: u8) -> u8 {
        let is_occupied: bool = get_bit(board.cell_state, i);
        if is_occupied {
            return get_bit(board.occupant, i) ? 2u8 : 1u8;
        } else {
            return 0u8;
        }
    }

    inline set_cell_occupant(board: Board, cell: u8, occ: u8) -> Board {
        let bit: bool = occ == 2u8;  // if occ==1u8 (player1) then bit=0, if occ==2u8 (player2) then bit=1;
        return Board {
            cell_state: set_bit(board.cell_state, cell, true), // the cell is now occupied by a player, thus cell_state = 1
            occupant: set_bit(board.occupant, cell, bit),
            p1_turn: board.p1_turn,
        };
    }

    inline clear_cell (board: Board, cell: u8) -> Board {
        return Board {
            cell_state: set_bit(board.cell_state, cell, false),
            occupant: set_bit(board.occupant, cell, false),
            p1_turn: board.p1_turn,
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

    inline opponent(player: u8) -> u8 {
        if player == 1u8 {
            return 2u8;
        } else if player == 2u8 {
            return 1u8;
        } else {
            return 0u8;
        }
    }

    transition new() -> Board {
        return Board {
            cell_state: 1023u32, // 00 0000000000 0000000000 1111111111
            occupant: 682u32, // 00 0000000000 0000000000 1010101010
            p1_turn: true, // player 1 always starts
        };
    }

    function change_player(board: Board) -> Board {
        return Board {
            cell_state: board.cell_state, // 00 0000000000 0000000000 1111111111
            occupant: board.occupant, // 00 0000000000 0000000000 1010101010
            p1_turn: ! board.p1_turn, // player 1 always starts
        };
    }

    function xnor(x: bool, y: bool) -> bool {
        return ! (x && !y) || (!x && y); 
    }

    transition make_move(origin_cell: u8, dice: u8, board: Board) -> (Board, Result) {
        let player: u8 = get_cell_occupant(board, origin_cell);
        assert(xnor(board.p1_turn, player == 1u8)); // It's the correct player's turn
        let target_cell: u8 = origin_cell + dice;
        assert(player == 1u8 || player == 2u8); // Player ID is valid 
        assert(1u8 <= dice && dice <= 5u8); // Dice result is valid
        assert(player != 0u8); // Origin cell is not empty
        let target_cell_occupant: u8 = get_cell_occupant(board, target_cell);
        assert(target_cell_occupant != player); // Target cell doesn't contain a piece from current player
        let valid_move: bool = true;
        if target_cell_occupant == 0u8 {  // If target cell is empty
            board = move_piece(board, origin_cell, target_cell); // Move player's piece from the origin cell to the target cell
        } else { // If the target cell contains a piece from the opponent player
            if ! piece_is_protected(board, target_cell) { // If the target cell doesn't contain a protected piece
                board = exchange_pieces(board, origin_cell, target_cell); // Exchange player1's and player2's pieces
            } else {
                valid_move = false;
            }
        }
        let new_board: Board = board;
        if dice == 2u8 || dice == 3u8 {    // If dice is 2 or 3, the other player plays. If it's 1, 4 or 5, the same player plays again
            new_board = change_player(board);
        }
        let result: Result = Result{valid_move: valid_move};
        if valid_move {
            return (new_board, result);
        } else {
            return (board, result);
        }
    }

    function piece_is_protected(board: Board, cell: u8) -> bool {
        let player: u8 = get_cell_occupant(board, cell);
        if (26u8 <= cell && cell <= 30u8) {
            return true;                    // Pieces on cells 26 through 30 are always protected    
        } 
        let prev_cell_occ: u8 = get_cell_occupant(board, cell - 1u8);
        let next_cell_occ: u8 = get_cell_occupant(board, cell + 1u8);
        if (prev_cell_occ == player || next_cell_occ == player) { // If there are at least two pieces together
            return true;
        } else {
            return false;
        }
    }

    function move_piece(board: Board, origin_cell: u8, target_cell: u8) -> Board {
        let occ: u8 = get_cell_occupant(board, origin_cell);
        board = set_cell_occupant(board, target_cell, occ);
        board = clear_cell (board, origin_cell);
        return board;
    }

    function exchange_pieces(board: Board, origin_cell: u8, target_cell: u8) -> Board {
        let origin_cell_occ: u8 = get_cell_occupant(board, origin_cell);
        let target_cell_occ: u8 = get_cell_occupant(board, target_cell);
        board = set_cell_occupant(board, origin_cell, target_cell_occ);
        board = set_cell_occupant(board, target_cell, origin_cell_occ);
        return board;
     }

}