/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (3) CoL - Section 2 - Income.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-7015
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-04 to 2026-09
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Monthly net salary and benefit inflows across eligible retail PCA holders.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-04' AND '2026-09'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  ROUND(AVG(i.net_salary_inflow_gbp), 2) AS avg_salary_gbp,
  ROUND(AVG(i.total_net_income_gbp), 2) AS avg_total_income_gbp
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section2_income` AS i
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
