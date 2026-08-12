{{ config(materialized='metric_view') }}

version: 1.1
source: {{ ref('fct_orders') }}
comment: >
  E-commerce order metrics, authored and governed by the dbt platform project.
  Mirror of the dbt Semantic Layer metrics in models/semantic/_semantic_models.yml.

dimensions:
  - name: order_date
    expr: order_date
    display_name: Order Date
    format:
      type: date
      date_format: year_month_day
      leading_zeros: true
    synonyms:
      - date
      - when ordered
      - order day

  - name: status
    expr: status
    display_name: Order Status
    comment: "Valid values: placed, shipped, completed, returned"
    synonyms:
      - order status
      - fulfillment status
      - state

  - name: payment_method
    expr: payment_method
    display_name: Payment Method
    synonyms:
      - how paid
      - payment type
      - tender

measures:
  - name: total_revenue
    expr: SUM(CASE WHEN status = 'completed' THEN amount_paid ELSE 0 END)
    display_name: Total Revenue
    comment: >
      Sum of amount_paid for completed orders only. Because the source is the
      contracted fct_orders mart, a breaking schema change fails dbt CI before it
      can silently break this metric.
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
      hide_group_separator: false
      abbreviation: compact
    synonyms:
      - revenue
      - total sales
      - recognised revenue
      - sales

  - name: avg_order_value
    expr: AVG(CASE WHEN status = 'completed' THEN amount_paid END)
    display_name: Average Order Value
    comment: Average payment amount for completed orders only.
    format:
      type: currency
      currency_code: USD
      decimal_places:
        type: exact
        places: 2
      hide_group_separator: false
    synonyms:
      - aov
      - average revenue per order
      - average basket

  - name: total_orders
    expr: COUNT(DISTINCT order_id)
    display_name: Total Orders
    comment: Count of all orders regardless of status.
    format:
      type: number
      decimal_places:
        type: all
      hide_group_separator: false
    synonyms:
      - order count
      - number of orders
      - orders

  - name: return_rate
    expr: >
      COUNT(DISTINCT CASE WHEN status = 'returned' THEN order_id END)
      / CAST(COUNT(DISTINCT order_id) AS DOUBLE) * 100
    display_name: Return Rate (%)
    comment: Percentage of orders that were returned.
    format:
      type: percentage
      decimal_places:
        type: exact
        places: 1
      hide_group_separator: true
    synonyms:
      - returns
      - refund rate
      - percentage returned
