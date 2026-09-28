{{ config(materialized='view', access='protected') }}

select * from {{ ref('fct_orders', v=1) }}
