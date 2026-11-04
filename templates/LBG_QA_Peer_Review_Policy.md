# LBG Analytics Key Control 2 (`KC2`) Peer Review Policy

## 1. Eye-Check Determination Matrix
- **2-Eye Check**: Internal analyst sandbox or exploratory working file; does not leave the Analytics pod.
- **4-Eye Check**: Internal management dashboard or internal SharePoint `.xlsx` / PowerBI refresh.
- **6-Eye Check**: **Any `.xlsx` or soundbite shared externally** — including Group Corporate Affairs (`GCA`) media quotes, PLC Board Papers, Investor Relations, or FCA regulatory submissions. Requires PDF QA Certificate + GitHub PR Merge Screenshot uploaded to SharePoint and linked back to Jira.

## 2. Five Mandatory Checks (And One Explicit Exclusion)
1. **Cross-Source Verification**: Reconcile SQL logic against BigQuery source tables, the Analyst's exported `.xlsx` tabs, Jira acceptance criteria, and Microsoft Teams stakeholder threads.
2. **Key Control `KC2-SUPP-01`**: Every query against customer tables MUST join `col_customer_bases` with `c.is_suppressed = FALSE`.
3. **Key Control `KC2-WIN-02`**: Reporting month bounds must match the rolling window agreed with stakeholders (6 months `2026-04`..`2026-09` for September-26 CoL refresh).
4. **Template Reuse (`KC2-TMPL-03`)**: Must use `templates/LBG_KC2_Approved_SQL_Template.sql` metadata header and structured `eligible_customers` CTE.
5. **Explainability**: Every business threshold (e.g. `0.80` credit card high-utilisation stress threshold) must have an inline business comment.
6. **EXPLICIT EXCLUSION — Code Efficiency**: Reviewers **MUST NOT** evaluate, critique, or request changes regarding SQL performance, BigQuery slot consumption, Teradata legacy spool patterns, redundant CTE scans, or `CROSS JOIN` efficiency. Focus 100% on accuracy, governance controls, template reuse, and explainability.
