{{ config(materialized="table") }}

with
    unique_subscriptions as (
        select distinct member_casual from {{ ref("stg_divvy_tripdata") }}
    )

select {{ dbt_utils.generate_surrogate_key(["member_casual"]) }} as member_casual_id,
    member_casual
from unique_subscriptions