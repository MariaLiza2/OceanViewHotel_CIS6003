**Ocean View Hotel Management System 
**
A comprehensive Web-Based Management System designed to digitize hospitality operations for Ocean View Hotel (Galle). This project transition manual workflows into an automated, data-driven environment.

**Core Features**

1. Reservation System :Seamless booking interface for guests and staff to capture stay details.
2. Manage Reservation (CRUD): Full administrative control to Create, Read, Update, and Delete reservation records.
3. Room Availability & Management (CRUD): Dynamic tracking of room statuses with automated sequential numbering (101-210) and management capabilities. Room details managed only by the admin.
4. Billing & Payment: Integrated module to process guest transactions, track payment history, and update 'PAID/PENDING' statuses.
5. Advanced Search & Filters: Optimized lookup functionality for both Reservation records, and Payment history.
6. Report Generation: Admin-specific tools to generate operational summaries for business insights.
7. Guest Directory: A centralized database of guest identities, contact information, and stay history.
8. MVC Architecture: Robust system design using the Model-View-Controller pattern to ensure separation of concerns and scalability.

**Tech Stack**
Backend: Java (Servlets & JSP)
Database:Microsoft SQL Server 2014 (SSMS)
API:Java Database Connectivity (JDBC)
Frontend: Bootstrap 5, HTML, CSS3
Server: Apache Tomcat 9.0

** Project Structure**
`src/com.oceanview.controller`: Servlet logic for routing.
`src/com.oceanview.dao`: Data Access Objects for SQL interactions.
`src/com.oceanview.model`: Java objects (User, Reservation, Payment, Guest).
`WebContent/`: JSP files for the User Interface.
**
The latest version released is v2.6.0 as at 3rd March 2026**
