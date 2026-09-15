-- ============================================
-- PROJECT:  Paitent Appointment No show Analysis
-- QUESTION: What factors are associated with higher patient no-show rates,
-- 			 and what low-cost interventions could reduce them?
-- SOURCE: KAGGLE Medical Appointment No Shows
create database MissedAppointments;
	select AVG(CASE WHEN noshow = 'yes' THEN 1.0 ELSE 0.0 END) * 100 AS yes_percentage 
from appointmentnoshows;

select AVG(CASE WHEN noshow = 'yes' THEN 1.0 ELSE 0.0 END) * 100 AS yes_percentage, AVG(CASE WHEN sms_received > 0 THEN 1.0 ELSE 0.0 END) * 100 AS sms_received_percentage, AVG(CASE WHEN sms_received = 0 THEN 1.0 ELSE 0.0 END) * 100 AS sms_notreceived_percentage 
from appointmentnoshows;

SELECT 
    CASE 
        WHEN WaitTimeDays = 0 THEN '01. Same-Day'
        WHEN WaitTimeDays BETWEEN 1 AND 7 THEN '02. 1-7 Days Out'
        WHEN WaitTimeDays BETWEEN 8 AND 14 THEN '03. 8-14 Days Out'
        ELSE '04. 15+ Days Out'
    END AS wait_time_bracket,
    
    
    COUNT(*) AS total_appointments,
    
    
    SUM(CASE WHEN `Noshow` = 'Yes' THEN 1 ELSE 0 END) AS no_show_count,
    
    
    ROUND(
        (SUM(CASE WHEN `Noshow` = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS no_show_rate_percentage

FROM appointmentnoshows
GROUP BY wait_time_bracket
ORDER BY wait_time_bracket;

SELECT 
    ROUND(SUM(CASE WHEN Diabetes = 1 AND Noshow = 'Yes' THEN 1 ELSE 0 END) * 100.0 
          / NULLIF(SUM(CASE WHEN Diabetes = 1 THEN 1 ELSE 0 END), 0), 2) AS diabetes_noshow_pct,
    ROUND(SUM(CASE WHEN Alcoholism = 1 AND Noshow = 'Yes' THEN 1 ELSE 0 END) * 100.0 
          / NULLIF(SUM(CASE WHEN Alcoholism = 1 THEN 1 ELSE 0 END), 0), 2) AS alcoholism_noshow_pct,
    ROUND(SUM(CASE WHEN Hypertension = 1 AND Noshow = 'Yes' THEN 1 ELSE 0 END) * 100.0 
          / NULLIF(SUM(CASE WHEN Hypertension = 1 THEN 1 ELSE 0 END), 0), 2) AS hypertension_noshow_pct,
    ROUND(SUM(CASE WHEN Handicap = 1 AND Noshow = 'Yes' THEN 1 ELSE 0 END) * 100.0 
          / NULLIF(SUM(CASE WHEN Handicap = 1 THEN 1 ELSE 0 END), 0), 2) AS handicap_noshow_pct
FROM appointmentnoshows;
