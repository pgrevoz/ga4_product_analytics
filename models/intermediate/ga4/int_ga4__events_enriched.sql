{{ config(tags=["ga4","intermediate"]) }}

with events as (

  select *
  from {{ ref('stg_ga4__events') }}

),

params as (

  select
    event_date,
    event_ts,
    user_id,
    event_name,

    -- Extract a few key params (extend later if needed)
    max(case when param_key = 'ga_session_id' then cast(param_int_value as string) end) as ga_session_id,
    max(case when param_key = 'page_location' then param_string_value end) as page_location,
    max(case when param_key = 'page_referrer' then param_string_value end) as page_referrer

  from {{ ref('stg_ga4__event_params') }}
  group by 1,2,3,4

),

joined as (

  select
    e.event_date,
    e.event_ts,
    e.event_name,
    e.user_id,
    e.device_category,
    e.country,
    e.traffic_source,
    case
      when lower(traffic_medium) = 'cpc' then 'paid'
      when lower(traffic_medium) = 'organic' then 'organic'
      when lower(traffic_medium) = 'referral' then 'referral'
      when traffic_medium in ('(none)', '(not set)') then 'direct'
      when traffic_medium is null or traffic_medium = '(data deleted)' then 'unknown'
      when traffic_medium = '<Other>' or lower(traffic_medium) = '<other>' then 'other'
      else 'other'
    end as channel_group,
    e.traffic_medium,
    p.ga_session_id,
    -- session_id stable for analysis
    case
      when p.ga_session_id is not null then concat(e.user_id, '-', p.ga_session_id)
    end as session_id,

    p.page_location,
    p.page_referrer

  from events e
  left join params p
    on e.event_date = p.event_date
   and e.event_ts = p.event_ts
   and e.user_id = p.user_id
   and e.event_name = p.event_name

)

select * from joined
