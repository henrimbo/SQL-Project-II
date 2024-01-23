 -- # Selecting trips with duration over 1200 seconds and with tips: 

 SELECT * 
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE trip_seconds > 1200 AND 
       tips > 0 

-- # Count of trips with tolls, grouped by company and specific date: 

 SELECT company, 
        FORMAT_TIMESTAMP('%y-%m-%d', trip_start_timestamp) AS data_trip, 
        COUNT (unique_key) AS Total_trips
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE tolls > 0 AND 
       FORMAT_TIMESTAMP('%y-%m-%d', trip_start_timestamp) = '15-08-21'
 GROUP BY company, 
          data_trip

-- # Count of trips per year for a specific company:

 SELECT company, 
        EXTRACT(YEAR FROM trip_start_timestamp) as Year, 
        COUNT (unique_key) AS Total_trips
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE company = 'Taxi Affiliation Services'
 GROUP BY company, Year
 ORDER BY Year DESC


-- # Analysing the average price of the trips over the year

 SELECT EXTRACT(YEAR FROM trip_start_timestamp) AS year, 
        AVG(fare) AS average_fare
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY year


 -- # Analysing the total miles of the trips by year and company. 

 SELECT company, 
        EXTRACT(YEAR FROM trip_start_timestamp) AS year, 
        SUM(trip_miles) AS total_miles
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, year
 ORDER BY company, year

 -- # Analysing the payment type by year and company

 SELECT company, 
        EXTRACT(YEAR FROM trip_start_timestamp) AS year, 
        payment_type, 
        COUNT(unique_key) AS total_trips, 
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, 
          year, 
          payment_type


 -- # Conditional column for fare ranges and analysis of payment type by fare range:

 SELECT *, 
   CASE 
     WHEN fare < 10 THEN '0-10'
     WHEN fare BETWEEN 10 AND 20 THEN '10-20'
     WHEN fare BETWEEN 20 AND 30 THEN '20-30'
     ELSE '30+' 
   END AS fare_range,
          payment_type
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`

 -- # Analysing the average price of the trips with a distance above 10 miles

 SELECT company, 
        AVG(fare) AS average_fare
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE trip_miles > 10
 GROUP BY company

 -- # Analysing average price, distance, quantity (number of trips), time of trips by year and company.  

 SELECT company, 
        EXTRACT(YEAR FROM trip_start_timestamp) AS year, 
        AVG(fare) AS average_fare, 
        SUM(trip_miles) AS total_miles, 
        COUNT(unique_key) AS total_trips, 
        SUM(trip_seconds) / 3600 AS total_hours
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, 
          year

