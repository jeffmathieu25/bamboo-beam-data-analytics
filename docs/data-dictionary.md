# Data dictionary

The table below describes the restricted analytical schema; it does not distribute observations.

## Specimen-level fact table

| Field | Definition |
|---|---|
| `specimen_id` | Unique specimen identifier; primary analytical key. |
| `specimen_label` | Original specimen label. |
| `test_code` | 3PT or 4PT; separate comparison populations. |
| `group_name` | Recorded experimental group. |
| `test_number` | Key to test_setup. |
| `width_mm` | Recorded specimen width in mm. |
| `height_mm` | Recorded specimen height in mm. |
| `length_mm` | Recorded specimen length in mm; not an assumed support span. |
| `steel_ratio_pct` | Nominal steel percentage value. |
| `bamboo_ratio_pct` | Nominal bamboo percentage value. |
| `group_id` | Key to reinforcement_groups. |
| `load_id` | Recorded load-row identifier. |
| `flexural_load_kn` | Recorded flexural load in kN. |
| `cost_id` | Cost-row identifier. |
| `steel_ratio_pct_source` | Higher-precision percentage retained from cost source. |
| `bamboo_ratio_pct_source` | Bamboo percentage retained from cost source. |
| `cost_brl` | Reported reinforcement cost in BRL. |
| `is_reference` | 1 for VA or VCS; 0 for candidate groups. |
| `recorded_load_per_brl` | Per-specimen recorded load divided by reported cost. |

## Model relationships

| Dimension | Key | Fact key | Cardinality |
|---|---|---|---|
| `test_setup` | `test_number` | `test_number` | One to many |
| `reinforcement_groups` | `group_id` | `group_id` | One to many |

The test table provides test code, name and description. The group table provides group ID, group name, description and reference status. Filtering proceeds from dimensions to the fact table.

## Derived tables

`group_statistics` stores descriptive results per test–group combination. `reference_comparisons` stores same-test benchmark changes. `mcda_candidates` and `mcda_sensitivity` store decision scenarios. Quality, precision and independent-statistics exports document executed controls.
