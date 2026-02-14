-- when you create any row in sql as unique then SQL create that colum as index.
Create DATABASE chat_app;
USE chat_app;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- and i have to perfrom this operation on the users table:
SELECT * FROM users WHERE username = 'john_doe';
-- To optimize the performance of the query that retrieves user information based on the username, 
-- you can create an index on the username column:

CREATE INDEX idx_username ON users(username);
-- This index will allow the database to quickly locate the relevant rows when executing the SELECT query, 
-- improving the performance of the query that retrieves user information based on the username.