with steps as (

  select *
  from {{ ref('int_ga4__funnel_steps') }}

),

agg as (

  select
    event_date,
    device_category,
    traffic_source,
    channel_group,
    traffic_medium,
    country,

    count(distinct session_id) as sessions,

    sum(did_view_item) as sessions_with_view_item,
    sum(did_add_to_cart) as sessions_with_add_to_cart,
    sum(did_begin_checkout) as sessions_with_begin_checkout,
    sum(did_purchase) as sessions_with_purchase,

    safe_divide(sum(did_add_to_cart), nullif(sum(did_view_item), 0)) as cart_rate_from_view,
    safe_divide(sum(did_begin_checkout), nullif(sum(did_add_to_cart), 0)) as checkout_rate_from_cart,
    safe_divide(sum(did_purchase), nullif(sum(did_begin_checkout), 0)) as purchase_rate_from_checkout,
    safe_divide(sum(did_purchase), nullif(sum(did_view_item), 0)) as purchase_rate_from_view

  from steps
  group by 1,2,3,4,5,6

)

select * from agg
