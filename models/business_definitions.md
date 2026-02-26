{% docs ga4_channel_group %}
Standardized channel classification derived from GA4 `traffic_medium`.

Values used in this project:
- `paid`: medium is `cpc`
- `organic`: medium is `organic`
- `referral`: medium is `referral`
- `direct`: medium is `(none)` or `(not set)`
- `unknown`: medium is null or `(data deleted)`
- `other`: all remaining values
{% enddocs %}

{% docs ga4_session_id %}
Session key built as `concat(user_id, '-', ga_session_id)`.

This key is used for session-level funnel analysis and counting sessions across funnel steps.
{% enddocs %}

{% docs ga4_funnel_steps %}
Session-level funnel flags used in this project:
- `did_view_item`
- `did_add_to_cart`
- `did_begin_checkout`
- `did_purchase`

A value of `1` means the session included at least one event for that step.
{% enddocs %}
