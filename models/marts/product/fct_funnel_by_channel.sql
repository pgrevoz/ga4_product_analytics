with sessions as (

  select *
  from {{ ref('int_ga4__funnel_steps') }}

),

agg as (

  select
    channel_group,
    count(*) as sessions,

    sum(did_view_item) as sessions_view_item,
    sum(did_add_to_cart) as sessions_add_to_cart,
    sum(did_begin_checkout) as sessions_begin_checkout,
    sum(did_purchase) as sessions_purchase

  from sessions
  group by 1

)

select
  channel_group,
  sessions,
  sessions_view_item,
  sessions_add_to_cart,
  sessions_begin_checkout,
  sessions_purchase,

  safe_divide(sessions_add_to_cart, sessions_view_item) as view_to_cart_rate,
  safe_divide(sessions_begin_checkout, sessions_add_to_cart) as cart_to_checkout_rate,
  safe_divide(sessions_purchase, sessions_begin_checkout) as checkout_to_purchase_rate,
  safe_divide(sessions_purchase, sessions_view_item) as overall_conversion_rate

from agg
order by overall_conversion_rate desc
