-- v2 introduces the breaking product_name -> product_display_name rename.
with products as (
    select * from {{ ref('stg_products') }}
)
select
    product_id,
    product_name as product_display_name,
    category,
    unit_price,
    is_active
from products
