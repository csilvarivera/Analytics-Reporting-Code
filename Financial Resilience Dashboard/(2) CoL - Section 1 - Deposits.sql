/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (2) CoL - Section 1 - Deposits.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-6823
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-03 to 2026-08
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Sight PCA and instant-access savings deposit buffers (<1 month net income resilience indicator).
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-03' AND '2026-08'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  ROUND(AVG(d.total_deposit_balance_gbp), 2) AS avg_deposit_balance_gbp,
  COUNTIF(d.buffer_less_than_1m_income_flag) AS low_savings_buffer_customers
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section1_deposits` AS d
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
