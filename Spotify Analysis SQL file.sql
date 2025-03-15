-- Advanced SQL Project on Spotify
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA
SELECT COUNT(*) FROM spotify; -- Count the total number of rows

SELECT COUNT(DISTINCT artist) FROM spotify; -- Count the total number of unqiue artists

SELECT COUNT(DISTINCT album) FROM spotify; -- Count the total number of unique albums

SELECT DISTINCT album_type FROM spotify; -- What are different album types?

SELECT MAX(duration_min) FROM spotify; -- Max duration of a song

SELECT MIN(duration_min) FROM spotify; -- Min duration of a song

-- Min duration = 0 in our last query which is not possible
SELECT * FROM spotify 
WHERE duration_min = 0; -- So find out tracks where duration = 0

DELETE FROM spotify
WHERE duration_min = 0; -- Delete tracks that have 0 minimum duration 
SELECT * FROM spotify 
WHERE duration_min = 0; -- Print the list of songs again to make sure the tracks with min_duration = 0 are deleted

SELECT DISTINCT channel FROM spotify; -- Check the types of channels

						-----------------------
						---- Data Analysis ----
						-----------------------
						
-- Retrieve the names of all tracks that have more than 1 billion streams
SELECT * FROM spotify 
WHERE stream > 1000000000;

-- List all the albums along with their respective artists
SELECT DISTINCT album, artist FROM spotify;

-- Get the total number of comments for the licensed tracks 
SELECT SUM(comments) AS total_comments FROM spotify;
WHERE licensed = 'true'

-- Find all the tracks that belong to album type 'single'
SELECT * FROM spotify
WHERE album_type = 'single';

-- Count the total number of tracks by each artist
SELECT artist, COUNT(track) FROM spotify 
GROUP BY artist;

-- Calculate the average danceability of tracks in each album 
SELECT album, AVG(danceability) AS avg_danceability
FROM spotify 
GROUP BY album;

-- Find the top 5 tracks with the highest energy values 
SELECT DISTINCT track, MAX(energy) 
FROM spotify 
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;

-- List all the tracks along with their views and likes where official_video = TRUE
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY track;

-- For each album calculate the total views of all associated tracks
SELECT album, track, SUM(views) AS total_views
FROM spotify
GROUP BY album, track
ORDER BY 1 DESC;

-- Retrieve the track names that have been streamed on Spotify more than Youtube 
SELECT * FROM 
(SELECT track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify
	FROM spotify
	GROUP BY track)
AS t1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0;

-- Find the top 3 most viewed tracks for each artist using window functions
WITH ranking_artist AS -- CTE named as ranking_artist
(SELECT artist, track, SUM(views) as total_views, -- select the columns
DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank -- use DENSE_RANK() to assign ranks to views
FROM spotify
GROUP BY artist, track
ORDER BY artist, total_views DESC)

SELECT * FROM ranking_artist WHERE rank <= 3; -- SELECT from the CTE

-- Write a query to find tracks where the liveness score is above average
SELECT track, liveness FROM spotify WHERE liveness > (SELECT AVG(liveness) AS avg_liveness FROM spotify)
ORDER BY liveness DESC;

-- Use a WITH clause to calculate the difference between the
-- highest and the lowest energy values for tracks in each album

WITH minmaxenergy
AS
(SELECT album, MAX(energy) AS highest_energy, MIN(energy) AS lowest_energy
FROM spotify
GROUP BY album) 
SELECT album, highest_energy - lowest_energy AS energy_diff
FROM minmaxenergy
ORDER BY energy_diff DESC;