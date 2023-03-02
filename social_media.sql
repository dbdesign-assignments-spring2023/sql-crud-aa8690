-- -- Table for users
-- CREATE TABLE users (username TEXT PRIMARY KEY,
-- email TEXT NOT NULL,
-- password TEXT NOT NULL);

-- -- Table for posts
-- CREATE TABLE posts (post_id INTEGER PRIMARY KEY,
-- post_type TEXT NOT NULL,
-- sender TEXT NOT NULL,
-- recipient TEXT NOT NULL,
-- content TEXT NOT NULL,
-- post_time TEXT NOT NULL,
-- is_visible BOOLEAN NOT NULL,
-- FOREIGN KEY (sender) REFERENCES users(username),
-- FOREIGN KEY (recipient) REFERENCES users(username));

-- Register a new User.
INSERT INTO users (username, email, password)
VALUES ("aa8690", "aa8690@nyu.edu", "goodpassword");

-- Create a new Message sent by a particular User to a particular User (pick any two Users for example).
INSERT INTO posts (post_id, post_type, sender, recipient, content, post_time, is_visible)
VALUES (2001, "Message", "aa8690", "epovalle", "Hello!", "2023-01-20 12:38:55", 0);

-- Create a new Story by a particular User (pick any User for example).
INSERT INTO posts (post_id, post_type, sender, recipient, content, post_time, is_visible)
VALUES (2002, "Story", "aa8690", "Everyone", "Hey guys!", "2023-01-21 12:38:55", 1);

-- Show the 10 most recent visible Messages and Stories, in order of recency.
SELECT post_id, post_type, sender, recipient, content, post_time, is_visible,
ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) AS hours_ago
FROM (SELECT post_id, post_type, sender, recipient, content, post_time, is_visible
FROM posts
WHERE is_visible = 1 AND post_type == "Message"
ORDER BY post_time DESC
LIMIT 10)
ORDER BY post_time DESC;

-- Show the 10 most recent visible Messages sent by a particular User to a particular User (pick any two Users for example), in order of recency.
SELECT post_id, post_type, sender, recipient, content, post_time, is_visible,
ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) AS hours_ago
FROM (SELECT post_id, post_type, sender, recipient, content, post_time, is_visible
FROM posts
WHERE is_visible = 1 AND post_type == "Message" AND sender == "jciubutaro6" AND recipient == "rfraser20"
ORDER BY post_time DESC
LIMIT 10) 
ORDER BY post_time DESC; -- Because of the way my data was gathered, there are no instances of two users sharing more than one exchange

-- Make all Stories that are more than 24 hours old invisible.
UPDATE posts
SET is_visible = 0
WHERE post_type = 'Story' AND
ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) > 24;

-- Show all invisible Messages and Stories, in order of recency.

SELECT post_id, post_type, sender, recipient, content, post_time, is_visible, 
ROUND((JULIANDAY('now') - JULIANDAY(post_time)) * 24) AS hours_ago from posts
WHERE is_visible = 0
ORDER BY post_time DESC;

-- Show the number of posts by each User.
SELECT sender, COUNT(*) as 'Number of Posts'
FROM posts
GROUP BY sender;

-- Show the post text and email address of all posts and the User who made them within the last 24 hours.
SELECT p.content AS post_text, u.email AS user_email, u.username AS user_name
FROM posts AS p
JOIN users AS u ON p.sender = u.username
WHERE p.is_visible = 1 AND p.post_type = 'Story' AND
ROUND((JULIANDAY('now') - JULIANDAY(p.post_time)) * 24) >= 24;

-- Show the email addresses of all Users who have not posted anything yet.
SELECT u.username AS user_name, u.email AS user_email
FROM users AS u
LEFT JOIN posts AS p ON u.username = p.sender
GROUP BY u.username
HAVING COUNT(p.post_id) = 0;