---- This code creates a table for restaurants:

-- CREATE TABLE restaurants (id INTEGER PRIMARY KEY, 
-- category TEXT NOT NULL, 
-- price_tier TEXT NOT NULL, 
-- neighborhood TEXT NOT NULL, 
-- opening_hours TEXT NOT NULL, 
-- avg_rating INTEGER NOT NULL, 
-- good_for_kids BOOLEAN NOT NULL);


---- This code creates a table for reviews:

-- CREATE TABLE reviews (review_id INTEGER PRIMARY KEY, 
-- id INTEGER NOT NULL,
-- rating INTEGER NOT NULL,
-- review TEXT NOT NULL,
-- FOREIGN KEY (id) REFERENCES restaurants(id));

-- Find all cheap restaurants in a particular neighborhood (pick any neighborhood as an example).
SELECT restaurants.id, restaurants.price_tier, restaurants.neighborhood from restaurants 
WHERE restaurants.price_tier = "Cheap" AND restaurants.neighborhood = "Chinatown";

-- Find all restaurants in a particular genre (pick any genre as an example) with 3 stars or more, ordered by the number of stars in descending order.
SELECT restaurants.id, restaurants.category, restaurants.avg_rating from restaurants
WHERE restaurants.category = "Pizza" AND restaurants.avg_rating >= 3
ORDER BY restaurants.avg_rating DESC;

-- Find all restaurants that are open now (see hint below).
SELECT * FROM restaurants
WHERE 
  strftime('%H:%M', 'now') BETWEEN 
    substr(opening_hours, 1, instr(opening_hours, ' ') - 1) -- extract the opening time before the space character
    AND substr(opening_hours, instr(opening_hours, '-') + 2); -- extract the closing time after the '-' character

-- Leave a review for a restaurant (pick any restaurant as an example).
insert into reviews (review_id, id, rating, review)
values (1, 1, 4, "Decent");

-- Delete all restaurants that are not good for kids.
DELETE FROM restaurants 
WHERE restaurants.good_for_kids = "FALSE";

-- Find the number of restaurants in each NYC neighborhood.
SELECT neighborhood, COUNT(*) as 'Number of Restaurants'
FROM restaurants
GROUP BY neighborhood;