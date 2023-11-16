use ig_clone;
-- 	QUESTION 1. Create an ER diagram or draw a schema for the given database.

-- QUESTION 2. We want to reward the user who has been around the longest, Find the 5 oldest users.

SELECT * FROM users 
ORDER BY created_at 
LIMIT 5;

-- QUESTION 3. To target inactive users in an email ad campaign, find the users who have never posted a photo

SELECT * 
FROM users 
WHERE id not in ( select user_id from photos );

-- QUESTION 4. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

WITH mst as (select p.user_id,u.username, p.id as photo_id, count(photo_id) likes
FROM photos p  inner join likes l on p.id=l.photo_id
inner join users u on u.id=p.user_id
GROUP BY  photo_id, u.username, p.user_id ) 
SELECT user_id,username, max(likes) FROM mst 
 GROUP BY user_id
 ORDER BY max(likes) desc
 LIMIT 1;

-- QUESTION 5. The investors want to know how many times does the average user post.

WITH avg_p as (SELECT user_id, count(user_id) num
FROM photos
GROUP BY user_id)
SELECT avg(num) FROM avg_p;

-- QUESTION 6. A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags.

SELECT pt.tag_id, count(pt.tag_id) num_tags, t.tag_name  FROM tags t
inner join photo_tags pt
on pt.tag_id=t.id 
GROUP BY pt.tag_id, t.tag_name
ORDER BY num_tags desc
LIMIT 5;

-- QUESTION 7. To find out if there are bots, find users who have liked every single photo on the site.

SELECT user_id, count(user_id) num_likes
FROM likes
GROUP BY user_id
HAVING COUNT(distinct photo_id) = (SELECT COUNT(*) FROM photos);

-- QUESTION 8. Find the users who have created instagram id in may and select top 5 newest joinees from it?

SELECT id, created_at
FROM users
WHERE monthname(created_at) like 'may'
ORDER BY created_at desc
LIMIT 5;

-- QUESTION 9. Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?

SELECT distinct u.id, u.username
FROM users u 
inner join photos ph on ph.user_id=u.id
inner join likes l on l.user_id=u.id
WHERE username regexp '^c.*[0-9]$';

-- QUESTION 10. Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.

SELECT  u.username, count(user_id) photo_count
FROM users u
inner join photos p on u.id=p.user_id
GROUP BY username 
having count(user_id) between 3 and 5 
ORDER BY photo_count desc
LIMIT 30;


