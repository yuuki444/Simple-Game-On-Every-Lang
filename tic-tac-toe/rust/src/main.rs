use std::io::{self, Write};

fn main() {
    let mut board = [[' '; 3]; 3];
    let mut current_player = 'X';

    println!("--- tic tac toe on Rust ---");

    loop {
        print_board(&board);
        println!("Ход игрока [{}]", current_player);

        let (row, col) = match get_move() {
            Some(coords) => coords,
            None => {
                println!("Неверный ввод. Введите два числа от 1 до 3 через пробел.");
                continue;
            }
        };
        if board[row][col] != ' ' {
            println!("Эта клетка уже занята! Попробуй другую.");
            continue;
        }

        board[row][col] = current_player;

        if check_win(&board, current_player) {
            print_board(&board);
            println!("Поздравляем! Игрок [{}] победил!", current_player);
            break;
        }

        if is_draw(&board) {
            print_board(&board);
            println!("Ничья! Хорошая игра.");
            break;
        }

        current_player = if current_player == 'X' { 'O' } else { 'X' };
    }
}
fn print_board(board: &[[char; 3]; 3]) {
    println!("\n  1   2   3");
    for (i, row) in board.iter().enumerate() {
        println!(" {} | {} | {}", row[0], row[1], row[2]);
        if i < 2 {
            println!("---+---+---");
        }
    }
    println!();
}
fn get_move() -> Option<(usize, usize)> {
    print!("Введите строку и столбец (например, 1 3): ");
    io::stdout().flush().ok()?;

    let mut input = String::new();
    io::stdin().read_line(&mut input).ok()?;

    let coords: Vec<usize> = input
        .split_whitespace()
        .filter_map(|s| s.parse::<usize>().ok())
        .collect();

    if coords.len() == 2 && coords[0] >= 1 && coords[0] <= 3 && coords[1] >= 1 && coords[1] <= 3 {
        Some((coords[0] - 1, coords[1] - 1))
    } else {
        None
    }
}

fn check_win(board: &[[char; 3]; 3], player: char) -> bool {
    for i in 0..3 {
        if (board[i][0] == player && board[i][1] == player && board[i][2] == player) ||
           (board[0][i] == player && board[1][i] == player && board[2][i] == player) {
            return true;
        }
    }
    if (board[0][0] == player && board[1][1] == player && board[2][2] == player) ||
       (board[0][2] == player && board[1][1] == player && board[2][0] == player) {
        return true;
    }
    false
}

fn is_draw(board: &[[char; 3]; 3]) -> bool {
    board.iter().all(|row| row.iter().all(|&cell| cell != ' '))
}
