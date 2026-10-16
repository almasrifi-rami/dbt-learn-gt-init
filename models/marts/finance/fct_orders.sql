with orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when payment_status = 'success' then payment_amount end) as order_amount
    from payments
    group by 1
),

final as (
    select
        order_id,
        customer_id,
        order_date,
        coalesce(order_amount, 0) as amount
    from order_payments
    left join orders using (order_id)
)

select * from final
