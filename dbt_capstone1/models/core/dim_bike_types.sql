{{ config(materialized="table") }}

with
    unique_bike_types as (
        select distinct rideable_type from {{ ref("stg_divvy_tripdata") }}
    )

select {{ dbt_utils.generate_surrogate_key(["rideable_type"]) }} as rideable_type_id,
    rideable_type
from unique_bike_types
