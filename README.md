# 🎵 Spotify Data Analysis using PostgreSQL  

## 📌 Overview  
This project leverages **PostgreSQL** to analyze **Spotify streaming data**, providing insights into **song popularity, artist trends, album characteristics, streaming engagement, and platform preferences**.  

Music streaming platforms generate vast amounts of data, and by leveraging **SQL queries**, we can answer key questions such as:  
✔️ Which **songs and artists** are the most popular?  
✔️ How do **album types (singles, EPs, albums)** vary in popularity?  
✔️ What **attributes** (danceability, energy, liveness) make a song a hit?  
✔️ How do **Spotify and YouTube engagement** compare?  
✔️ Can we detect **trends in song duration, energy, and views** over different artists and albums?  

By using **SQL aggregations, window functions, and Common Table Expressions (CTEs)**, this project uncovers valuable **insights into the music industry and listener behavior**.  

---

## 📂 Project Files  
- **`cleaned_dataset.csv`** – Cleaned dataset used for analysis.  
- **`Spotify Analysis SQL file.sql`** – SQL queries used for analysis in PostgreSQL.  
- **`Spotify Data Analysis using PostgreSQL Output file.docx`** – Output results of the executed queries.  

---

## 🛠️ SQL Queries Used  

### **🔍 Exploratory Data Analysis (EDA)**  
EDA helps us understand **the structure, uniqueness, and anomalies in the dataset** before proceeding to advanced analysis.  

#### **Basic Dataset Exploration**  
```sql
SELECT COUNT(*) FROM spotify; -- Total number of records
SELECT COUNT(DISTINCT artist), COUNT(DISTINCT album) FROM spotify; -- Unique artists & albums
SELECT DISTINCT album_type FROM spotify; -- Album types distribution
```

#### **Identifying Data Anomalies**  
```sql
SELECT * FROM spotify WHERE duration_min = 0; -- Finding songs with zero duration
DELETE FROM spotify WHERE duration_min = 0; -- Removing zero-duration tracks
SELECT COUNT(*) FROM spotify WHERE duration_min = 0; -- Re-checking dataset after deletion
```

---

### **📊 Data Insights & Aggregation**  
These queries uncover patterns in **stream counts, artist productivity, and song engagement metrics**.  

#### **Track & Artist Popularity**  
```sql
SELECT * FROM spotify WHERE stream > 1000000000; -- Most streamed songs (>1B streams)
SELECT artist, COUNT(track) FROM spotify GROUP BY artist; -- Total number of songs per artist
SELECT album, AVG(danceability) AS avg_danceability FROM spotify GROUP BY album ORDER BY avg_danceability DESC; -- Albums with highest danceability
```

#### **Audience Engagement**  
```sql
SELECT SUM(comments) FROM spotify WHERE licensed = 'true'; -- Total comments on licensed tracks
SELECT DISTINCT track, MAX(energy) FROM spotify GROUP BY track ORDER BY MAX(energy) DESC LIMIT 5; -- Top 5 songs with highest energy values
```

---

### **🚀 Advanced SQL Techniques for Deep Analysis**  
These queries utilize **window functions, platform comparisons, and complex aggregations** to generate deeper insights.  

#### **Comparing Streaming Engagement: Spotify vs. YouTube**  
```sql
SELECT track FROM (
  SELECT track,
  SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END) AS streamed_on_youtube,
  SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END) AS streamed_on_spotify
  FROM spotify
  GROUP BY track
) AS t1 WHERE streamed_on_spotify > streamed_on_youtube;
```

#### **Ranking Top 3 Most Viewed Tracks Per Artist** *(Window Functions)*  
```sql
WITH ranking_artist AS (
  SELECT artist, track, SUM(views) AS total_views,
  DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
  FROM spotify
  GROUP BY artist, track
)
SELECT * FROM ranking_artist WHERE rank <= 3;
```

#### **Calculating Energy Variability in Albums** *(Using CTEs)*  
```sql
WITH minmaxenergy AS (
  SELECT album, MAX(energy) AS highest_energy, MIN(energy) AS lowest_energy
  FROM spotify GROUP BY album
)
SELECT album, highest_energy - lowest_energy AS energy_diff FROM minmaxenergy ORDER BY energy_diff DESC;
```

---

## 🔎 What Was Done & Why?  

### **1️⃣ Data Cleaning & Preprocessing**  
✔️ **Removed invalid records** (e.g., zero-duration tracks) to prevent skewed results.  
✔️ **Standardized categorical values** (`licensed`, `official_video`) to avoid inconsistencies.  

### **2️⃣ Exploratory Data Analysis (EDA)**  
✔️ Checked **total records, unique artists, and album types**.  
✔️ Identified **anomalies in song duration and engagement data**.  

### **3️⃣ Data Insights & Aggregation**  
✔️ Identified **most streamed songs** and **most productive artists**.  
✔️ Analyzed **danceability and engagement metrics** to measure song success.  

### **4️⃣ Advanced SQL for Deeper Analysis**  
✔️ **Ranked** top tracks per artist using **window functions**.  
✔️ **Compared platform engagement** (Spotify vs. YouTube) to analyze **user preferences**.  
✔️ **Computed energy variations across albums** using **CTEs**.  

---

## 📊 Lessons Learned  

✔️ **Importance of Data Cleaning** – Removing anomalies improves data quality.  
✔️ **SQL Aggregations Provide Key Insights** – `COUNT()`, `AVG()`, `SUM()` reveal music trends.  
✔️ **Window Functions Improve Query Efficiency** – `DENSE_RANK()` simplifies ranking calculations.  
✔️ **Platform Analysis Helps Music Marketing** – Identifying where songs perform better.  
✔️ **CTEs Improve Query Readability & Performance** – `WITH` statements make queries more efficient.  

---

## 🛠️ Technologies Used  
- **PostgreSQL** – SQL-based data analytics.  
- **Excel/Google Sheets** – For data validation and preprocessing.  

---

## 🏁 How to Run the Queries  
1️⃣ **Install PostgreSQL** if not already installed.  
2️⃣ **Import `cleaned_dataset.csv`** into PostgreSQL.  
3️⃣ **Open `Spotify Analysis SQL file.sql`** and execute queries.  

--- 
