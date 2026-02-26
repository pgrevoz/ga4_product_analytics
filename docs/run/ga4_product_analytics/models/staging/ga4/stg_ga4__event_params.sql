

  create or replace view `ga4-product-analytics-485709`.`stg`.`stg_ga4__event_params`
  OPTIONS()
  as with events as (

  select
    event_date,
    event_timestamp,
    user_pseudo_id as user_id,
    event_name,
    event_params
  from `bigquery-public-data`.`ga4_obfuscated_sample_ecommerce`.`events_*`

),

unnested as (

  select
    event_date,
    timestamp_micros(event_timestamp) as event_ts,
    user_id,
    event_name,

    -- one row per param
    ep.key as param_key,

    -- GA4 stores values in different typed fields; keep them all
    ep.value.string_value as param_string_value,
    ep.value.int_value as param_int_value,
    ep.value.float_value as param_float_value,
    ep.value.double_value as param_double_value

  from events,
  unnest(event_params) as ep

)

select * from unnested;

