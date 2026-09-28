{{ config(materialized='view', access='protected') }}

select * from {{ ref('dim_customers', v=1) }}
