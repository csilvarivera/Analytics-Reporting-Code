/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (6) CoL - Section 5 - OD Usage.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-7015
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-04 to 2026-09
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Arranged and unarranged Personal Current Account (PCA) overdraft reliance.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-04' AND '2026-09'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  COUNTIF(o.arranged_od_drawn_gbp > 0) AS arranged_od_users,
  COUNTIF(o.unarranged_od_drawn_gbp > 0) AS unarranged_od_users,
  ROUND(SUM(o.arranged_od_drawn_gbp + o.unarranged_od_drawn_gbp), 2) AS total_od_balances_gbp
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section5_od_usage` AS o
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
