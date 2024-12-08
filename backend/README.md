# GotMail

Cross-platform Email App and Service

Stack:

- Backend: Django
- Database: PostgreSQL
- Real-time Notification: Django Channels
- Front-end: Flutter
- Supporting platforms: Android, Web

## Getting Started

1. Setup PostgreSQL
   - Use latest (PostgreSQL 17): <https://www.postgresql.org/download/windows/>
2. Install redis for Windows: <https://github.com/tporadowski/redis/releases>
3. Setup Django and requirements
   - Install Python (3.10)
   - Create virtual environment: `python -m venv venv`
   - Activate environment: `venv\Scripts\activate`
   - Install dependencies: `pip install -r requirements.txt`
   - Start the project: `django-admin startproject GotMail`
   - Create PostgreSQL server: Add new server -> right-click on postgres -> Create database

      ```txt
      Name: gotmailDB
      Hostname: localhost
      Port: 5432
      Username: postgres
      Password: 
      Save password? [Check - on]

      Database name: gotmailDB
      ```

   - Start the Django project

      ```cmd
      cd GotMail
      python manage.py startapp gotmail_service
      ```

   - Setup Database in Django: Update super_secrets.py with the database password
   - Run migrations

      ```cmd
        python manage.py makemigrations
        python manage.py migrate
      ```

4. Load the sample data: `python GotMail\manage.py loaddata < dumped_data.json`
5. Start the redis server for notif: `redis-server.exe --port 6380`


## Usage

Pre-loaded accounts in [stock_accounts.md](stock_accounts.md)
