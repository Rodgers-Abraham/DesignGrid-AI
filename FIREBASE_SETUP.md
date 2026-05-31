# Firebase Project Setup (DesignGrid.AI)

Follow these steps in your Firebase Console to enable cloud-sync for DesignGrid.AI.

### 1. Initialize Firebase
Run the following command in your terminal from the project root:
```bash
flutterfire configure
```
*   Select your Firebase project.
*   Select the platforms (Android, iOS, Web).
*   This will generate `lib/firebase_options.dart`.

### 2. Enable Authentication
*   Go to **Authentication > Sign-in method**.
*   Enable **Email/Password**.

### 3. Setup Firestore Database
*   Go to **Firestore Database**.
*   Click **Create database**.
*   Choose a location and start in **Production mode**.
*   Go to the **Rules** tab and paste the following:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /projects/{project} {
      // Allow user to read/write only their own projects
      allow read, write: if request.auth != null && request.auth.uid == resource.data.user_id;
      // Allow creation if the user_id in the data matches the authenticated user
      allow create: if request.auth != null && request.auth.uid == request.resource.data.user_id;
    }
  }
}
```

### 4. Collection Structure
The app expects a `projects` collection where each document contains:
*   `user_id`: String (matching Auth UID)
*   `title`: String
*   `type`: String
*   `preview_url`: String
*   `layers`: Array of objects (JSON)
*   `created_at`: Timestamp
