# Power BI report notes

## Report structure

The original report has four logical pages: Overview, Mechanical Performance, Cost & Decision Analysis, and Insights & Conclusions. The supplied PDF contains six views: overall coverage; 3PT and 4PT mechanical performance; 3PT and 4PT cost analysis; and overall conclusions.

## Editorial corrections in the portfolio PDF

| Location | Supplied export | Portfolio PDF |
|---|---|---|
| Cost-analysis views, 4PT findings panel | Repeated the 3PT VAB-III findings. | Reports VB-III's 75.79 kN bamboo mean-load leadership and VBC-II's 5.21 kN/BRL bamboo ratio leadership at 74.11 kN mean load. |
| Cost-analysis KPI label | Cost Savings vs VA | Cost Change vs VA |

The cost measure computes (candidate cost − VA cost) / VA cost. Positive values therefore indicate higher reported cost, rather than savings. Values are retained; only the label changes. The PDF remains a static derivative of the supplied export. The original PBIX files were not modified or included in the portfolio.

## Interpretation of benchmark tables

The report's `Er vs VA (%)` column displays magnitudes of relative differences; the adjacent kN change column supplies direction. Portfolio tables and notebook reference comparisons use signed percentage changes. A positive reinforcement cost change is not a realized saving.

## DAX source

`powerbi/model-measures.dax` preserves the 50 measures extracted from the supplied model, including their original names. It is reference documentation, not one script for batch execution in the DAX formula bar. The original `Cost Savings vs VA` measure name is retained there for traceability even though the portfolio PDF uses the corrected label. Several measures require one selected test setup to avoid pooling 3PT and 4PT.
