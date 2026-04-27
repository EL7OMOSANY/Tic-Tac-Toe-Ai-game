import math

class TicTacToeMinimax:
    """
    Tic Tac Toe AI using Minimax Algorithm with Alpha-Beta Pruning.
    This class is designed to be easily integrated with any GUI.
    """
    
    def __init__(self, ai_symbol='X', human_symbol='O', empty_symbol=''):
        """
        Initialize the AI with the symbols used in the GUI.
        """
        self.ai_symbol = ai_symbol
        self.human_symbol = human_symbol
        self.empty_symbol = empty_symbol

    def check_winner(self, board):
        """
        Checks the current state of the board.
        Returns:
            ai_symbol if AI wins
            human_symbol if Human wins
            'Tie' if it's a draw
            None if the game is still ongoing
        """
        win_conditions = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
            [0, 4, 8], [2, 4, 6]             # Diagonals
        ]
        
        for condition in win_conditions:
            # Check if all three cells in the condition match and are not empty
            if board[condition[0]] == board[condition[1]] == board[condition[2]] and board[condition[0]] != self.empty_symbol:
                return board[condition[0]]
                
        if self.empty_symbol not in board:
            return 'Tie'
            
        return None

    def minimax(self, board, depth, is_maximizing, alpha=-math.inf, beta=math.inf):
        """
        The Minimax algorithm with Alpha-Beta pruning.
        """
        winner = self.check_winner(board)
        # Base cases: evaluate the terminal states
        if winner == self.ai_symbol:
            return 10 - depth  # Prefer faster wins
        elif winner == self.human_symbol:
            return depth - 10  # Prefer slower losses
        elif winner == 'Tie':
            return 0

        if is_maximizing:
            max_eval = -math.inf
            for i in range(9):
                if board[i] == self.empty_symbol:
                    board[i] = self.ai_symbol
                    eval = self.minimax(board, depth + 1, False, alpha, beta)
                    board[i] = self.empty_symbol
                    max_eval = max(max_eval, eval)
                    alpha = max(alpha, eval)
                    if beta <= alpha:
                        break # Beta cutoff (pruning)
            return max_eval
        else:
            min_eval = math.inf
            for i in range(9):
                if board[i] == self.empty_symbol:
                    board[i] = self.human_symbol
                    eval = self.minimax(board, depth + 1, True, alpha, beta)
                    board[i] = self.empty_symbol
                    min_eval = min(min_eval, eval)
                    beta = min(beta, eval)
                    if beta <= alpha:
                        break # Alpha cutoff (pruning)
            return min_eval

    def get_best_move(self, board):
        """
        Determines the best move for the AI.
        board: A 1D list of length 9 representing the grid.
        Returns: The index (0-8) for the best move.
        """
        best_val = -math.inf
        best_move = -1
        
        # Optimization: If board is empty, take the center (speeds up the first move)
        if board.count(self.empty_symbol) == 9:
            return 4
            
        for i in range(9):
            if board[i] == self.empty_symbol:
                # Make a temporary move
                board[i] = self.ai_symbol
                # Compute evaluation function for this move
                move_val = self.minimax(board, 0, False)
                # Undo the move
                board[i] = self.empty_symbol
                
                # If the value of the current move is better than the best value, update
                if move_val > best_val:
                    best_move = i
                    best_val = move_val
                    
        return best_move

# =====================================================================
# مثال للاستخدام:
# الجزء اللي تحت ده علشان زميلك اللي هيعمل الـ GUI يفهم إزاي يربط الكود
# =====================================================================
if __name__ == "__main__":
    # 1. تعريف الـ AI وتحديد الرموز اللي الـ GUI بيستخدمها
    ai = TicTacToeMinimax(ai_symbol='X', human_symbol='O', empty_symbol='')
    
    # 2. اللوحة بتتمثل في list من 9 عناصر (من 0 لـ 8)
    # الأرقام بتمثل الأماكن على اللوحة كالتالي:
    # 0 | 1 | 2
    # ---------
    # 3 | 4 | 5
    # ---------
    # 6 | 7 | 8
    
    # مثال لحالة اللوحة الحالية
    current_board = [
        'O', '', '',
        '', 'X', '',
        '', '', ''
    ]
    
    print("اللوحة الحالية:")
    for i in range(0, 9, 3):
        print(f" {current_board[i] or '-'} | {current_board[i+1] or '-'} | {current_board[i+2] or '-'} ")
        
    # 3. بننادي على الدالة دي علشان تجيب أفضل مكان الـ AI يلعب فيه
    best_move_index = ai.get_best_move(current_board)
    
    print(f"\nالـ AI اختار يلعب في المربع رقم: {best_move_index}")
    
    # 4. بننفذ الحركة على اللوحة
    current_board[best_move_index] = ai.ai_symbol
    
    print("\nاللوحة بعد حركة الـ AI:")
    for i in range(0, 9, 3):
        print(f" {current_board[i] or '-'} | {current_board[i+1] or '-'} | {current_board[i+2] or '-'} ")
