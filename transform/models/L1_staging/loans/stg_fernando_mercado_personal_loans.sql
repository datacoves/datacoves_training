with raw_source as (

    select *
    from {{ source('FERNANDO_MERCADO', 'PERSONAL_LOANS') }}

),

final as (

    select
        "_AIRBYTE_RAW_ID"::varchar as airbyte_raw_id,
        "_AIRBYTE_EXTRACTED_AT"::timestamp_tz as airbyte_extracted_at,
        "_AIRBYTE_META"::variant as airbyte_meta,
        "DTI"::float as dti,
        "URL"::varchar as url,
        "DESC"::varchar as desc,
        "TERM"::varchar as term,
        "GRADE"::varchar as grade,
        "TITLE"::varchar as title,
        "ISSUE_D"::varchar as issue_d,
        "LOAN_ID"::varchar as loan_id,
        "PUB_REC"::float as pub_rec,
        "PURPOSE"::varchar as purpose,
        "INT_RATE"::float as int_rate,
        "OPEN_ACC"::float as open_acc,
        "ZIP_CODE"::varchar as zip_code,
        "EMP_TITLE"::varchar as emp_title,
        "LOAN_AMNT"::float as loan_amnt,
        "MEMBER_ID"::float as member_id,
        "OUT_PRNCP"::float as out_prncp,
        "REVOL_BAL"::float as revol_bal,
        "SUB_GRADE"::varchar as sub_grade,
        "TOTAL_ACC"::float as total_acc,
        "ADDR_STATE"::varchar as addr_state,
        "ANNUAL_INC"::float as annual_inc,
        "EMP_LENGTH"::varchar as emp_length,
        "PYMNT_PLAN"::varchar as pymnt_plan,
        "RECOVERIES"::float as recoveries,
        "REVOL_UTIL"::varchar as revol_util,
        "DELINQ_2YRS"::float as delinq_2yrs,
        "FUNDED_AMNT"::float as funded_amnt,
        "INSTALLMENT"::float as installment,
        "LOAN_STATUS"::varchar as loan_status,
        "POLICY_CODE"::float as policy_code,
        "TOTAL_PYMNT"::float as total_pymnt,
        "LAST_PYMNT_D"::varchar as last_pymnt_d,
        "NEXT_PYMNT_D"::varchar as next_pymnt_d,
        "OUT_PRNCP_INV"::float as out_prncp_inv,
        "TOTAL_REC_INT"::float as total_rec_int,
        "HOME_OWNERSHIP"::varchar as home_ownership,
        "INQ_LAST_6MTHS"::float as inq_last_6mths,
        "FUNDED_AMNT_INV"::float as funded_amnt_inv,
        "LAST_PYMNT_AMNT"::float as last_pymnt_amnt,
        "TOTAL_PYMNT_INV"::float as total_pymnt_inv,
        "TOTAL_REC_PRNCP"::float as total_rec_prncp,
        "EARLIEST_CR_LINE"::varchar as earliest_cr_line,
        "LAST_CREDIT_PULL_D"::varchar as last_credit_pull_d,
        "TOTAL_REC_LATE_FEE"::float as total_rec_late_fee,
        "INITIAL_LIST_STATUS"::varchar as initial_list_status,
        "VERIFICATION_STATUS"::varchar as verification_status,
        "MTHS_SINCE_LAST_DELINQ"::float as mths_since_last_delinq,
        "MTHS_SINCE_LAST_RECORD"::float as mths_since_last_record,
        "COLLECTION_RECOVERY_FEE"::float as collection_recovery_fee,
        "COLLECTIONS_12_MTHS_EX_MED"::float as collections_12_mths_ex_med,
        "MTHS_SINCE_LAST_MAJOR_DEROG"::float as mths_since_last_major_derog

    from raw_source

)

select * from final
