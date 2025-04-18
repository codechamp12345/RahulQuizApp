import os
import webbrowser
import subprocess
import sys
import time

# Start the Django server
def start_server():
    try:
        # Use the current directory instead of hardcoded path
        project_dir = os.path.dirname(os.path.abspath(__file__))
        
        print(f"Starting server from: {project_dir}")
        
        # Run the Django server in a subprocess
        process = subprocess.Popen([sys.executable, 'manage.py', 'runserver'], 
                                  cwd=project_dir,
                                  stdout=subprocess.PIPE,
                                  stderr=subprocess.PIPE)
        
        # Wait a moment for the server to start
        time.sleep(2)
        
        # Check if the server started successfully
        if process.poll() is None:  # None means it's still running
            print("Server started successfully")
            # Open the browser to the specified URL
            webbrowser.open('http://127.0.0.1:8000/')
        else:
            # Get error output
            _, stderr = process.communicate()
            print(f"Failed to start server: {stderr.decode()}")
    except Exception as e:
        print(f"Error starting server: {e}")

if __name__ == '__main__':
    start_server()
