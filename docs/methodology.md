# Methodology and metric definitions

## Source and grain

The original workbook is organized into Test_setup, Reinforcement_Groups, Specimens, Flexural_Results, Specimen_Costs, and Flexural_Results_Summary. The restricted CSV input route uses tables exported from the supplied Power BI model: one specimen-level fact table and two reference tables. Model data preserve recorded measurements and reported reinforcement costs. The two supplied PBIX files have identical SHA-256 fingerprints.

Each analytical row represents one specimen. Identifiers establish one-to-one load and cost links; test and group keys establish many-to-one dimension relationships. The normalized SQL schema retains separate specimen, result and cost tables. The supplied model's denormalized fact table is an alternative input route, not an additional population.

## Data integrity

Checks cover required values, primary keys, specimen links, test-code consistency, positive dimensions, loads and costs, percentage bounds, label agreement, ratio precision, experimental inventory and joined-table grain. Nominal steel ratios are compared with source cost ratios within 0.005 percentage points; both precisions are retained. A value of 0.68 represents 0.68%, not 68%.

## Statistics

| Metric | Definition |
|---|---|
| Group mean load | Arithmetic mean of recorded kN loads within one test–group combination. |
| Sample SD | Square root of the sum of squared deviations divided by n−1. |
| CV (%) | 100 × sample SD / mean load. |
| Mean reinforcement cost | Arithmetic mean of reported BRL values within a test–group combination. |
| Load-to-cost ratio | Mean recorded load / mean reported reinforcement cost, in kN/BRL. |
| Load change vs VA (%) | 100 × (group mean load / same-test VA mean load − 1). |
| Cost change vs VA (%) | 100 × (group mean cost / same-test VA mean cost − 1). |

Unavailable test–group combinations remain unavailable. VCS is not present in 3PT. VA and VCS are references rather than candidate alternatives in the MCDA analysis.

## Multicriteria scenario

Within each setup, candidate loads receive min–max benefit scores. Costs receive reverse min–max scores so lower cost has a higher score. A constant criterion receives 1 for every candidate. The combined score is w × normalized load + (1−w) × normalized cost. The baseline is w=0.50, and sensitivity examines 11 load weights from 0 to 1. Ties retain equal rank.

Pareto efficiency is assessed among candidates within the same setup. A candidate is dominated when another offers at least the same mean load at no greater mean cost, with a strict improvement in either criterion. Candidate-set normalization means scores cannot be compared across test setups on a common scale.

The baseline represents an explicit scenario, not a universal optimum. Raw ratios and normalized weighted scores need not produce the same ranking. The Power BI report primarily communicates raw load/cost comparisons; the notebook adds the weighted-scenario analysis.

## Interpretation

Three specimens per cell support descriptive comparisons. Neither similar geometry nor nominal reinforcement ratios establish paired experiments or identical treatments. Species and treatment are not recorded as per-specimen fields. Reported reinforcement cost does not establish full beam, lifecycle or market cost. Load values are not converted to stress without protocol information.
