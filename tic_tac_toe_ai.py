import math
import random


class TicTacToeMinimax:
    """
    Tic Tac Toe AI using Minimax Algorithm with Alpha-Beta Pruning.
    Supports 3 difficulty levels: easy, medium, hard.
    """

    EASY   = 'easy'
    MEDIUM = 'medium'
    HARD   = 'hard'

    def __init__(self, ai_symbol='X', human_symbol='O', empty_symbol='',
                 difficulty=HARD):
        """
        Initialize the AI.

        Parameters
        ----------
        ai_symbol    : symbol used by the AI (default 'X')
        human_symbol : symbol used by the human (default 'O')
        empty_symbol : symbol for empty cells (default '')
        difficulty   : 'easy' | 'medium' | 'hard'  (default 'hard')
        """
        self.ai_symbol     = ai_symbol
        self.human_symbol  = human_symbol
        self.empty_symbol  = empty_symbol
        self.difficulty    = difficulty

    # ------------------------------------------------------------------
    # Core logic
    # ------------------------------------------------------------------

    def check_winner(self, board):
        """
        Check board state.

        Returns
        -------
        ai_symbol     – AI wins
        human_symbol  – Human wins
        'Tie'         – draw
        None          – game still going
        """
        win_conditions = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],   # rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8],   # columns
            [0, 4, 8], [2, 4, 6],               # diagonals
        ]

        for a, b, c in win_conditions:
            if (board[a] == board[b] == board[c]
                    and board[a] != self.empty_symbol):
                return board[a]

        if self.empty_symbol not in board:
            return 'Tie'

        return None

    def _empty_cells(self, board):
        return [i for i, v in enumerate(board) if v == self.empty_symbol]

    def minimax(self, board, depth, is_maximizing,
                alpha=-math.inf, beta=math.inf):
        """Minimax with Alpha-Beta pruning (used for medium & hard)."""
        winner = self.check_winner(board)
        if winner == self.ai_symbol:
            return 10 - depth
        if winner == self.human_symbol:
            return depth - 10
        if winner == 'Tie':
            return 0

        if is_maximizing:
            max_eval = -math.inf
            for i in self._empty_cells(board):
                board[i] = self.ai_symbol
                val = self.minimax(board, depth + 1, False, alpha, beta)
                board[i] = self.empty_symbol
                max_eval = max(max_eval, val)
                alpha = max(alpha, val)
                if beta <= alpha:
                    break
            return max_eval
        else:
            min_eval = math.inf
            for i in self._empty_cells(board):
                board[i] = self.human_symbol
                val = self.minimax(board, depth + 1, True, alpha, beta)
                board[i] = self.empty_symbol
                min_eval = min(min_eval, val)
                beta = min(beta, val)
                if beta <= alpha:
                    break
            return min_eval

    # ------------------------------------------------------------------
    # Move selection – one method per difficulty
    # ------------------------------------------------------------------

    def _best_minimax_move(self, board):
        """Return the optimal move index using full minimax."""
        # Optimisation: take centre on an empty board
        if board.count(self.empty_symbol) == 9:
            return 4

        best_val, best_move = -math.inf, -1
        for i in self._empty_cells(board):
            board[i] = self.ai_symbol
            val = self.minimax(board, 0, False)
            board[i] = self.empty_symbol
            if val > best_val:
                best_val, best_move = val, i
        return best_move

    def _random_move(self, board):
        """Return a completely random empty cell."""
        return random.choice(self._empty_cells(board))

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def get_best_move(self, board):
        """
        Return the AI's chosen move index (0-8) based on difficulty.

        board : list of 9 elements representing the 3x3 grid.

        Grid layout:
            0 | 1 | 2
            ---------
            3 | 4 | 5
            ---------
            6 | 7 | 8
        """
        empty = self._empty_cells(board)
        if not empty:
            return -1  # no move available

        if self.difficulty == self.EASY:
            # 100 % random
            return self._random_move(board)

        elif self.difficulty == self.MEDIUM:
            # 50 % chance of playing optimally, otherwise random
            if random.random() < 0.5:
                return self._best_minimax_move(board)
            return self._random_move(board)

        else:  # HARD
            # Full minimax – never loses
            return self._best_minimax_move(board)

    def set_difficulty(self, difficulty):
        """Change difficulty at runtime: 'easy' | 'medium' | 'hard'."""
        if difficulty not in (self.EASY, self.MEDIUM, self.HARD):
            raise ValueError(f"difficulty must be one of: easy, medium, hard")
        self.difficulty = difficulty


# ======================================================================
# Demo – command-line game
# ======================================================================

def print_board(board, empty=''):
    symbols = [v if v != empty else '-' for v in board]
    for row in range(3):
        i = row * 3
        print(f" {symbols[i]} | {symbols[i+1]} | {symbols[i+2]} ")
        if row < 2:
            print("---+---+---")


def play_game():
    print("=== Tic Tac Toe ===")
    print("Choose difficulty level:")
    print("  1. Easy")
    print("  2. Medium")
    print("  3. Hard")

    choice = input("Your choice (1/2/3): ").strip()
    diff_map = {'1': 'easy', '2': 'medium', '3': 'hard'}
    difficulty = diff_map.get(choice, 'hard')
    print(f"\nDifficulty set to: {difficulty}\n")

    ai = TicTacToeMinimax(ai_symbol='X', human_symbol='O',
                          empty_symbol='', difficulty=difficulty)

    board = [''] * 9
    current_player = 'human'  # human goes first

    while True:
        print_board(board)
        winner = ai.check_winner(board)
        if winner:
            if winner == 'Tie':
                print("\nIt's a tie!")
            elif winner == ai.ai_symbol:
                print("\nAI wins! Better luck next time.")
            else:
                print("\nCongratulations! You win!")
            break

        if current_player == 'human':
            try:
                move = int(input("\nChoose a cell (0-8): "))
                if move < 0 or move > 8 or board[move] != '':
                    print("Invalid move, try again.")
                    continue
                board[move] = ai.human_symbol
            except ValueError:
                print("Please enter a valid number.")
                continue
            current_player = 'ai'

        else:
            move = ai.get_best_move(board)
            board[move] = ai.ai_symbol
            print(f"\nAI played at cell: {move}")
            current_player = 'human'


if __name__ == "__main__":
    play_game()
