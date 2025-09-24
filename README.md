Notes App — Flutter + Node.js + MySQL

A simple Notes app with Flutter frontend and Node.js + Express backend using MySQL.

Project Structure
- frontend/   Flutter app
- backend/    Node.js + Express API
- db.sql      MySQL schema for `notes` table

Requirements
- Node.js 16+
- MySQL 8+
- Flutter SDK 3.3+
- (Windows desktop build only) Visual Studio with “Desktop development with C++”

Backend — Setup and Run
1) Create .env in `backend/`
   - Windows PowerShell (replace password):
```
cd backend
@"
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=YOUR_MYSQL_PASSWORD
DB_NAME=notesdb
PORT=3000
"@ | Set-Content -Encoding ASCII .env
```

2) Create database and table
```
mysql -u root -p < db.sql
```

3) Install deps and start API
```
npm install
npm start
```
Server runs at `http://localhost:3000`. Test: open `http://localhost:3000/notes` → should show `[]`.

Frontend — Setup and Run
1) Ensure Flutter on PATH (new PowerShell):
```
flutter --version
```

2) Install packages
```
cd frontend
flutter pub get
```

3) Point app to backend
Edit `lib/services/api_service.dart` and set:
```
static const String baseUrl = 'http://localhost:3000';
```

4a) Run in Chrome (no extra tools)
```
flutter config --enable-web
flutter run -d chrome
```

4b) Run as Windows desktop app
```
flutter config --enable-windows-desktop
flutter create . --platforms=windows
flutter run -d windows
```

Features Implemented
- Add, list, edit, delete notes
- Mark as completed (UI line-through)
- Data persisted in MySQL via REST API
- Client-side search/filter (title/description)
- Simple reminder timer (SnackBar notification)

API Endpoints (Express)
- POST `/notes` → create note `{ title, description }`
- GET `/notes` → list notes
- PUT `/notes/:id` → update `{ title, description, completed }`
- DELETE `/notes/:id` → delete by id

Troubleshooting
- `flutter not recognized` → add Flutter `bin` to PATH, reopen shell.
- Windows desktop error about Visual Studio → install VS “Desktop development with C++”.
- Can’t run `mysql` → use full path to `mysql.exe` or run `db.sql` in MySQL Workbench.
- Frontend can’t load notes → ensure backend running on port 3000 and `baseUrl` matches.

One-click shortcuts (optional)
- Create `run-backend.cmd` in `backend/` with:
```
npm start
```
- Create `run-frontend.cmd` in `frontend/` with:
```
flutter run -d chrome
```