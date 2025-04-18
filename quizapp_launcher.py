import sys
import os
import requests
import time
import subprocess
import webbrowser
from PyQt5.QtWidgets import QApplication, QMessageBox

def log_error(error_message):
    try:
        # Use a user-writable location for the log file
        log_file_path = os.path.join(os.path.expanduser("~"), "quiz_launcher_error.log")
        with open(log_file_path, "a") as f:
            f.write("--- ERROR ---\n")
            f.write(str(error_message) + "\n")
        return log_file_path
    except Exception as e:
        print(f"Failed to write to log file: {e}")
        return None

def main():
    try:
        # First try to check if the local server is running
        url = "http://127.0.0.1:8000"
        print(f"Checking if server is running at {url}")
        
        try:
            # Set a timeout for the request to avoid long waits
            resp = requests.get(url, timeout=3)
            if resp.status_code == 200:
                print("Server is running, opening browser...")
                webbrowser.open(url)
                return 0
        except requests.exceptions.RequestException as e:
            print(f"Local server not running: {e}")
            
            # Try to start the server
            try:
                print("Attempting to start the server...")
                # Get the current directory
                current_dir = os.path.dirname(os.path.abspath(__file__))
                
                # Try to run the server script
                server_script = os.path.join(current_dir, "run_quiz_server.py")
                if os.path.exists(server_script):
                    print(f"Found server script at {server_script}")
                    # Start the server in a new process
                    subprocess.Popen([sys.executable, server_script], 
                                    creationflags=subprocess.CREATE_NEW_CONSOLE)
                    
                    # Wait for the server to start
                    print("Waiting for server to start...")
                    for _ in range(5):  # Try 5 times
                        time.sleep(2)  # Wait 2 seconds between attempts
                        try:
                            resp = requests.get(url, timeout=2)
                            if resp.status_code == 200:
                                print("Server started successfully, opening browser...")
                                webbrowser.open(url)
                                return 0
                        except requests.exceptions.RequestException:
                            pass
                    
                    print("Server did not start in the expected time")
                    error_msg = QMessageBox()
                    error_msg.setIcon(QMessageBox.Warning)
                    error_msg.setWindowTitle("Server Starting")
                    error_msg.setText("The server is starting in a new window.\nPlease wait a moment and then try again.")
                    error_msg.exec_()
                    return 1
                else:
                    print(f"Server script not found at {server_script}")
            except Exception as server_start_error:
                print(f"Error starting server: {server_start_error}")
                
            error_msg = QMessageBox()
            error_msg.setIcon(QMessageBox.Critical)
            error_msg.setWindowTitle("Connection Error")
            error_msg.setText("Could not connect to the quiz server.")
            error_msg.setInformativeText("Please make sure the server is running and try again.")
            error_msg.setDetailedText(f"Error details: {str(e)}")
            error_msg.exec_()
            return 1
    except Exception as e:
        log_path = log_error(e)
        error_msg = QMessageBox()
        error_msg.setIcon(QMessageBox.Critical)
        error_msg.setWindowTitle("Application Error")
        error_msg.setText(f"An error occurred: {str(e)}")
        if log_path:
            error_msg.setInformativeText(f"Error details have been logged to {log_path}")
        error_msg.setDetailedText(f"Error details: {str(e)}")
        error_msg.exec_()
        return 1

if __name__ == "__main__":
    app = QApplication(sys.argv)
    sys.exit(main())
