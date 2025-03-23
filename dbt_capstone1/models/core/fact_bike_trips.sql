{{ config(materialized='table') }}

-- Join the staging data with the dimension tables
WITH bike_data AS (
    SELECT
        -- identifiers
        CAST(ride_id AS STRING) AS ride_id,
        CAST(start_station_id AS INTEGER) AS start_station_id,
        CAST(end_station_id AS INTEGER) AS end_station_id,
        -- timestamps
        CAST(started_at AS TIMESTAMP) AS started_at,
        CAST(ended_at AS TIMESTAMP) AS ended_at,
        -- bike information
        CAST(rideable_type AS STRING) AS rideable_type,
        -- trip information
        CAST(start_station_name AS STRING) AS start_station_name,
        CAST(end_station_name AS STRING) AS end_station_name,
        CAST(start_latitude AS NUMERIC) AS start_latitude,
        CAST(start_longitude AS NUMERIC) AS start_longitude,
        CAST(end_latitude AS NUMERIC) AS end_latitude,
        CAST(end_longitude AS NUMERIC) AS end_longitude,
        -- customer info
        CAST(member_casual AS STRING) AS member_casual
    FROM
        {{ ref('stg_divvy_tripdata') }}
)

SELECT
    bd.ride_id,
    bd.start_station_id,
    bd.end_station_id,
    bd.started_at,
    bd.ended_at,
    -- Calculate duration in seconds
    TIMESTAMP_DIFF(bd.ended_at, bd.started_at, SECOND) AS duration_seconds,
    bd.rideable_type,
    bd.start_station_name,
    bd.end_station_name,
    bd.start_latitude,
    bd.start_longitude,
    bd.end_latitude,
    bd.end_longitude,
    ---Calculate distance in meters using created distance_from_cordinates macro
    {{ distance_from_cordinates('bd.start_longitude', 'bd.start_latitude', 'bd.end_longitude', 'bd.end_latitude') }},
    
    bd.member_casual,
    s.station_id AS station_id_fk,
    m.member_casual_id,
    t.rideable_type_id
FROM
    bike_data bd
LEFT JOIN
    {{ ref('dim_stations') }} s ON bd.start_station_id = s.station_id
LEFT JOIN
    {{ ref('dim_bike_membership') }} m ON bd.member_casual = m.member_casual
LEFT JOIN
    {{ ref('dim_bike_types') }} t ON bd.rideable_type = t.rideable_type