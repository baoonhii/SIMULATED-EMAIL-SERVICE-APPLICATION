# GotMail: A SIMULATED EMAIL SERVICE APPLICATION

## Get started

## Requirement checklists

### Front-end

1. Account Management
   1. [ ] Registration: Users register using their phone number (not email).
      1. [ ] Back-end
      2. [ ] Front-end
      3. [ ] Phone validation
   2. [x] Login: Secure login functionality.
      1. [x] After successful login, the app must save data to mark that the user has logged in, so in subsequent app openings, users can use the app immediately without needing to log in again (unless the session has expired).
         1. [x] Front-end
         2. [x] Back-end
   3. [x] Logout
   4. [ ] Password Management: Allow password changes and recovery.
   5. [ ] Two-step Verification: Option for users to enable/disable.
   6. [x] Profile Management: View and update personal information, including profile pictures.
      1. [ ] Change password
      2. [ ] Password recovery
      3. [ ] Enable and use 2 steps verification
      4. [x] View profile info and picture
      5. [x] Change profile info
      6. [x] Change profile image
         1. [x] The new avatar will be updated automatically as soon as it is changed
         2. [ ] Other users will see this update too.
2. Compose and Send Email
   1. [x] Basic Fields: Compose emails with fields like 'To', 'Subject', and 'Body'. Support for sending attachments.
      1. [x] Back-end
      2. [x] Front-end
   2. [x] Advanced Editor: Include fields like 'CC', 'BCC' and integrate a WYSIWYG (What You See Is What You Get) editor for formatting.
   3. [ ] Reply and Forward: Reply to or forward emails to other users.
   4. [ ] Drafts: Autosave unsent emails as drafts.
   5. [ ] Email Actions: View metadata, assign labels, star, mark as read/unread, move to trash.
      1. [x] Send simple text email
      2. [ ] Auto save as draft
      3. [ ] Answer an email
      4. [ ] Forward an email
      5. [x] Send email in CC and BCC
      6. [x] Advanced text editing with WYSIWYG
      7. [x] Sending and receiving attachments
         1. [ ] Both sender and recipient can view files directly inside the app (for some popular formats)
      8. [ ] Perform actions on an email (view meta-data, move to trash, mark read, assign labels)
      9. [ ] Starred an email
3. View Emails
   1. [ ] Organize Emails: Default folders like 'Inbox', 'Starred', 'Sent', 'Draft', and 'Trash'. Users can manage their labels but cannot alter these folders.
   2. [ ] Display Modes for email list: Support both basic (minimal details like sender and subject) and detailed views (includes previews, attachments, etc.).
      1. [ ] View emails in different categories
         1. [x] inbox
         2. [x] sent
         3. [ ] draft
         4. [ ] starred
         5. [ ] trashed
      2. [x] View email list in basic view
      3. [ ] View email list in detail view
4. Search Functionality
   1. [ ] Basic Search: Simple keyword-based search.
   2. [ ] Advanced Search: Utilize an advanced search interface with various filters (e.g., date range, attachments).
      1. [ ] Search email by keywords
      2. [ ] Advanced searching
5. Label Management
   1. [ ] Manage Labels: List, add, remove, and rename labels.
   2. [ ] Label Assignment: Add or remove labels from emails.
   3. [ ] Filter by Label: Display emails based on selected labels.
      1. [ ] Add/remove a label to an email
      2. [ ] View email list by label type
6. Notifications for new Emails
   1. [ ] When the app is running, users should receive a notification or badge update in the app when they receive a new email.
   2. [ ] The notification should show the sender, subject, and time received.
   3. [ ] Realtime update: automatically display new emails in the inbox without requiring the user to refresh the page or reopen the screen.
      1. [ ] Display notification
      2. [ ] Realtime update inbox list
7. Auto answer mode
   1. [ ] Auto Answer Mode allows users to automatically reply to all incoming emails with a predefined response. When enabled in the settings screen, any email received will trigger an automatic reply with the specified message, ensuring that the sender receives an immediate acknowledgment.
   2. [x] Users can customize the response content and toggle this feature on or off based on their preferences.
8. Settings and user preferences
   1. [ ] Users should be able to update basic preferences such as notification settings (e.g., turn off notifications).
   2. [x] Users can also select a default font size, font family for the email text editor.
   3. [x] Implement Dark Mode support, and allow users to switch between Light and Dark themes.
   4. [x] Turn on/off auto answer mode.

### Back-end

1. Deployment
   1. [ ] Web Platform: Deploy the application to any hosting service (e.g., Firebase, AWS, Netlify) and provide a public URL for access.
   2. [ ] Mobile Platform (Android): Package the application as an APK file optimized for ARM64 architecture and ensure it runs smoothly
on Android devices.
1. AI/Machine learning Integration
   1. [ ] Automatically label emails as spam
   2. [ ] Language detection and translation
   3. [ ] Suggest short answers
   4. [ ] Any other useful AI-powered features
