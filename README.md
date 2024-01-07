# Queens Class Schedule Database
Database design for all classes offered in Queens College for Fall 24'


## Project Overview
The Queens Class Schedule Database is a comprehensive project for managing class schedules at Queens College. The project involves creating an Entity-Relationship Diagram (ERD) applying normalization and relational database management principles, leveraging SQL for efficient data handling.

## Task
We were presented with the complete dataset of all classes offered at Queens College for Fall 2023, including detailed information about professors, classes, buildings, and more. Our primary task was to design a database and develop an ERD from this data, ensuring the database structure is efficient, normalized, and capable of handling complex queries and data relationships.

## Objectives
- Organize data of all classes offered at Queens College into a structured database.
- Implement normalization principles for data integrity and efficiency.
- Utilize SQL for data manipulation and management.

## Methodology
1. **Data Analysis and Table Identification**: Examining the raw data to identify potential tables for separation based on normalization concepts.
2. **Declare User Defined Data Types**: Implementing user-defined data types to enhance reusability and consistency across the database.
3. **Foreign Key Relationships**: Establishing foreign key relationships from the main data table to all normalized tables for referential integrity and efficient data retrieval.
4. **Stored Procedures**: Utilizing stored procedures in SQL to load the complete dataset efficiently and securely.

## Technologies Used
- **Azure Data Studio**: For developing and managing the database.
- **Docker**: To containerize the database environment for consistency.
- **Erwin**: For designing and visualizing the Entity-Relationship Diagram (ERD).
- **SQL**: As the primary language for database management.
- **Java and JDBC**: Used for running custom queries against the database, providing a robust interface between the Java programming environment and the database.

## File Structure
- `Diagram.PNG` - Contains the ERD visualizing the database schema.
- `JDBC.java` - Java file that includes all JDBC operations to interact with the database.
- `Presentation.pdf` - A presentation file that outlines the project's scope, findings, and conclusions.
- `QCSchedule_Backup.bak` - A backup file of the database, which can be used to restore the database state.
- `Queens Class Schedule - Project Documentation.pdf` - Detailed project documentation including methodology, analysis, and results.
- `README.md` - The file you are currently reading, providing an overview and guide to the project.

## Visual References
- **Raw Data**: [View Raw Data](https://ibb.co/bNWjTsj) - A snapshot of the raw dataset provided for Fall 2023 classes.
- **Database Design**: [View Database Design](https://ibb.co/716WQWF) - An image of the ERD created for the database.
- **JDBC Walkthrough**: [Watch JDBC Walkthrough](https://clipchamp.com/watch/c11LS85jrDX) - A video walkthrough of the JDBC usage for custom queries.

## Course Information
- This project was developed as part of the CSCI 331 - Database Management course, under the guidance of Prof. Peter Heller.
  Contributors:
  Mohammed Hasan: [Mohammed Github Link](https://github.com/Mzohairhasan)
---
