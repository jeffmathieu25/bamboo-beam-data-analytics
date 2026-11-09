-- BAMBOO BEAM EXPERIMENTAL ANALYSIS — ALL QUERIES USE RECORDED OBSERVATIONS
-- Q1. Experimental design and available test/group cells
SELECT test_code,group_name,COUNT(*) AS specimens FROM v_specimen_analysis GROUP BY test_code,group_name ORDER BY test_code,group_name;
-- Q2. Data completeness and valid relationships
PRAGMA integrity_check;
PRAGMA foreign_key_check;
SELECT COUNT(*) AS joined_specimens,COUNT(flexural_load_kn) AS loads,COUNT(cost_brl) AS costs FROM v_specimen_analysis;
-- Q3. Descriptive load statistics by test and reinforcement group
-- SQLite reports SAMPLE VARIANCE (kN squared); sample SD is its square root.
SELECT * FROM flexural_results_summary ORDER BY test_code,mean_load_kn DESC;
-- Q4. Recorded loads, nominal ratios, dimensions, and reported costs
SELECT * FROM v_specimen_analysis ORDER BY test_code,group_name,specimen_id;
-- Q5. Candidate cost/load trade-offs and Pareto efficiency (controls excluded)
SELECT test_code,group_name,mean_load_kn,mean_cost_brl,mean_load_per_mean_cost,pareto_efficient FROM v_mcda_normalized ORDER BY test_code,mean_cost_brl;
-- Q5b. Weighted ranking; default is 50% load and 50% cost
SELECT test_code,group_name,load_weight,cost_weight,normalized_load,normalized_cost,score,rank FROM v_mcda_scores ORDER BY test_code,rank,group_name;
-- Optional decision-weight scenario (inactive example).
-- UPDATE analysis_settings SET load_weight=0.70 WHERE setting_id=1;
-- COMMIT;
-- Baseline weight setting (inactive example):
-- UPDATE analysis_settings SET load_weight=0.50 WHERE setting_id=1;
-- COMMIT;
-- Q5c. Full 0-to-1 weight sensitivity; ties retain equal rank
SELECT * FROM v_mcda_sensitivity ORDER BY test_code,load_weight,rank,group_name;
-- Q6. Within-test comparison with VA and VCS; missing VCS in 3PT stays NULL
SELECT * FROM v_reference_comparisons ORDER BY test_code,group_name;
-- Q7. Recomputed vs workbook summary; all counts and differences should reconcile
SELECT *,CASE WHEN n=specimen_count AND ABS(mean_difference_kn)<1e-8 AND ABS(min_difference_kn)<1e-8 AND ABS(max_difference_kn)<1e-8 THEN 'OK' ELSE 'CHECK' END AS reconciliation FROM v_summary_reconciliation;
-- Q8. Detail table ready for dashboard exploration; do not pool test types
SELECT specimen_id,specimen_label,test_code,group_name,width_mm,height_mm,length_mm,steel_ratio_pct,bamboo_ratio_pct,flexural_load_kn,cost_brl,recorded_load_per_brl FROM v_specimen_analysis ORDER BY test_code,group_name,specimen_id;
-- Q9. Traceability and ratio rounding audit
SELECT specimen_id,steel_ratio_pct,steel_ratio_pct_source,steel_ratio_pct_source-steel_ratio_pct AS steel_delta_percentage_points,bamboo_ratio_pct,bamboo_ratio_pct_source FROM v_specimen_analysis ORDER BY specimen_id;
SELECT * FROM project_metadata ORDER BY key;
