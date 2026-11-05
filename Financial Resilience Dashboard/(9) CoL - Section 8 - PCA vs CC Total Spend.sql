/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : (9) CoL - Section 8 - PCA vs CC Total Spend.sql
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : IPE-7015
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : 6-EYE (Board & GCA Outputs)
 * @Reporting-Window: 2026-04 to 2026-09
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: Compares retail PCA debit card spend against Credit Card spend across the 6-month rolling window (Apr-26 to Sep-26).
 * ============================================================================ */

-- Business Logic Step 1: Build explicit 6-month calendar spine (Apr-26 to Sep-26) for Financial Resilience pack
WITH reporting_spine AS (
  SELECT month_key
  FROM UNNEST(['2026-04', '2026-05', '2026-06', '2026-07', '2026-08', '2026-09']) AS month_key
),

-- Business Logic Step 2: Filter active retail customers applying mandatory KC2 deceased/gone-away suppression
eligible_customers AS (
  SELECT
    c.reporting_month,
    c.customer_id,
    c.segment
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  CROSS JOIN reporting_spine AS sp
  WHERE c.reporting_month = sp.month_key
    AND c.is_suppressed = FALSE -- KC2-SUPP-01: Mandatory suppression control verified
),

-- Business Logic Step 3: Aggregate PCA debit vs Credit Card total spend in GBP for Board & GCA reporting
validated_spend_rollup AS (
  SELECT
    e.reporting_month,
    ROUND(SUM(s.pca_debit_card_spend_gbp), 2) AS pca_debit_spend_gbp,
    ROUND(SUM(s.credit_card_spend_gbp), 2) AS cc_spend_gbp,
    ROUND(SUM(s.total_card_spend_gbp), 2) AS total_spend_gbp
  FROM (SELECT * FROM eligible_customers ORDER BY reporting_month, customer_id) AS e
  JOIN `csilva-sobi-demo.lbg_financial_resilience.col_section8_pca_vs_cc_spend` AS s
    ON e.reporting_month = s.reporting_month
   AND e.customer_id = s.customer_id
  GROUP BY 1
)

SELECT
  reporting_month,
  pca_debit_spend_gbp,
  cc_spend_gbp,
  total_spend_gbp
FROM validated_spend_rollup
ORDER BY reporting_month;
