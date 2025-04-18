@echo off
echo Installing PyInstaller and dependencies...
python -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org pyinstaller
python -m pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt

echo Building Quiz Server executable...
python -m PyInstaller --name=quiz_server ^
  --onefile ^
  --console ^
  --add-data "templates;templates" ^
  --add-data "static;static" ^
  --add-data "manage.py;." ^
  --add-data "onlinequiz;onlinequiz" ^
  --add-data "db.sqlite3;." ^
  --add-data "student;student" ^
  --add-data "teacher;teacher" ^
  --add-data "quiz;quiz" ^
  --hidden-import=django ^
  --hidden-import=django.template.defaulttags ^
  --hidden-import=django.template.loader_tags ^
  --hidden-import=django.contrib.messages.storage.fallback ^
  --hidden-import=django.contrib.staticfiles ^
  --hidden-import=django.contrib.admin ^
  --hidden-import=django.contrib.auth ^
  --hidden-import=django.contrib.contenttypes ^
  --hidden-import=django.contrib.sessions ^
  --hidden-import=django.contrib.messages ^
  --hidden-import=student.apps ^
  --hidden-import=teacher.apps ^
  --hidden-import=quiz.apps ^
  run_quiz_server.py

echo Moving executable...
if exist dist\quiz_server.exe (
    copy /Y dist\quiz_server.exe .
    echo Executable created successfully!
) else (
    echo Failed to create executable.
)
