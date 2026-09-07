🎬 Sinema Movies



Sinema Movies is a cinema booking web application developed using Java, Jakarta EE, JSP, Maven, Payara Micro, and MariaDB/MySQL.

The system provides two main interfaces:

Customer side — browse movies, select showtimes, choose seats, add snacks, and complete bookings.

Admin side — manage movies and showtimes, monitor bookings, and view sales reports.

This project was originally developed as a university group project for CSC584 and was later cleaned, reorganized, migrated to Java 21, and prepared for GitHub.

✨ Features

👤 Customer

User registration and login

Browse Now Showing and Coming Soon movies

View movie information and available showtimes

Interactive cinema seat selection

Booked/unavailable seat indicators

Select food and drinks

Support multiple quantities of the same snack

Order summary with ticket and snack totals

Booking receipt after checkout

🛠️ Admin

Separate admin authentication

Admin dashboard

Manage movie listings

Add, update, and delete movies

Manage movie showtimes

View customer bookings

Search and filter booking records

Sales report

Ticket, snack, and revenue summaries

Transaction history

🖼️ Screenshots

Customer Movie Dashboard



Seat Selection



Food & Drinks



Checkout & Payment



Admin — Manage Movies



Admin — Manage Showtimes



Admin — Booking Details



Admin — Sales Report



🧰 Tech Stack

Technology

Usage

Java 21

Backend application logic

Jakarta EE 10

Web application APIs

JSP

Server-side UI

HTML / CSS / JavaScript

Frontend

Bootstrap

UI components

Maven

Dependency and build management

Payara Micro

Jakarta EE application server

MariaDB / MySQL

Relational database

JDBC

Database connectivity

XAMPP

Local MariaDB/MySQL environment

📁 Project Structure

Sinema-Movies/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/mycompany/sinema/
│       │       ├── controller/
│       │       ├── DAO/
│       │       ├── filter/
│       │       ├── model/
│       │       └── util/
│       ├── resources/
│       │   └── META-INF/
│       └── webapp/
│           ├── admin/
│           ├── images/
│           ├── user/
│           └── WEB-INF/
├── database/
│   └── sinema.sql
├── screenshots/
│   ├── logo.png
│   ├── dashboard.png
│   ├── seats.png
│   ├── snacks.png
│   ├── payment.png
│   ├── manage.png
│   ├── showtime.png
│   ├── bookings.png
│   └── report.png
├── pom.xml
└── README.md

🚀 Running the Project

Requirements

JDK 21

Maven

XAMPP or another MariaDB/MySQL server

Check your Java and Maven versions:

java -version
mvn -version

1. Clone the repository

git clone https://github.com/haikaldy/Sinema-Movies.git
cd Sinema-Movies

2. Start MariaDB / MySQL

Start MySQL from XAMPP.

Default local configuration:

Host: localhost
Port: 3306
Database: sinema
Username: root
Password: (blank)

If your local database configuration is different, update the connection settings in the project.

3. Import the database

Using phpMyAdmin, import:

database/sinema.sql

The SQL file contains the required schema and demo data.

4. Build the project

mvn package

This creates:

target/sinema-1.0-SNAPSHOT.war

5. Start Payara Micro

mvn payara-micro:start

Or:

mvn package payara-micro:start

Then open:

http://localhost:8080/sinema/

🔑 Demo Accounts

Customer

Email: faris@sinema.test
Password: user123

Admin

Email: admin@sinema.test
Password: admin123

Demo credentials are intended for local testing only.

🗄️ Database

The application includes tables for:

Users

Admins

Movies

Showtimes

Seats

Snacks

Bookings

Booking-seat relationships

The demo database contains sample movies, showtimes, users, bookings, and seat availability so the application can be tested immediately.

🔄 Booking Flow

Login
  ↓
Browse Movies
  ↓
Choose Showtime
  ↓
Select Seats
  ↓
Select Food & Drinks
  ↓
Checkout
  ↓
Receipt

📌 Notes

Originally developed using an older Java setup and later migrated to Java 21.

Source code was reorganized into controller, DAO, model, filter, and util packages.

Uses Payara Micro so a separate full application-server installation is not required.

The included database is for demonstration and development purposes.
