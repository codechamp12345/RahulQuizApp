# Build script for quizapp_launcher.exe
import os
import sys
import subprocess

def build_launcher():
    print("Building quizapp_launcher.exe...")
    
    # Get the current directory
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Check if static folder has a favicon
    icon_path = ""
    if os.path.exists(os.path.join(current_dir, 'static', 'favicon.ico')):
        icon_path = os.path.join(current_dir, 'static', 'favicon.ico')
    
    # Build the command
    cmd = [
        'pyinstaller',
        '--onefile',
        '--name=quizapp_launcher',
        '--noconsole',
        '--hidden-import=requests'
    ]
    
    if icon_path:
        cmd.append(f'--icon={icon_path}')
    
    cmd.append('quizapp_launcher.py')
    
    # Run the command
    try:
        subprocess.run(cmd, check=True)
        print("Successfully built quizapp_launcher.exe")
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error building launcher: {e}")
        return False

if __name__ == "__main__":
    build_launcher()
