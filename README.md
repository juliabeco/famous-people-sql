# 🎬 Famous People Database

This project uses SQL to build and query a small relational database containing information about famous people, their books, songs, and movies. It includes data normalization, foreign keys, inner joins, aggregate functions, and views.

## 🗃️ Tables

- **famous**: general information about each famous person.
- **books**: books written by famous people.
- **songs**: songs performed by famous people.
- **movies**: movies in which famous people have appeared.

## 🛠️ Technologies

- SQL
- Relational database design
- Data normalization
- Foreign key constraints
- Views

## 📊 Sample Queries

### 1. Get all books by a famous person
```sql
SELECT f.name, b.title
FROM books b
JOIN famous f ON b.id_famous = f.id
WHERE f.name = 'Rupi Kaur';
```

### 2. Count how many songs each artist has (Show only artists with songs)
```sql
SELECT f.name, COUNT(s.id) AS song_count
FROM famous f
LEFT JOIN songs s ON f.id = s.id_famous
GROUP BY f.id
HAVING song_count > 0;
```

### 3. List movies by country of main character
```sql
SELECT m.title AS movie, f.country 
FROM movies m
JOIN famous f ON m.id_famous = f.id
ORDER BY f.country;
```

### 4. Get all media created by each famous person
```sql
SELECT f.name,
       GROUP_CONCAT(DISTINCT b.title) AS books,
       GROUP_CONCAT(DISTINCT s.title) AS songs,
       GROUP_CONCAT(DISTINCT m.title) AS movies
FROM famous f
LEFT JOIN books b ON f.id = b.id_famous
LEFT JOIN songs s ON f.id = s.id_famous
LEFT JOIN movies m ON f.id = m.id_famous
GROUP BY f.name;
```

## 👁️ View: `artist_summary`

To simplify repeated queries, we created a SQL view:

```sql
CREATE VIEW artist_summary AS
SELECT f.name, f.country,
       (SELECT GROUP_CONCAT(DISTINCT m.title) FROM movies m WHERE m.id_famous = f.id) AS movies,
       (SELECT GROUP_CONCAT(DISTINCT s.title) FROM songs s WHERE s.id_famous = f.id) AS songs,
       (SELECT GROUP_CONCAT(DISTINCT b.title) FROM books b WHERE b.id_famous = f.id) AS books
FROM famous f;
```

You can use it like this:

```sql
SELECT * FROM artist_summary WHERE country = 'USA';
```

## 📌 Notes

- NULL values were removed where unnecessary.
- Foreign key constraints were added to preserve data integrity.
- GROUP_CONCAT is used to summarize related data in a single row.
- The database is simplified for educational and practice purposes.

## 📂 File Structure

```
├── famous_people.sql     # Main SQL script
└── README.md             # Project description and documentation
```

## 📥 How to Use

1. Clone the repo (or copy and paste the contents of `famous_people.sql`).
2. Load the `famous_people.sql` into your MySQL Workbench or DBMS of choice.
3. Run queries and explore the data.

## 📧 Contact

Created by **Julia Becaria Coquet** – feel free to reach out for feedback, ideas, or collaborations.
