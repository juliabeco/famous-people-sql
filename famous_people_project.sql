/* FAMOUS PEOPLE PROJECT
Create tables about famous people and what they do here */
CREATE DATABASE IF NOT EXISTS famous_db;
USE famous_db;

/* Drop tables if they already exist (to rerun without error) */
DROP TABLE IF EXISTS books, songs, movies, famous;

/* CREATE FAMOUS TABLE */
CREATE TABLE famous (
    id INT PRIMARY KEY AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    country VARCHAR(100),
    birthyear YEAR
);

/* INSERT VALUES INTO FAMOUS TABLE */
INSERT INTO famous (name, country, birthyear) VALUES 
('JENNY','USA', 1999),
('TOM','USA', 1995),
('LADY GAGA','USA', 1995),
('MARGOT ROBBIE', 'AUSTRALIA', 1988),
('TAYLOR SWIFT', 'USA', 1989),
('ROBBIE WILLIAMS', 'UK', 1976),
('LANA DEL REY', 'USA', 1985),
('RUPI KAUR', 'CANADA', 1998);

/* CREATE MOVIES TABLE */
CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_famous INT NOT NULL,
    title VARCHAR(255),
    FOREIGN KEY (id_famous) REFERENCES famous(id)
);

/* INSERT INTO MOVIES */
INSERT INTO movies (id_famous, title) VALUES 
(4, 'BARBIE'),
(4, 'THE JOKER'),
(3, 'A STAR IS BORN'),
(1, 'FORREST GUMP'),
(2, 'FORREST GUMP'),
(6, 'RW: THE DOCUMENTARY');

/* CREATE SONGS TABLE */
CREATE TABLE songs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_famous INT NOT NULL,
    song VARCHAR(255),
    FOREIGN KEY (id_famous) REFERENCES famous(id)
);

/* INSERT INTO SONGS */
INSERT INTO songs (id_famous, song) VALUES 
(6, 'SHE IS THE ONE'),
(5, 'WILDEST DREAMS'),
(5, 'SHAKE IT OFF'),
(7, 'SUMMERTIME SADNESS'),
(7, 'THE CHEMTRAILS OVER THE COUNTRY CLUB'),
(3, 'ROMANCE');

/* CREATE BOOKS TABLE */
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_famous INT NOT NULL,
    title TEXT,
    FOREIGN KEY (id_famous) REFERENCES famous(id)
);

/* INSERT INTO BOOKS */
INSERT INTO books (id_famous, title) VALUES 
(7,'Violets Bend Backward Over the Grass'),
(8,'Ways to Use Your Mouth');

/* SELECT ALL */
SELECT * FROM famous;
SELECT * FROM movies;
SELECT * FROM songs;
SELECT * FROM books;

/* WILDCARD & LIKE EXAMPLES */
SELECT * FROM famous WHERE name LIKE '%bb%';
SELECT * FROM famous WHERE name LIKE '%ur';
SELECT * FROM famous WHERE name LIKE '_om';
SELECT * FROM famous WHERE name LIKE 'J%';
SELECT * FROM famous WHERE name RLIKE '^[JKLM]';

/* UPDATE BOOKS */
UPDATE books
SET title = 'Violets Bend Backward Over the Grass'
WHERE id_famous = 7;

UPDATE books
SET title = 'Otras formas de usar la boca'
WHERE id_famous = 8;

/* INSERT & DELETE TEST ARTIST */
INSERT INTO famous (name, country, birthyear) VALUES ('WENDY', 'PERU', 2001);
DELETE FROM famous WHERE name = 'WENDY';

/* ADD AND REMOVE TEMPORARY COLUMN */
ALTER TABLE songs ADD length_sec INT;
UPDATE songs SET length_sec = 218 WHERE id = 1;
ALTER TABLE songs DROP COLUMN length_sec;

/* JOINS */
-- Movies by artists
SELECT f.name, f.country, m.title AS movie_title
FROM famous f
JOIN movies m ON f.id = m.id_famous;

-- Songs by artists
SELECT f.name, f.birthyear, s.song
FROM famous f
JOIN songs s ON f.id = s.id_famous;

-- Left join books
SELECT f.name, f.country, f.birthyear, b.title AS book_title
FROM famous f
LEFT JOIN books b ON f.id = b.id_famous;

-- Songs + Books only
SELECT f.name, f.country, s.song, b.title
FROM famous f
JOIN songs s ON f.id = s.id_famous
JOIN books b ON f.id = b.id_famous;

-- Aggregated: songs & books in one row
SELECT f.name, f.country,
    (SELECT GROUP_CONCAT(DISTINCT s.song) FROM songs s WHERE s.id_famous = f.id) AS songs,
    (SELECT GROUP_CONCAT(DISTINCT b.title) FROM books b WHERE b.id_famous = f.id) AS book_titles
FROM famous f
HAVING (songs IS NOT NULL AND LOCATE(',', songs) > 0)
    OR (book_titles IS NOT NULL AND LOCATE(',', book_titles) > 0);

-- Get all books by a famous person
SELECT f.name, b.title
FROM books b
JOIN famous f ON b.id_famous = f.id
WHERE f.name = 'Rupi Kaur';

-- Count how many songs each artist has (Show only artists with songs)
SELECT f.name, COUNT(s.id) AS song_count
FROM famous f
LEFT JOIN songs s ON f.id = s.id_famous
GROUP BY f.id
HAVING song_count > 0;

-- List movies by country of main character
SELECT m.title AS movie, f.country 
FROM movies m
JOIN famous f ON m.id_famous = f.id
ORDER BY f.country;

/* NO ARTIST HAS ALL 3: MOVIE, SONG & BOOK */
SELECT f.name, f.country, m.title, s.song, b.title
FROM famous f
JOIN movies m ON f.id = m.id_famous
JOIN songs s ON f.id = s.id_famous
JOIN books b ON f.id = b.id_famous;

/* LEFT JOIN ALL ARTISTS AND THEIR WORKS */
SELECT f.name, f.country, b.title AS book, s.song, m.title AS movie
FROM famous f
LEFT JOIN movies m ON f.id = m.id_famous
LEFT JOIN songs s ON f.id = s.id_famous
LEFT JOIN books b ON f.id = b.id_famous;

-- Get all media created by each famous person, listing titles when needed 
-- (Same query as before but using GROUP_CONCAT)
SELECT f.name,
       GROUP_CONCAT(DISTINCT b.title) AS books,
       GROUP_CONCAT(DISTINCT s.song) AS songs,
       GROUP_CONCAT(DISTINCT m.title) AS movies
FROM famous f
LEFT JOIN books b ON f.id = b.id_famous
LEFT JOIN songs s ON f.id = s.id_famous
LEFT JOIN movies m ON f.id = m.id_famous
GROUP BY f.name;

/* BONUS: CREATE VIEWS FOR EASY ACCESS */
CREATE VIEW artist_summary AS
SELECT f.name, f.country,
    (SELECT GROUP_CONCAT(DISTINCT m.title) FROM movies m WHERE m.id_famous = f.id) AS movies,
    (SELECT GROUP_CONCAT(DISTINCT s.song) FROM songs s WHERE s.id_famous = f.id) AS songs,
    (SELECT GROUP_CONCAT(DISTINCT b.title) FROM books b WHERE b.id_famous = f.id) AS books
FROM famous f;

-- Query the view
SELECT * FROM artist_summary;
