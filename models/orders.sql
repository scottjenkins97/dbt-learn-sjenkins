with orders as (
    select * from {{ ref('stg_orders') }}
),
payments as (
    select * from {{ ref('stg_payments') }}
),
aggregated as (
    select
        order_id,
        sum(payments.amount) as calculated_amount
    from payments
    where status = 'success'
    group by 1
),
joined as (
    select
        order_id,
        order_date,
        customer_id,
        calculated_amount
    from aggregated
    join orders using (order_id)
)
select * from joined