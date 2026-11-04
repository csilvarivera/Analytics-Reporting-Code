/* ============================================================================
 * LLOYDS BANKING GROUP — CUSTOMER INSIGHTS & EXEC ANALYTICS (GCP BIGQUERY)
 * ============================================================================
 * @Script-Name     : <(N) Dashboard - Section Name.sql>
 * @Template-Ref    : templates/LBG_KC2_Approved_SQL_Template.sql (v2.4)
 * @Jira-Ticket     : <IPE-XXXX>
 * @Control-ID      : Risk: Analytics KC2 | Risk: LI - Confirmed
 * @Eye-Check-Tier  : <2-EYE | 4-EYE | 6-EYE>
 * @Reporting-Window: <YYYY-MM to YYYY-MM>
 * @Source-Dataset  : `csilva-sobi-demo.lbg_financial_resilience`
 * @Suppression-Rule: MANDATORY `c.is_suppressed = FALSE` (Deceased / Gone-Away / Legal Hold)
 * @Business-Purpose: <Clear plain-English explanation of business metric and downstream XLS/PBI tab>
 * ============================================================================ */

-- STEP 1: Filter eligible retail customer base applying Key Control KC2 suppression
WITH eligible_customers AS (
  SELECT
    c.reporting_month,
    c.customer_id,
    c.brand,
    c.segment,
    c.uk_region,
    c.resilience_tier
  FROM `csilva-sobi-demo.lbg_financial_resilience.col_customer_bases` AS c
  WHERE c.reporting_month BETWEEN 'YYYY-MM' AND 'YYYY-MM'
    AND c.is_suppressed = FALSE -- KC2-SUPP-01: Mandatory suppression of deceased/gone-away/legal-hold records
),

-- STEP 2: Join product domain table and document business threshold rationale
domain_metrics AS (
  SELECT
    e.reporting_month,
    e.segment,
    COUNT(DISTINCT e.customer_id) AS customer_count
  FROM eligible_customers AS e
  GROUP BY 1, 2
)

SELECT * FROM domain_metrics ORDER BY reporting_month, segment;
