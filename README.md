# 🚀 AI-Powered Tic Tac Toe (Flutter)

A modern, responsive, and "smart" Tic Tac Toe game built with **Flutter**. The app features a custom-built AI opponent using the **Minimax Algorithm** with **Alpha-Beta Pruning**, ensuring a challenging experience across different difficulty levels.

---

## ✨ Features

* **🧠 Smart AI Opponent:** Uses the Minimax algorithm to predict moves and play optimally.
* **🎮 Difficulty Levels:** * 🟢 **Easy:** AI makes random moves 80% of the time.
    * 🟡 **Medium:** A 50/50 mix of smart and random moves.
    * 🔴 **Hard:** The AI plays optimally (Unbeatable).
* **📱 Responsive UI:** Powered by `flutter_screenutil` to ensure a perfect look on all screen sizes.
* **❄️ Premium Effects:** Custom-painted **Snowfall Effect** background and elastic animations for markers.

---

## 🧠 The AI Brain: Minimax & Alpha-Beta Pruning

The core of this project is the `TicTacToeMinimax` class. It explores the entire game tree to find the best move.

### How it works:
1. **Minimax:** The AI simulates every possible move, then every possible response by the player, recursively.
2. **Scoring Logic:**
    * **Win:** $10 - depth$ (Prefers faster wins).
    * **Loss:** $depth - 10$ (Prefers delaying losses).
    * **Tie:** $0$.
3. **Alpha-Beta Pruning:** Optimized the search by skipping branches that won't affect the final decision, making the calculation near-instant.

---

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev)
* **Language:** [Dart](https://dart.dev)
* **Design:** `flutter_screenutil` for responsiveness.

---

## 📂 Project Structure

```text
lib/
├── main.dart             # Entry point & Theme configuration
├── tic_tac_toe_page.dart # Main Game UI & State Management
├── minimax_logic.dart    # AI Algorithm (Minimax + Alpha-Beta)
└── snow_widget.dart      # Custom Painter for background effect
```
## 🤝 Contributing
Contributions, issues, and feature requests are welcome!

## 📜 License
This project is MIT licensed.

## 👨‍💻 Developed by
Mohamed Ayman & Alaa Rehab Feel free to reach out for any inquiries or collaborations!
