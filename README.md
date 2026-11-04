# Customer-Insights / Analytics-Reporting-Code

**Lloyds Banking Group — CA: Exec Analytics, Products & GCP**  
Regulated BigQuery reporting repository (migrated from Teradata GDW to `csilva-sobi-demo.lbg_financial_resilience`).

## Regulated QA Governance (`Risk: Analytics KC2`)
Every monthly refresh or ad-hoc extract is governed by LBG's **2-4-6 Eye QA Framework**:

| Governance Tier | Distribution Scope | Required Reviewers & Evidence |
| :--- | :--- | :--- |
| **2-Eye Check** | Internal exploratory / team-only working cut | Analyst self-check against KC2 checklist |
| **4-Eye Check** | Internal Executive Dashboard / PowerBI (`PBI`) / internal `.xlsx` | Creator + 2nd Analyst Peer Code & Output Review |
| **6-Eye Check** | **External outputs** (Group Corporate Affairs `GCA` press quotes, Board Papers, Treasury/FCA packs) | Creator + 2nd Analyst Peer Review + 3rd Senior Sign-off + **Regulatory PDF Certificate & Merged PR Screenshot archived in SharePoint** |

### Mandatory QA Review Criteria
1. **2-4-6 Eye Escalation Check** based on whether the `.xlsx` output goes externally.
2. **Cross-Source Reconciliation** across BigQuery (`csilva-sobi-demo.lbg_financial_resilience`), SharePoint `.xlsx` output, Microsoft Teams stakeholder instructions, and Jira ticket scope.
3. **Key Controls (`KC2`)**: Mandatory `c.is_suppressed = FALSE` filter and exact reporting window alignment.
4. **Reuse of Approved Templates**: Every SQL file must carry the header in `templates/LBG_KC2_Approved_SQL_Template.sql`.
5. **Explainability of Code**: Named CTEs and explicit business comments explaining metric definitions and thresholds.
6. **Out of Scope**: **Do NOT critique or block code on SQL execution efficiency / slot or spool tuning.**
