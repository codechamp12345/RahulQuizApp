import sys
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, 
                           QLabel, QPushButton, QProgressBar, QStackedWidget)
from PyQt6.QtCore import Qt, QTimer
from PyQt6.QtGui import QFont, QColor
import json
import random

class SoloQuizSystem(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Solo Quiz System")
        self.setMinimumSize(800, 600)
        self.setStyleSheet("background-color: #1a1a2e; color: #ffffff;")
        
        # Initialize player stats
        self.player_stats = {
            "level": 1,
            "xp": 0,
            "rank": "E",
            "quests_completed": 0,
            "achievements": []
        }
        
        # Create main widget and layout
        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        layout = QVBoxLayout(main_widget)
        
        # Create status window
        self.status_label = QLabel("STATUS WINDOW")
        self.status_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.status_label.setStyleSheet("""
            QLabel {
                background-color: #16213e;
                padding: 20px;
                border: 2px solid #00ff88;
                border-radius: 10px;
                font-size: 18px;
            }
        """)
        layout.addWidget(self.status_label)
        
        # XP Progress bar
        self.xp_bar = QProgressBar()
        self.xp_bar.setStyleSheet("""
            QProgressBar {
                border: 2px solid #00ff88;
                border-radius: 5px;
                text-align: center;
            }
            QProgressBar::chunk {
                background-color: #00ff88;
            }
        """)
        layout.addWidget(self.xp_bar)
        
        # Start Quiz button
        start_button = QPushButton("START QUEST")
        start_button.setStyleSheet("""
            QPushButton {
                background-color: #00ff88;
                color: #1a1a2e;
                padding: 10px;
                border-radius: 5px;
                font-weight: bold;
                font-size: 16px;
            }
            QPushButton:hover {
                background-color: #00cc6a;
            }
        """)
        start_button.clicked.connect(self.start_quest)
        layout.addWidget(start_button)
        
        self.update_status_window()
        
    def update_status_window(self):
        status_text = f"""
        Level: {self.player_stats['level']}
        XP: {self.player_stats['xp']}/100
        Rank: {self.player_stats['rank']}
        Quests Completed: {self.player_stats['quests_completed']}
        """
        self.status_label.setText(status_text)
        self.xp_bar.setValue(self.player_stats['xp'])
        
    def start_quest(self):
        # Placeholder for quiz functionality
        self.player_stats['xp'] += 10
        if self.player_stats['xp'] >= 100:
            self.player_stats['level'] += 1
            self.player_stats['xp'] = 0
            self.level_up_announcement()
        
        self.player_stats['quests_completed'] += 1
        self.update_status_window()
    
    def level_up_announcement(self):
        # Placeholder for level up animation and sound
        print(f"LEVEL UP! You are now level {self.player_stats['level']}")

def main():
    app = QApplication(sys.argv)
    window = SoloQuizSystem()
    window.show()
    sys.exit(app.exec())

if __name__ == '__main__':
    main()
