
  create or replace   view PRD_DATABASE_STAGING.ANALYTICS.stg_country_populations
  
   as (
    with raw_source as (

    select *
    from RAW.COUNTRY_DATA.COUNTRY_POPULATIONS

),

final as (

    select
        "YEAR"::float as year,
        "COUNTRY NAME"::varchar as country_name,
        "VALUE"::float as value,
        "COUNTRY CODE"::varchar as country_code

    from raw_source

)

select * from final
  );

