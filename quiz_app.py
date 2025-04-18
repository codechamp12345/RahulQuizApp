import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QPushButton, QLabel, QVBoxLayout, QWidget
from PyQt5.QtCore import Qt

class QuizSystemApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("College Quiz System")
        self.setFixedSize(800, 600)
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        layout.setAlignment(Qt.AlignCenter)
        welcome_label = QLabel("Welcome to College Quiz System")
        welcome_label.setStyleSheet("font-size: 24px; margin-bottom: 20px;")
        welcome_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(welcome_label)
        desc_label = QLabel("Your comprehensive quiz management solution")
        desc_label.setStyleSheet("font-size: 16px; margin-bottom: 40px;")
        desc_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(desc_label)
        start_button = QPushButton("Start Quiz")
        start_button.setStyleSheet("""
            QPushButton {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 15px 32px;
                font-size: 16px;
                margin: 4px 2px;
                border-radius: 4px;
            }
            QPushButton:hover {
                background-color: #45a049;
            }
        """)
        layout.addWidget(start_button)
        self.status_label = QLabel("")
        self.status_label.setStyleSheet("color: #666; margin-top: 20px;")
        self.status_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.status_label)
        self.center_on_screen()

    def center_on_screen(self):
        screen = QApplication.desktop().screenGeometry()
        size = self.geometry()
        self.move(
            (screen.width() - size.width()) // 2,
            (screen.height() - size.height()) // 2
        )

def main():
    app = QApplication(sys.argv)
    window = QuizSystemApp()
    window.show()
    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
