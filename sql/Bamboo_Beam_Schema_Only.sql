-- Analytical schema and views only. Research observations are not distributed.
PRAGMA foreign_keys=ON;

CREATE TABLE test_setup(test_number INTEGER PRIMARY KEY,test_code TEXT NOT NULL UNIQUE,test_name TEXT NOT NULL,description TEXT NOT NULL);
CREATE TABLE reinforcement_groups(group_id TEXT PRIMARY KEY,group_name TEXT NOT NULL UNIQUE,description TEXT NOT NULL,is_reference INTEGER NOT NULL CHECK(is_reference IN(0,1)));
CREATE TABLE specimens(specimen_id TEXT PRIMARY KEY,specimen_label TEXT NOT NULL UNIQUE,test_number INTEGER NOT NULL REFERENCES test_setup(test_number),group_id TEXT NOT NULL REFERENCES reinforcement_groups(group_id),width_mm REAL NOT NULL CHECK(width_mm>0),height_mm REAL NOT NULL CHECK(height_mm>0),length_mm REAL NOT NULL CHECK(length_mm>0),steel_ratio_pct REAL NOT NULL CHECK(steel_ratio_pct BETWEEN 0 AND 100),bamboo_ratio_pct REAL NOT NULL CHECK(bamboo_ratio_pct BETWEEN 0 AND 100));
CREATE TABLE flexural_results(load_id INTEGER PRIMARY KEY,specimen_id TEXT NOT NULL UNIQUE REFERENCES specimens(specimen_id),flexural_load_kn REAL NOT NULL CHECK(flexural_load_kn>0));
CREATE TABLE specimen_costs(cost_id INTEGER PRIMARY KEY,specimen_id TEXT NOT NULL UNIQUE REFERENCES specimens(specimen_id),steel_ratio_pct_source REAL NOT NULL,bamboo_ratio_pct_source REAL NOT NULL,cost_brl REAL NOT NULL CHECK(cost_brl>0));
CREATE TABLE source_flexural_summary(test_code TEXT NOT NULL REFERENCES test_setup(test_code),group_id TEXT NOT NULL REFERENCES reinforcement_groups(group_id),specimen_count INTEGER NOT NULL,mean_load_kn REAL NOT NULL,min_load_kn REAL NOT NULL,max_load_kn REAL NOT NULL,PRIMARY KEY(test_code,group_id));
CREATE TABLE analysis_settings(setting_id INTEGER PRIMARY KEY CHECK(setting_id=1),load_weight REAL NOT NULL CHECK(load_weight BETWEEN 0 AND 1));
CREATE TABLE mcda_weights(load_weight REAL PRIMARY KEY CHECK(load_weight BETWEEN 0 AND 1));
CREATE TABLE project_metadata(key TEXT PRIMARY KEY,value TEXT NOT NULL);


CREATE VIEW v_specimen_analysis AS
SELECT s.*,t.test_code,g.group_name,g.is_reference,r.flexural_load_kn,c.cost_brl,c.steel_ratio_pct_source,c.bamboo_ratio_pct_source,
       r.flexural_load_kn/c.cost_brl AS recorded_load_per_brl
FROM specimens s JOIN test_setup t ON t.test_number=s.test_number
JOIN reinforcement_groups g ON g.group_id=s.group_id
JOIN flexural_results r ON r.specimen_id=s.specimen_id
JOIN specimen_costs c ON c.specimen_id=s.specimen_id;
CREATE VIEW flexural_results_summary AS
WITH a AS (
SELECT test_code,group_id,group_name,is_reference,COUNT(*) AS n,AVG(flexural_load_kn) AS mean_load_kn,
 MIN(flexural_load_kn) AS min_load_kn,MAX(flexural_load_kn) AS max_load_kn,
 CASE WHEN COUNT(*)>1 THEN MAX(0.0,(SUM(flexural_load_kn*flexural_load_kn)-SUM(flexural_load_kn)*SUM(flexural_load_kn)/COUNT(*))/(COUNT(*)-1)) END AS sample_variance_kn2,
 AVG(cost_brl) AS mean_cost_brl,MIN(cost_brl) AS min_cost_brl,MAX(cost_brl) AS max_cost_brl
FROM v_specimen_analysis GROUP BY test_code,group_id,group_name,is_reference)
SELECT *,mean_load_kn/mean_cost_brl AS mean_load_per_mean_cost FROM a;
CREATE VIEW v_reference_comparisons AS
SELECT a.*,va.mean_load_kn AS va_mean_load_kn,vc.mean_load_kn AS vcs_mean_load_kn,
 100.0*(a.mean_load_kn/va.mean_load_kn-1) AS load_change_vs_va_pct,
 100.0*(a.mean_cost_brl/va.mean_cost_brl-1) AS cost_change_vs_va_pct,
 100.0*(a.mean_load_kn/vc.mean_load_kn-1) AS load_change_vs_vcs_pct
FROM flexural_results_summary a
LEFT JOIN flexural_results_summary va ON va.test_code=a.test_code AND va.group_name='VA'
LEFT JOIN flexural_results_summary vc ON vc.test_code=a.test_code AND vc.group_name='VCS';
CREATE VIEW v_mcda_normalized AS
WITH c AS(SELECT * FROM flexural_results_summary WHERE is_reference=0),
b AS(SELECT test_code,MIN(mean_load_kn) AS lo_load,MAX(mean_load_kn) AS hi_load,MIN(mean_cost_brl) AS lo_cost,MAX(mean_cost_brl) AS hi_cost FROM c GROUP BY test_code)
SELECT c.*,
 CASE WHEN b.hi_load=b.lo_load THEN 1.0 ELSE (c.mean_load_kn-b.lo_load)/(b.hi_load-b.lo_load) END AS normalized_load,
 CASE WHEN b.hi_cost=b.lo_cost THEN 1.0 ELSE (b.hi_cost-c.mean_cost_brl)/(b.hi_cost-b.lo_cost) END AS normalized_cost,
 CASE WHEN NOT EXISTS(SELECT 1 FROM c d WHERE d.test_code=c.test_code AND d.mean_cost_brl<=c.mean_cost_brl AND d.mean_load_kn>=c.mean_load_kn AND(d.mean_cost_brl<c.mean_cost_brl OR d.mean_load_kn>c.mean_load_kn)) THEN 1 ELSE 0 END AS pareto_efficient
FROM c JOIN b ON b.test_code=c.test_code;
CREATE VIEW v_mcda_scores AS
WITH scored AS(SELECT c.*,s.load_weight,1.0-s.load_weight AS cost_weight,
 c.normalized_load*s.load_weight+c.normalized_cost*(1.0-s.load_weight) AS score
FROM v_mcda_normalized c CROSS JOIN analysis_settings s)
SELECT *,RANK() OVER(PARTITION BY test_code ORDER BY score DESC) AS rank FROM scored;
CREATE VIEW v_mcda_sensitivity AS
WITH scored AS(SELECT c.test_code,c.group_name,w.load_weight,1.0-w.load_weight AS cost_weight,
 c.normalized_load*w.load_weight+c.normalized_cost*(1.0-w.load_weight) AS score
FROM v_mcda_normalized c CROSS JOIN mcda_weights w)
SELECT *,RANK() OVER(PARTITION BY test_code,load_weight ORDER BY score DESC) AS rank FROM scored;
CREATE VIEW v_summary_reconciliation AS
SELECT a.test_code,a.group_name,a.n,b.specimen_count,
 a.mean_load_kn-b.mean_load_kn AS mean_difference_kn,
 a.min_load_kn-b.min_load_kn AS min_difference_kn,
 a.max_load_kn-b.max_load_kn AS max_difference_kn
FROM flexural_results_summary a JOIN source_flexural_summary b ON b.test_code=a.test_code AND b.group_id=a.group_id;
