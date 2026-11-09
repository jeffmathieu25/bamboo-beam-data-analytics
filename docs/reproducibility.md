# Execution requirements and validation scope

## Restricted inputs

This public repository documents the analytical workflow without distributing the experimental data. Execution requires an authorized Excel workbook or the three authorized CSV input tables. Access conditions are stated in [Data availability](data-availability.md).

The Excel route expects the six-sheet input structure. `BAMBOO_INPUT_FILE` overrides the source path. The CSV route expects `fact_beam_analysis.csv`, `test_setup.csv`, and `reinforcement_groups.csv`; `BAMBOO_DATA_DIR` overrides their directory. Both input routes preserve recorded quantities. `BAMBOO_OUTPUT_DIR` controls generated outputs.

The notebook's source code and optional execution entry point remain available for methodological review. Cell outputs and execution counts are cleared in the public copy. There is no public specimen-level figure or populated database export.

## SQL distribution

`Bamboo_Beam_Schema_Only.sql` defines empty analytical tables and views. `Bamboo_Beam_Analysis_Queries.sql` documents analytical questions and requires an authorized populated database for execution. The complete populated SQL script is not distributed.

## Validation already performed

The analytical implementation was executed on the 39 specimen records in the supplied model. Thirteen group summaries agreed with stored numerical output at its displayed precision. Independent statistics, pandas–SQLite reconciliation, MCDA scores and ranks, Pareto flags, alternative weight settings, database integrity, and independent SQL initialization were checked.

Those checks were performed in the restricted working environment. The data needed to repeat them are not included in the public repository. The original Excel summary worksheet was unavailable to the CSV route, so that specific source-summary check was not executed.

## Public presentation

The PDF and six report images present selected aggregate results. The notebook includes method explanations and equations without stored experimental outputs. Disclosure of these aggregate results should follow the research collaborators' publication arrangements.
