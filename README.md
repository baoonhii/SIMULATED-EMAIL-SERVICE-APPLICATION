# GotMail: A SIMULATED EMAIL SERVICE APPLICATION

## Deployment

Deployed Backend repo: <https://github.com/phamlequocdatCS/simulated-email-backend>

Deployed Frontend repo: <https://github.com/phamlequocdatCS/flutter-email-frontend>

GitHub pages deployment: <https://github.com/phamlequocdatCS/flutter-email-app>

App link: <https://phamlequocdatcs.github.io/flutter-email-app/>

## Get started

This repository is intended for fully local hosting. For cloud deployment, see the links above. We assume that you're using Windows, but it should be easier on Linux.

### Set up the backend

1. Setup PostgreSQL
   - Use latest (PostgreSQL 17): <https://www.postgresql.org/download/windows/>
2. Install redis for Windows: <https://github.com/tporadowski/redis/releases>
3. Setup Django and requirements
   - Install Python (3.10) (with Conda, optional)
   - Create virtual environment in `backend` folder: `python -m venv venv`
   - Activate environment: `venv\Scripts\activate`
   - Install dependencies: `pip install -r GotMail\requirements_windows.txt`
   - Create PostgreSQL server in pgAdmin:
     - Add new server -> right-click on postgres -> Create database
  
      ```txt
      Name: gotmailDB
      Hostname: localhost
      Port: 5432
      Username: postgres
      Password: 
      Save password? [Check - on]

      Database name: gotmailDB
      ```

   - Setup Database in Django: Update super_secrets.py

      ```python
      DB_PASSWORD = ""
      DJANGO_SECRET_KEY = "X"
      TWILIO_ACCOUNT_SID = 'X'
      TWILIO_AUTH_TOKEN = 'X'
      TWILIO_PHONE_NUMBER = 'X'
      TWILIO_VERIFY_SERVICE_SID = "X"
      gmail_app_password = "X"
      gmail_app_email = 'X'
      ```

   - Run migrations

      ```cmd
        python GotMail\manage.py migrate
      ```

   - Collect static files: `python GotMail\manage.py collectstatic`
   - Run the project: `python GotMail\manage.py runserver 0.0.0.0:8000`
   - Create superuser: `python GotMail\manage.py createsuperuser`
4. Load the sample data: `python GotMail\manage.py loaddata --exclude auth.permission --exclude contenttypes GotMail\dumped_data.json`
5. Start the redis server for real-time notification: `redis-server --port 6380`

## Usage

Pre-loaded accounts in [stock_accounts.md](stock_accounts.md)

## Building

For Web:

```cmd
flutter build web --release
```

The output is in `\build\web`

To run locally:

```cmd
venv\Scripts\activate
cd ..\build\web

python -m http.server 9000
```

The web app will be hosted at `http://localhost:9000/`

For Android

```cmd

flutter build apk --release
```

The output is in `\build\app\outputs\apk\release`
