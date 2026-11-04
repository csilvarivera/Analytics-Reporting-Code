/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (7) CoL - Section 6 - Unsecured Balances.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-7015
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-04 to 2026-09
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Total unsecured retail exposure combining revolving CC, overdraft, and personal loans.
 * ============================================================================ */

WITH eligible_customers AS (
  SELECT reporting_month, customer_id, segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN '2026-04' AND '2026-09'
    AND c.is_suppressed = FALSE
)
SELECT
  e.reporting_month,
  ROUND(SUM(b.cc_revolving_balance_gbp), 2) AS cc_revolving_gbp,
  ROUND(SUM(b.overdraft_total_gbp), 2) AS overdraft_gbp,
  ROUND(SUM(b.personal_loan_balance_gbp), 2) AS personal_loan_gbp,
  ROUND(SUM(b.total_unsecured_balance_gbp), 2) AS total_unsecured_gbp
FROM eligible_customers AS e
JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section6_unsecured_balances` AS b
  USING (reporting_month, customer_id)
GROUP BY 1
ORDER BY 1;
