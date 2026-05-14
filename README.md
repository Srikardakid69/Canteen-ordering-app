# 🍽️ Canteen Ordering App

## 📌 Project Description
This is a **Flutter-based canteen ordering app** integrated with **Firebase**.  
It allows users to browse food stalls, select items, manage cart, choose pickup time, and view order summary.

---

## 🚀 Features

- 🔐 Login & Sign Up (Firebase Authentication)
- 🏠 Home screen with welcome message
- 🍱 Browse food courts and stalls
- 📋 View menu and add items to cart
- ❤️ Add items to favourites (stored in Firebase)
- 🛒 Cart management (add/remove items, price calculation)
- ⏰ Select pickup date and time
- 💳 Payment option (Cash / PayNow simulation)
- 📄 Order summary with generated order number
- 👤 Profile page (Dark/Light mode + logout)
- 🌙 Dark mode / Light mode toggle

---

## 📱 Screens Overview

### 🔐 Login & Sign Up
- Validates user using Firebase
- Displays error if login fails
- On success → navigates to home screen

### 🏠 Home Screen
- Displays **"Welcome username"**
- Navigation to stalls and profile using bottom navigation bar

### 🍱 Stall Selection
- Filter stalls by **Food Court 1 / Food Court 2**
- Navigate to selected stall menu

### 📋 Menu Page
- View food items
- Add to cart
- Add to favourites (Firebase)
- Proceed to next step

### ⏰ Pickup Time
- Select pickup date & time
- Navigates to cart

### 🛒 Cart Page
- View selected items
- Increase/decrease quantity
- Shows total price
- Choose payment method

### 💳 PayNow Page
- Displays QR code (simulation)
- Button to proceed after payment

### 📄 Order Summary
- Displays:
  - Order number
  - Items
  - Total cost
  - Pickup date & time

### 👤 Profile Page
- Toggle **Dark / Light mode**
- View favourites
- Logout option

### ❤️ Favourites
- Loads favourite items from Firebase

---

## 🛠️ Technologies Used
- Flutter
- Firebase Authentication
- Firebase Firestore

---

## 🎥 Demo Video
[https://youtu.be/DIA7KRfuHsg](https://youtu.be/jYlFrNMwQtA)

---

## 📌 Notes
- PayNow is simulated (no real payment)
- Data such as cart and favourites are stored in Firebase
