# BrainCloud Dart App Example

This repository contains a Dart application that demonstrates how to integrate and use the `braincloud` package for communication with a BrainCloud backend. The app supports command-line arguments for configuration and allows user authentication and interaction with BrainCloud services.

## Features

- Initializes a BrainCloud client.
- Fetches and prints the BrainCloud server version.
- Supports user authentication using email and password.
- Displays user statistics upon successful login.

---

## Requirements

1. [Dart SDK](https://dart.dev/get-dart) (>=2.19.0)
2. [braincloud](https://pub.dev/packages/braincloud) package (installed via `pub get`).

---

## Installation

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd example


## Usage

### Running the App

You can execute the app using the Dart CLI:
```bash
dart run example.dart [arguments]
```

### Command-Line Arguments
Argument Description
```
--appid 	    Your BrainCloud application ID.
--appsecret 	Your BrainCloud application secret key.
--user 	        The user’s email address for authentication.
--password 	    The user’s password for authentication.
--force 	    (Optional) Force the creation of the user account if it doesn’t exist.
```
Any other arguments are added to the other list for custom processing.


### Example Commands
1.	Initialize and fetch server version only:

```bash
dart run example.dart --appid <APP_ID> --appsecret <APP_SECRET>
```

2.	Authenticate a user and fetch statistics:
```bash
dart run example.dart --appid <APP_ID> --appsecret <APP_SECRET> --user <USER_EMAIL> --password <PASSWORD>
```


Notes
	1.	Make sure your BrainCloud app is set up with the provided appId and appSecret.
	2.	If using --force, ensure this aligns with your intended user creation policy.
	3.	Keep your appSecret secure and avoid sharing it in public repositories.