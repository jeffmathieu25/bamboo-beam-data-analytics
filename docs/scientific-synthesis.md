# Scientific synthesis

## Research problem

Selection among reinforcement configurations depends on the response variable and decision criterion. Mean recorded load, specimen variability, reported reinforcement cost, and a normalized weighted score answer distinct questions. This project evaluates those dimensions with a common specimen-level dataset while retaining test-specific comparison populations.

## Study design and analytical approach

The dataset contains 39 specimens across eight experimental groups and two test setups. Thirteen test–group combinations are observed, each with three specimens. The design is balanced within the observed combinations but incomplete across test setups. VCS, VB-IV, and VBC-II are available only in 4PT.

The workflow validates identifiers and measurement consistency, computes descriptive statistics, evaluates same-test reference contrasts, and calculates both direct load-to-cost ratios and explicit normalized decision scores. Pareto efficiency and weight sensitivity provide additional information about the candidate set. Python and SQLite implementations are reconciled numerically.

## Results and their interpretation

| Question | 3PT | 4PT |
|---|---|---|
| Highest observed group mean | VAB-III: 80.6837 kN | VA: 80.6398 kN |
| Highest bamboo-containing mean | VAB-III: 80.6837 kN | VB-III: 75.7945 kN |
| Highest bamboo-containing mean-load/mean-cost ratio | VAB-III: 4.6149 kN/BRL | VBC-II: 5.2142 kN/BRL |
| Highest equal-weight normalized candidate score | VAB-II: 0.6249 | VBC-II: 0.9198 |

The discrepancy between the 3PT ratio leader and equal-weight score leader is expected: the two rankings optimize different mathematical expressions. Neither criterion defines a universal engineering optimum.

In 4PT, candidate-only results must be interpreted alongside the VA reference. VBC-II's candidate ratio leadership coexists with a lower mean load and higher reported reinforcement cost than VA. The benchmark comparison is therefore essential to avoid equating relative candidate leadership with overall superiority.

## Statistical interpretation

Means, sample standard deviations, ranges, and coefficients of variation summarize the observed specimens. Error bars denote sample standard deviation rather than confidence intervals. The sample size does not support broad claims of population-level superiority from descriptive ranks alone. No p-values or significance claims are generated.

Differences across 3PT and 4PT are not interpreted as direct configuration effects. Loading geometry and protocol details are required for stress-based or structural comparisons. Recorded loads remain in kN throughout.

## Reproducibility and evidential limits

The CSV route was executed using the 39 specimens extracted from the supplied model. All 13 group summaries agree with the initial notebook's stored output at its displayed precision. Independent statistical and SQL calculations provide computational validation. They do not independently validate experimental measurement procedures.

The original Excel summary is unavailable to the CSV route; its check is explicitly not executed. The PDF contains six exported views of four report pages. Two documented editorial corrections affect the portfolio PDF labels and 4PT explanatory panel; source measurements and chart values are preserved.

## Conclusion

Configuration assessment is specific to test setup, reported cost basis, and decision criterion. The contribution is a traceable analytical framework that distinguishes mechanical descriptors, economic ratios, reference benchmarks, and explicit preference scenarios. Structural qualification and broader sustainability claims require additional evidence beyond this dataset.

## Collaborative context and access

The work forms part of collaborative research. Underlying observations remain restricted pending the associated scientific work; access conditions are specified in [Data availability](data-availability.md). Public numerical results are selected aggregate findings.
