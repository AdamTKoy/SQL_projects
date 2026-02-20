-- This query is used to re-create our selection-level (just coding logic, no parts) Bill of Material viewer web app
-- since the web app is unable to retrieve orders older than 6 months (and is occasionally down)

WITH FG as (
  select
    t1.fetr_cd,
    t1.fetr_grp_cd,
    t1.text_60_desc,
    t1.data_vald_end_ts
  from TABLE1_NAME_REDACTED_FOR_SECURITY t1
  INNER JOIN (
    select fetr_cd, MAX(CAST(data_vald_end_ts as timestamp)) AS max_timestamp
    from TABLE2_NAME_REDACTED_FOR_SECURITY
    group by fetr_cd
  ) as t2
  on t1.fetr_cd = t2.fetr_cd and t1.data_vald_end_ts = t2.max_timestamp
)
select 
  FG.fetr_grp_cd as "Group",
  FAV.fetr_cd as "Feature",
  FG.text_60_desc as "Mfg Description",
  FAV.instal_draw_no as "Drawing",
  FAV.fetr_asmbly_no as "Assembly Num",
  FAV.asmbly_vartn_nos as "Variations",
  SEL.asmbly_grp_no as "Assembly Grp",
  AG.asmbly_grp_desc as "Assembly Description",
  INPT.fetr_cd_inpt_cd as "Input Code"
from
  TABLE3_NAME_REDACTED_FOR_SECURITY FAV
  join TABLE4_NAME_REDACTED_FOR_SECURITY JOB on FAV.ord_dte_key_job_srl_no = JOB.ord_dte_key_job_srl_no
  join FG on FAV.fetr_cd = FG.fetr_cd
  join TABLE5_NAME_REDACTED_FOR_SECURITY INPT
  on 
    FAV.ord_dte_key_job_srl_no = INPT.ord_dte_key_job_srl_no 
    and 
    FAV.fetr_cd = INPT.fetr_cd
    and
    FAV.job_no = INPT.job_no
  join TABLE6_NAME_REDACTED_FOR_SECURITY SEL on FAV.draw_asmbly_no = CONCAT(SEL.inst_no, SEL.asmbly_no)
  join TABLE7_NAME_REDACTED_FOR_SECURITY AG on SEL.asmbly_grp_no = AG.asmbly_grp_no
  where JOB.ord_no = "xxxxxx" and JOB.job_no = "xxxxxx" -- CHANGE THESE EACH TIME
  and AG.asmbly_grp_no like "%0" -- CVT config only shows AG for base rules
group by
  FG.fetr_grp_cd,
  FAV.fetr_cd,
  FG.text_60_desc,
  FAV.instal_draw_no,
  FAV.fetr_asmbly_no,
  FAV.asmbly_vartn_nos,
  SEL.asmbly_grp_no,
  AG.asmbly_grp_desc,
  INPT.fetr_cd_inpt_cd
order by
  FG.fetr_grp_cd,
  FAV.fetr_cd,
  FAV.instal_draw_no,
  FAV.fetr_asmbly_no
;
