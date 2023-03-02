# SQL CRUD Assignment

## Restaurant Tables

This code creates a table for restaurants with columns for id, category, price_tier, neighborhood, opening_hours, avg_rating, and good_for_kids:

    CREATE TABLE restaurants 
        (id INTEGER PRIMARY KEY, 
        category TEXT NOT NULL, 
        price_tier TEXT NOT NULL, 
        neighborhood TEXT NOT NULL, 
        opening_hours TEXT NOT NULL, 
        avg_rating INTEGER NOT NULL, 
        good_for_kids BOOLEAN NOT NULL);

This code creates a table for reviews with columns for review_id, restaurant_id, rating, and review: 

    CREATE TABLE reviews 
        (review_id INTEGER PRIMARY KEY, 
        id INTEGER NOT NULL,
        rating INTEGER NOT NULL,
        review TEXT NOT NULL,
        FOREIGN KEY (id) REFERENCES restaurants(id));

## Social Media Tables

This code creates a table for users with columns for username, email, and password.
    CREATE TABLE users 
        (username TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        password TEXT NOT NULL);

This code creates a table for posts with columns for post_id, post_type, sender, recipient, content, post_time, and is_visible.
    CREATE TABLE posts 
        (post_id INTEGER PRIMARY KEY,
        post_type TEXT NOT NULL,
        sender TEXT NOT NULL,
        recipient TEXT NOT NULL,
        content TEXT NOT NULL,
        post_time TEXT NOT NULL,
        is_visible BOOLEAN NOT NULL,
        FOREIGN KEY (sender) REFERENCES users(username),
        FOREIGN KEY (recipient) REFERENCES users(username));

## Data Files Used for This Assignment

For the restaurant portion of the assignment, I generated [this table](https://github.com/dbdesign-assignments-spring2023/sql-crud-aa8690/blob/main/data/restaurants.tsv). I generated it as a tsv file instead of a csv because I was having issues importing the data as a csv, but found that I did not run into similar problems as a tsv. The table contains data for 1,000 restaurants.

For the social media portion of the assignment, I generated [a table for users](https://github.com/dbdesign-assignments-spring2023/sql-crud-aa8690/blob/main/data/users.csv) that contains 1,000 users with unique usernames, emails, and passwords. I used the usernames of the first 100 users in users.csv to create data in [a table for posts](https://github.com/dbdesign-assignments-spring2023/sql-crud-aa8690/blob/main/data/posts.csv). This table contains 2,000 posts of messages and stories. The timeframe for the posts' dates range from 3-1-2022 to 3-1-2023, so a wide range of my data was already not visible.

## SQLite Code to import the practice CSV data files into the tables

To import data into the table for restaurants, I used the following code:

    .sqlite3 restaurants.db
    .mode tabs
    .headers on
    .import data/restaurants.tsv restaurants

To import data into the table for users, I used the following code:
    
    .sqlite3 social_media.db
    .mode csv
    .headers on
    .import data/users.csv users

To import data into the table for posts, I used the following code:

    .mode csv
    .headers on
    .import data/posts.csv posts

## SQL Queries for Restaurant Exercise

Here are the SQL Queries for the Restaurant Exercise of this assignment. They can also be found in [restaurants.sql](https://github.com/dbdesign-assignments-spring2023/sql-crud-aa8690/blob/main/restaurants.sql).

#### 1. Find all cheap restaurants in a particular neighborhood (pick any neighborhood as an example).
    SELECT restaurants.id, restaurants.price_tier, restaurants.neighborhood from restaurants 
    WHERE restaurants.price_tier = "Cheap" AND restaurants.neighborhood = "Chinatown";

#### 2. Find all restaurants in a particular genre (pick any genre as an example) with 3 stars or more, ordered by the number of stars in descending order.

    SELECT restaurants.id, restaurants.category, restaurants.avg_rating from restaurants
    WHERE restaurants.category = "Pizza" AND restaurants.avg_rating >= 3
    ORDER BY restaurants.avg_rating DESC;

#### 3. Find all restaurants that are open now (see hint below).
    SELECT * FROM restaurants
    WHERE strftime('%H:%M', 'now') BETWEEN 
    substr(opening_hours, 1, instr(opening_hours, ' ') - 1) -- extract the opening time before the space character
    AND substr(opening_hours, instr(opening_hours, '-') + 2); -- extract the closing time after the '-' character

#### 4. Leave a review for a restaurant (pick any restaurant as an example).
    INSERT INTO reviews (review_id, id, rating, review)
    VALUES (1, 1, 4, "Decent");

#### 5. Delete all restaurants that are not good for kids.
    DELETE FROM restaurants 
    WHERE restaurants.good_for_kids = "FALSE";

#### 6. Find the number of restaurants in each NYC neighborhood.
    SELECT neighborhood, COUNT(*) as 'Number of Restaurants'
    FROM restaurants
    GROUP BY neighborhood;

## SQL Queries for Social Media Exercise

Here are the SQL Queries for the Social Media Exercise of this assignment. They can also be found in [social_media.sql](https://github.com/dbdesign-assignments-spring2023/sql-crud-aa8690/blob/main/social_media.sql).

#### 1. Register a new User.
    INSERT INTO users (username, email, password)
    VALUES ("aa8690", "aa8690@nyu.edu", "goodpassword");

#### 2. Create a new Message sent by a particular User to a particular User (pick any two Users for example).
    INSERT INTO posts (post_id, post_type, sender, recipient, content, post_time, is_visible)
    VALUES (2001, "Message", "aa8690", "epovalle", "Hello!", "2023-01-20 12:38:55", 0);

#### 3. Create a new Story by a particular User (pick any User for example).
    INSERT INTO posts (post_id, post_type, sender, recipient, content, post_time, is_visible)
    VALUES (2002, "Story", "aa8690", "Everyone", "Hey guys!", "2023-01-21 12:38:55", 1);

#### 4. Show the 10 most recent visible Messages and Stories, in order of recency.
    SELECT post_id, post_type, sender, recipient, content, post_time, is_visible,
    ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) AS hours_ago
    FROM (SELECT post_id, post_type, sender, recipient, content, post_time, is_visible
    FROM posts
    WHERE is_visible = 1 AND post_type == "Message"
    ORDER BY post_time DESC
    LIMIT 10)
    ORDER BY post_time DESC;

#### 5. Show the 10 most recent visible Messages sent by a particular User to a particular User (pick any two Users for example), in order of recency.
    SELECT post_id, post_type, sender, recipient, content, post_time, is_visible,
    ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) AS hours_ago
    FROM (SELECT post_id, post_type, sender, recipient, content, post_time, is_visible
    FROM posts
    WHERE is_visible = 1 AND post_type == "Message" AND sender == "jciubutaro6" AND recipient == "rfraser20"
    ORDER BY post_time DESC
    LIMIT 10) 
    ORDER BY post_time DESC; -- Because of the way my data was gathered, there are no instances of two users sharing more than one exchange

#### 6. Make all Stories that are more than 24 hours old invisible.
    UPDATE posts
    SET is_visible = 0
    WHERE post_type = 'Story' AND
    ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) > 24;

#### 7. Show all invisible Messages and Stories, in order of recency.
    SELECT post_id, post_type, sender, recipient, content, post_time, is_visible, 
    ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) AS hours_ago from posts
    WHERE is_visible = 0
    ORDER BY post_time DESC;

#### 8. Show the number of posts by each User.
    SELECT sender, COUNT(*) as 'Number of Posts'
    FROM posts
    GROUP BY sender;

#### 9. Show the post text and email address of all posts and the User who made them within the last 24 hours.
    SELECT p.content AS post_text, u.email AS user_email, u.username AS user_name
    FROM posts AS p
    JOIN users AS u ON p.sender = u.username
    WHERE p.is_visible = 1 AND p.post_type = 'Story' AND
    ROUND((JULIANDAY('now') - JULIANDAY(p.post_time)) * 24) >= 24;

#### 10. Show the email addresses of all Users who have not posted anything yet.
    SELECT u.username AS user_name, u.email AS user_email
    FROM users AS u
    LEFT JOIN posts AS p ON u.username = p.sender
    GROUP BY u.username
    HAVING COUNT(p.post_id) = 0;
