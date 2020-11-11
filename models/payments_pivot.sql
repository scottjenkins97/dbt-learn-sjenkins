with payments as (
  select * from {{ref('stg_payments') }}
  ) , 

pivot as 
-- can we omit the comma on the final element?
-- If last element in the array, then change statement (compare length of the array to current position)
-- Another array with whitespace (i.e.  [",", ",", ",", ",", ""])


(
  select
  order_id,
  {%- for pm in ['credit_card','bank_transfer','gift_card','coupon'] -%}
    {%- if not loop.last -%}
      sum(case when payment_method = '{{ pm }}' then amount else 0 end) as {{ pm }}_amount,
    {%- else -%}
      sum(case when payment_method = '{{ pm }}' then amount else 0 end) as {{ pm }}_amount
    {%- endif -%}
  {% endfor %}
  from payments 
  group by order_id
)

select * 
from pivot
