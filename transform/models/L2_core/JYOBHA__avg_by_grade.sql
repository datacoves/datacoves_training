with raw_source as (

    select * from {{ ref('stg_jyobha_personal_loans') }}

)

, final as (

    SELECT
        GRADE,
        avg(LOAN_AMNT) as avg_loan_amount,
        COUNT(*) AS total_loans
    from raw_source
    WHERE loan_status = 'Fully Paid'
    group by grade
    order by grade

)

select * FROM final
