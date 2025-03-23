{{ config(materialized="table") }}

with bike_data as
(
  select *,
    row_number() over(partition by started_at) as rn
  from {{ source('staging','divvy_tripdata_all') }}
  where ride_id is not null 
)
select
    -- identifiers
    cast(ride_id as string) as ride_id,
    CASE WHEN REGEXP_CONTAINS(start_station_id, r'^[0-9]+$') THEN cast(start_station_id as integer) ELSE NULL END as start_station_id,
    CASE WHEN REGEXP_CONTAINS(end_station_id, r'^[0-9]+$') THEN cast(end_station_id as integer) ELSE NULL END as end_station_id,

    -- timestamps
    cast(started_at as timestamp) as started_at,
    cast(ended_at as timestamp) as ended_at,

    -- bike information
    cast(rideable_type as string) as rideable_type,

    -- trip information 
    cast(start_station_name as string) as start_station_name,
    cast(end_station_name as string) as end_station_name,
    
        -- Replace null values with 'Unknown' for latitude and longitude columns
    cast(start_lat AS NUMERIC) as start_latitude,
    cast(start_lng AS NUMERIC) as start_longitude,
    cast(end_lat AS NUMERIC) as end_latitude,
    cast(end_lng AS NUMERIC) as end_longitude,


    -- - customer info
    cast(member_casual as string) as member_casual

from bike_data
where rn = 1


-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=false) %}

  --limit 100

{% endif %}