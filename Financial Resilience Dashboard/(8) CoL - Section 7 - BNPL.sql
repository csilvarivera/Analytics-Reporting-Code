/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (8) CoL - Section 7 - BNPL.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-6823
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-03 to 2026-08
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: External Buy-Now-Pay-Later (Klarna, Clearpay, PayPal Pay-in-3, Zilch) outflow tracking.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-03' AND '2026-08'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  COUNTIF(b.bnpl_active_flag) AS active_bnpl_customers,
  ROUND(SUM(b.bnpl_spend_gbp), 2) AS total_bnpl_spend_gbp
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section7_bnpl` AS b
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
