{{ config(tags=["ga4","intermediate"]) }}

with events as (

  select *
  from {{ ref('int_ga4__events_enriched') }}
  where session_id is not null

),

session_steps as (

  select
    event_date,
    session_id,
    user_id,

    -- dimensions for slicing
    any_value(device_category) as device_category,
    any_value(traffic_source) as traffic_source,
    any_value(traffic_medium) as traffic_medium,
    any_value(channel_group) as channel_group,
    any_value(country) as country,

    -- step flags (did the session contain at least one such event?)
    max(case when event_name = 'view_item' then 1 else 0 end) as did_view_item,
    max(case when event_name = 'add_to_cart' then 1 else 0 end) as did_add_to_cart,
    max(case when event_name = 'begin_checkout' then 1 else 0 end) as did_begin_checkout,
    max(case when event_name = 'purchase' then 1 else 0 end) as did_purchase

  from events
  group by 1,2,3

)

select * from session_steps
