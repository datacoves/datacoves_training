with raw_source as (

    select * from {{ ref('stg_amberchilesdg_personal_loans') }}

),

final as (

    select
        grade,
        avg(loan_amnt) as avg_loan_amount,
        count(*) as total_loans
    from raw_source
    where loan_status = 'Fully Paid'
    group by grade
    order by grade

)

select * from final
