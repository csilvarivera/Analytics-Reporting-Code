/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (5) CoL - Section 4 - CC Utilisation.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-7015
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-04 to 2026-09
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Credit card limit utilisation tracking for September-26 refresh.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-04' AND '2026-09'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  COUNTIF(u.has_credit_card) AS active_cc_holders,
  COUNTIF(u.has_credit_card AND u.cc_utilisation_ratio >= 0.85) AS high_cc_utilisation_customers,
  ROUND(AVG(IF(u.has_credit_card, u.cc_utilisation_ratio, NULL)) * 100, 2) AS avg_util_pct
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section4_cc_utilisation` AS u
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
