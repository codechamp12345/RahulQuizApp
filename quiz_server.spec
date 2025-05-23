# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['run_quiz_server.py'],
    pathex=[],
    binaries=[],
    datas=[('templates', 'templates'), ('static', 'static'), ('manage.py', '.'), ('onlinequiz', 'onlinequiz'), ('db.sqlite3', '.'), ('student', 'student'), ('teacher', 'teacher'), ('quiz', 'quiz')],
    hiddenimports=['django', 'django.template.defaulttags', 'django.template.loader_tags', 'django.contrib.messages.storage.fallback', 'django.contrib.staticfiles', 'django.contrib.admin', 'django.contrib.auth', 'django.contrib.contenttypes', 'django.contrib.sessions', 'django.contrib.messages', 'student.apps', 'teacher.apps', 'quiz.apps'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='quiz_server',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
