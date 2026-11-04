/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (4) CoL - Section 3 - Spend.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-6823
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-03 to 2026-08
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Essential household bills/groceries/energy spend vs discretionary spend split.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-03' AND '2026-08'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  ROUND(SUM(s.essential_spend_gbp), 2) AS total_essential_spend_gbp,
  ROUND(SUM(s.discretionary_spend_gbp), 2) AS total_discretionary_spend_gbp,
  ROUND(SAFE_DIVIDE(SUM(s.essential_spend_gbp), SUM(s.total_outflow_spend_gbp)) * 100, 2) AS essential_spend_share_pct
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section3_spend` AS s
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
