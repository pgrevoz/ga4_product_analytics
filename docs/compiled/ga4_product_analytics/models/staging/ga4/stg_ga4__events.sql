with source as (

  select *
  from `bigquery-public-data`.`ga4_obfuscated_sample_ecommerce`.`events_*`

),

renamed as (

  select
    event_date,
    timestamp_micros(event_timestamp) as event_ts,
    event_name,
    user_pseudo_id as user_id,
    device.category as device_category,
    geo.country as country,
    traffic_source.source as traffic_source,
    traffic_source.medium as traffic_medium
  from source

)

select * from renamed