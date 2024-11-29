# Test API requests

- [Test API requests](#test-api-requests)
  - [Register](#register)
  - [Login](#login)
  - [Logout](#logout)
  - [Profile update](#profile-update)
  - [Send email](#send-email)

## Register

Endpoint: <http://127.0.0.1:8000/auth/register/>

**POST request:**

```json
{
    "username": "testuser",
    "first_name": "john",
    "last_name": "test",
    "password": "=4Y[%3<Z_0aO",
    "password2": "=4Y[%3<Z_0aO",
    "email": "testuser@example.com",
    "phone_number": "+1234567890"
}
```

**Success response:**

```json
{
    "id": 4,
    "phone_number": "+1234567890",
    "first_name": "john",
    "last_name": "test",
    "email": "testuser@example.com",
    "profile_picture": "/default-avatar.png",
    "is_phone_verified": false
}
```

**Missing fields:**

```json
{
    "phone_number": [
        "This field is required."
    ],
    "first_name": [
        "This field is required."
    ],
    "last_name": [
        "This field is required."
    ],
    "email": [
        "This field is required."
    ],
    "password": [
        "This field is required."
    ],
    "password2": [
        "This field is required."
    ]
}
```

**Already registered:**

```json
{
    "error": "Phone number already registered."
}
```

## Login

[Endpoint: <http://127.0.0.1:8000/auth/login/>]

**POST request:**

```json
{
    "phone_number": "+1234567890",
    "password": "=4Y[%3<Z_0aO"
}
```

**Success response:**

```json
{
    "user": {
        "id": 6,
        "phone_number": "+1234567890",
        "first_name": "john",
        "last_name": "test",
        "email": "testuser@example.com",
        "profile_picture": "/default-avatar.png",
        "is_phone_verified": false
    },
    "session_token": "e2cb40ef-4470-4a91-b98b-18d47a34ce14"
}
```

**Missing fields:**

```json
{
    "phone_number": [
        "This field is required."
    ],
    "password": [
        "This field is required."
    ]
}
```

**Wrong credentials:**

```json
{
    "non_field_errors": [
        "Unable to log in with provided credentials."
    ]
}
```

## Logout

Endpoint: <http://127.0.0.1:8000/auth/logout/>

## Profile update

Endpoint: <http://127.0.0.1:8000/auth/profile/>

Via HTML form

**POST request:**

```json
{
    "id": 5,
    "user": 7,
    "profile_picture": "http://127.0.0.1:8000/profile_pictures/bluetit.jpg",
    "bio": "just a testing user",
    "birthdate": "2024-11-15",
    "two_factor_enabled": false
}
```

## Send email

Endpoint: <http://127.0.0.1:8000/email/send/>

**POST request:**

```json
{
    "recipients": ["testuser_2@example.com"],
    "cc": ["testuser_2@example.com"],
    "bcc": ["testuser_2@example.com"],
    "subject": "Meeting Reminder",
    "body": "Don't forget about the meeting tomorrow at 10 AM.",
    "attachments": [],
    "is_draft": false,
    "labels": []
}
```

**Success response:**

```json
{
    "id": 18,
    "sender": "testuser@example.com",
    "recipients": [
        "testuser_2@example.com"
    ],
    "cc": [
        "testuser_2@example.com"
    ],
    "bcc": [
        "testuser_2@example.com"
    ],
    "subject": "Meeting Reminder",
    "body": "Don't forget about the meeting tomorrow at 10 AM.",
    "attachments": [],
    "sent_at": "2024-11-29T05:10:32.972691Z",
    "is_read": false,
    "is_starred": false,
    "is_draft": false,
    "is_trashed": false,
    "reply_to": null,
    "headers": null,
    "labels": [],
    "is_reply": false
}