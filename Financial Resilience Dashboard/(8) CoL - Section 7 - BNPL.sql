-- Quick BNPL pull for September-26 dashboard refresh (Andrew's GCA quote)
SELECT
  b.reporting_month,
  COUNTIF(b.bnpl_active_flag) AS active_bnpl_customers,
  ROUND(SUM(b.bnpl_spend_gbp), 2) AS total_bnpl_spend_gbp
FROM `csilva-sobi-demo.lbg_financial_resilience.col_section7_bnpl` b
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` c
  ON b.reporting_month = c.reporting_month
 AND b.customer_id = c.customer_id
WHERE b.reporting_month >= '2026-07'
GROUP BY 1
ORDER BY 1;
