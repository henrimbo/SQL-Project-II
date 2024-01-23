 #Seleção de corridas com duração maior que 1200 segundos e com gorjeta:

 SELECT * 
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE trip_seconds > 1200 AND tips > 0 

 #Quantidade de corridas com pedágio, agrupadas por companhia e mês/ano da corrida:

 SELECT company, FORMAT_TIMESTAMP('%y-%m-%d', trip_start_timestamp) AS data_trip, 
   COUNT (unique_key) AS Total_trips
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE tolls > 0 AND FORMAT_TIMESTAMP('%y-%m-%d', trip_start_timestamp) = '15-08-21'
 GROUP BY company, data_trip

 # Quantidade de corridas por ano e por companhia:

 SELECT company, EXTRACT(YEAR FROM trip_start_timestamp) as Year, COUNT (unique_key) AS Total_trips
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE company = 'Taxi Affiliation Services'
 GROUP BY company, Year
 ORDER BY Year DESC


 # Análise do preço das corridas ao longo dos anos

 SELECT EXTRACT(YEAR FROM trip_start_timestamp) AS year, AVG(fare) AS average_fare
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY year

 # Análise da evolução do número de corridas e milhas percorridas por companhia ao longo dos anos

 # Para o número de corridas:

 SELECT company, EXTRACT(YEAR FROM trip_start_timestamp) AS year, COUNT(unique_key) AS total_trips
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, year


 # Para milhas percorridas:

 SELECT company, EXTRACT(YEAR FROM trip_start_timestamp) AS year, SUM(trip_miles) AS total_miles
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, year
 ORDER BY company, year

 # Percentual por tipo de pagamento, agrupado por ano e companhia:

 SELECT 
   company, 
   EXTRACT(YEAR FROM trip_start_timestamp) AS year, 
   payment_type, 
   COUNT(unique_key) AS total_trips, 
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, year, payment_type


 # Coluna condicional de faixa de valores e análise de forma de pagamento por faixa de valor:

 SELECT *, 
   CASE 
     WHEN fare < 10 THEN '0-10'
     WHEN fare BETWEEN 10 AND 20 THEN '10-20'
     WHEN fare BETWEEN 20 AND 30 THEN '20-30'
     ELSE '30+' 
   END AS fare_range,
   payment_type
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`

 # Análise do preço da viagem por companhia com filtro de quantidade de milhas: 

 SELECT company, 
   AVG(fare) AS average_fare
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE trip_miles > 10
 GROUP BY company

 # Ticket médio, quantidade de milhas percorridas, quantidade de viagens e horas viajadas por ano e companhia:

 SELECT 
   company, 
   EXTRACT(YEAR FROM trip_start_timestamp) AS year, 
   AVG(fare) AS average_fare, 
   SUM(trip_miles) AS total_miles, 
   COUNT(unique_key) AS total_trips, 
   SUM(trip_seconds) / 3600 AS total_hours
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 GROUP BY company, year

 SELECT company, EXTRACT(YEAR FROM trip_start_timestamp) AS Year, sum(fare) / sum(trip_miles) as avg_fare_mile
 FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
 WHERE trip_miles > 0 AND company = 'Taxi Affiliation Services' AND EXTRACT(YEAR FROM trip_start_timestamp) > 2014
 GROUP BY company, Year
 ORDER BY Year DESC
