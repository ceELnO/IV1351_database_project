/* --------------------------------- lesson per month ------------------------------------- */

WITH constants AS (
       SELECT 2023 AS desired_year
)
SELECT month, SUM(lesson_count) AS total_lessons
FROM (
    SELECT EXTRACT(MONTH FROM individual_lesson_start_time) AS month,
           COUNT(*) AS lesson_count
    FROM Individual_lesson
    WHERE EXTRACT(YEAR FROM individual_lesson_start_time) = (SELECT desired_year FROM constants)
    GROUP BY EXTRACT(MONTH FROM individual_lesson_start_time)
    UNION ALL
    SELECT EXTRACT(MONTH FROM group_lesson_start_time) AS month,
           COUNT(*) AS lesson_count
    FROM Group_lesson
    WHERE EXTRACT(YEAR FROM group_lesson_start_time) = (SELECT desired_year FROM constants)
    GROUP BY EXTRACT(MONTH FROM group_lesson_start_time)
    UNION ALL
    SELECT EXTRACT(MONTH FROM ensemble_start_time) AS month,
           COUNT(*) AS lesson_count
    FROM Ensemble
    WHERE EXTRACT(YEAR FROM ensemble_start_time) = (SELECT desired_year FROM constants)
    GROUP BY EXTRACT(MONTH FROM ensemble_start_time)
) AS subquery
GROUP BY month
ORDER BY month;


/* --------------------------------- sibling count ------------------------------------- */

SELECT sibling_count, COUNT(*) AS student_count
FROM (
    SELECT student_sibling_group, COUNT(*) AS sibling_count
    FROM Student_sibling
    GROUP BY student_sibling_group
) AS counts
GROUP BY sibling_count
ORDER BY sibling_count;


/* --------------------------------- instructor lesson per month  ------------------------------------- */

-- query
WITH constants AS (
	SELECT 
              (SELECT EXTRACT(YEAR FROM CURRENT_TIMESTAMP) AS current_year) AS desired_year,
              (SELECT EXTRACT(MONTH FROM CURRENT_TIMESTAMP) AS current_month) AS desired_month, 
              1 AS desired_minimum_lesson
)
SELECT instructor_id_id, COUNT(*) AS entry_count
FROM (
	SELECT instructor_id_id, individual_lesson_start_time FROM Individual_lesson
	WHERE EXTRACT(MONTH FROM individual_lesson_start_time) = (SELECT desired_month FROM constants)
	AND EXTRACT(YEAR FROM individual_lesson_start_time) = (SELECT desired_year FROM constants)
	UNION ALL
	SELECT instructor_id_id, group_lesson_start_time FROM Group_lesson
	WHERE EXTRACT(MONTH FROM group_lesson_start_time) = (SELECT desired_month FROM constants)
	AND EXTRACT(YEAR FROM group_lesson_start_time) = (SELECT desired_year FROM constants)
	UNION ALL
	SELECT instructor_id_id, ensemble_start_time FROM Ensemble
	WHERE EXTRACT(MONTH FROM ensemble_start_time) = (SELECT desired_month FROM constants)
	AND EXTRACT(YEAR FROM ensemble_start_time) = (SELECT desired_year FROM constants)
)
GROUP BY instructor_id_id
HAVING COUNT(*) > (SELECT desired_minimum_lesson FROM constants)
ORDER BY entry_count DESC;

-- verify
SELECT instructor_id_id, individual_lesson_start_time FROM Individual_lesson
UNION ALL
SELECT instructor_id_id, group_lesson_start_time FROM Group_lesson
UNION ALL
SELECT instructor_id_id, ensemble_start_time FROM Ensemble;



/* --------------------------------- ensembles next week ------------------------------------- */

WITH constant AS(
	SELECT 8 AS desired_week
)
SELECT -- e.ensemble_id,
       TO_CHAR(e.ensemble_start_time, 'FMDay') AS day_of_week, -- debugg: e.ensemble_start_time
	et.ensemble_type_name,
       (e.ensemble_max_students - COUNT(*)) AS remaining_slots
FROM Ensemble e
LEFT JOIN Ensemble_enrollment ee ON e.ensemble_id = ee.ensemble_lesson_id_id
LEFT JOIN Ensemble_type et ON e.ensemble_type_id_id = et.ensemble_type_id
WHERE DATE_PART('week', e.ensemble_start_time) = (SELECT desired_week FROM constant)
GROUP BY e.ensemble_start_time, e.ensemble_max_students, et.ensemble_type_name;


/* ------------------------------------ historical database --------------------------------- */

/* tba
SELECT 'individual', indv.
FROM Individual_lesson indv
*/

