# Advanced Online Quiz System

A comprehensive online quiz platform with an AI-powered chatbot assistant, built using Django and modern web technologies.

## Features

### Core Quiz Features
- Multi-user support (Students, Teachers, Administrators)
- Dynamic quiz creation and management
- Real-time quiz taking with timer
- Automatic grading and result analysis
- Course management system
- Performance tracking and statistics

### AI Chatbot Assistant
- Intelligent query handling for quiz-related questions
- Personalized responses based on user role
- Real-time statistics and progress tracking
- Course-specific information
- Technical support and guidance
- Interactive suggestions
- Context-aware responses

### User Management
- Role-based access control
- Student progress tracking
- Teacher dashboard
- Admin control panel
- Secure authentication

### Technical Features
- Modern responsive UI
- Real-time updates
- Mobile-friendly design
- Cross-browser compatibility
- Secure data handling

## Technology Stack

### Backend
- Python 3.7+
- Django 3.2+
- SQLite Database
- Redis for real-time features

### Frontend
- HTML5, CSS3, JavaScript
- Bootstrap for responsive design
- Font Awesome icons
- Custom animations and effects

### Additional Tools
- Django REST framework
- WebSocket support
- Advanced caching system

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/onlinequiz.git
cd onlinequiz
```

2. Create and activate virtual environment:
```bash
python -m venv env
source env/bin/activate  # On Windows: env\Scripts\activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Set up the database:
```bash
python manage.py migrate
```

5. Create admin user:
```bash
python manage.py createsuperuser
```

6. Run the development server:
```bash
python manage.py runserver
```

7. Access the application:
- Main site: http://127.0.0.1:8000
- Admin panel: http://127.0.0.1:8000/admin

## User Roles

### Admin
- Manage all users and content
- Create/modify courses
- Monitor system performance
- Access analytics

### Teacher
- Create and manage quizzes
- Add/edit questions
- View student performance
- Grade submissions
- Generate reports

### Student
- Take quizzes
- View results
- Track progress
- Access study materials
- Get AI chatbot assistance

## AI Chatbot Usage

The AI chatbot provides assistance for:
- Quiz rules and guidelines
- Course information
- Technical support
- Study tips
- Progress tracking
- Schedule management
- Performance statistics

To use the chatbot:
1. Click the chat icon on the right side of any page
2. Type your question or select a suggestion
3. Get instant, context-aware responses
4. Use quick suggestions for common queries

## Security Features

- Secure authentication system
- CSRF protection
- XSS prevention
- Secure session handling
- Input validation
- Role-based access control

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email: support@onlinequiz.com

## Acknowledgments

- Django community
- Bootstrap team
- Font Awesome
- All contributors
