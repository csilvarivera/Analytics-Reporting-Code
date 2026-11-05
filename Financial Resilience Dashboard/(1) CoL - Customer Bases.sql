/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (1) CoL - Customer Bases.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-7015
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-04 to 2026-09
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Core active customer base and resilience tier distribution by UK brand and segment.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT
    c.reporting_month,
    c.customer_id,
    c.brand,
    c.segment,
    c.resilience_tier
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-04' AND '2026-09'
    AND c.is_suppressed = FALSE -- KC2-SUPP-01: Exclude deceased, gone-away, and legal-hold customers
)
SELECT
  reporting_month,
  COUNT(DISTINCT customer_id) AS clean_customers,
  COUNTIF(resilience_tier = 'Stressed') AS stressed_customers,
  COUNTIF(resilience_tier = 'Stretching') AS stretching_customers,
  COUNTIF(resilience_tier = 'Resilient') AS resilient_customers
FROM eligible_customers
GROUP BY 1
ORDER BY 1;
