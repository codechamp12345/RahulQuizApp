import os
import sys
import django
import shutil
import socket
import time
import tempfile
from django.core.management import execute_from_command_line

def ensure_project_files():
    """Ensure all necessary project files are in the correct location"""
    try:
        if getattr(sys, 'frozen', False):
            # Running as executable
            base_dir = os.path.dirname(sys.executable)
        else:
            # Running as script
            base_dir = os.path.dirname(os.path.abspath(__file__))
        
        # Create temporary directory for project files using tempfile module to avoid permission issues
        temp_dir = tempfile.mkdtemp(prefix='quiz_temp_')
        print(f"Created temporary directory: {temp_dir}")
        
        # Copy required files to temp directory
        required_items = ['manage.py', 'onlinequiz', 'templates', 'static', 'db.sqlite3', 'student', 'teacher', 'quiz']
        for item in required_items:
            src = os.path.join(base_dir, item)
            dst = os.path.join(temp_dir, item)
            if os.path.exists(src):
                print(f"Copying {item} to temporary directory...")
                if os.path.isdir(src):
                    if os.path.exists(dst):
                        shutil.rmtree(dst)
                    shutil.copytree(src, dst)
                else:
                    shutil.copy2(src, dst)
            else:
                print(f"Warning: {item} not found in {base_dir}")
        
        print(f"Project files prepared in {temp_dir}")
        return temp_dir
    except Exception as e:
        print(f"Error preparing project files: {e}")
        raise

def is_port_available(port):
    """Check if a port is available"""
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    available = False
    try:
        sock.bind(("127.0.0.1", port))
        available = True
    except socket.error:
        pass
    finally:
        sock.close()
    return available

def find_available_port(start_port=8000, max_attempts=10):
    """Find an available port starting from start_port"""
    for port in range(start_port, start_port + max_attempts):
        if is_port_available(port):
            return port
    return None

def main():
    try:
        print("Starting Quiz Server...")
        
        # Setup project files
        project_dir = ensure_project_files()
        print(f"Project directory: {project_dir}")
        
        # Add the project directory to Python path
        if project_dir not in sys.path:
            sys.path.insert(0, project_dir)
        
        # Change to project directory
        os.chdir(project_dir)
        
        # Set Django settings
        os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'onlinequiz.settings')
        print("Django settings module set")
        
        # Initialize Django
        try:
            django.setup()
            print("Django initialized successfully")
        except Exception as e:
            print(f"Django initialization error: {e}")
            raise
        
        # Find an available port
        port = find_available_port()
        if not port:
            print("Could not find an available port. Using default port 8000.")
            port = 8000
        
        # Start the server
        print(f"Starting server on http://127.0.0.1:{port}")
        print("Press Ctrl+C to stop the server")
        
        # Use execute_from_command_line instead of RunserverCommand
        execute_from_command_line(['manage.py', 'runserver', f'127.0.0.1:{port}'])
        
    except Exception as e:
        print(f"Error: {str(e)}")
        if 'project_dir' in locals():
            print("Project contents:")
            try:
                for root, dirs, files in os.walk(project_dir):
                    level = root.replace(project_dir, '').count(os.sep)
                    indent = ' ' * 4 * level
                    print(f"{indent}{os.path.basename(root)}/")
                    subindent = ' ' * 4 * (level + 1)
                    for f in files:
                        print(f"{subindent}{f}")
            except Exception as walk_error:
                print(f"Error listing project contents: {walk_error}")
        
        print("\nPress Enter to exit...")
        input()
        return 1
    return 0

if __name__ == '__main__':
    sys.exit(main())
