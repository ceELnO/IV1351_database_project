/* --------------------------------- query 1: lesson per month ------------------------------------- */

WITH constants AS (
       SELECT 2023 AS desired_year
),
individual_lessons AS (
    SELECT EXTRACT(MONTH FROM individual_lesson_start_time) AS month, COUNT(*) AS count
    FROM individual_lesson
    WHERE EXTRACT(YEAR FROM individual_lesson_start_time) = (SELECT desired_year FROM constants)
    GROUP BY EXTRACT(MONTH FROM individual_lesson_start_time)
), 
group_lessons AS (
    SELECT EXTRACT(MONTH FROM group_lesson_start_time) AS month, COUNT(*) AS count
    FROM group_lesson
    WHERE EXTRACT(YEAR FROM group_lesson_start_time) = (SELECT desired_year FROM constants)
    GROUP BY EXTRACT(MONTH FROM group_lesson_start_time)
),
ensembles AS (
    SELECT EXTRACT(MONTH FROM ensemble_start_time) AS month, COUNT(*) AS count
    FROM ensemble
    WHERE EXTRACT(YEAR FROM ensemble_start_time) = (SELECT desired_year FROM constants)
    GROUP BY EXTRACT(MONTH FROM ensemble_start_time)
)
SELECT 
    COALESCE(i.month, g.month, e.month) AS month,
    COALESCE(i.count, 0) + COALESCE(g.count, 0) + COALESCE(e.count, 0) AS total,
    COALESCE(i.count, 0) AS individual_lessons,
    COALESCE(g.count, 0) AS group_lessons,
    COALESCE(e.count, 0) AS ensembles
FROM 
    individual_lessons i
FULL OUTER JOIN 
    group_lessons g ON i.month = g.month
FULL OUTER JOIN 
    ensembles e ON COALESCE(i.month, g.month) = e.month
ORDER BY 
    month;

/* --------------------------------- query 2: sibling count ------------------------------------- */

SELECT sibling_count, COUNT(*) AS student_count
FROM (
    SELECT student_sibling_group, COUNT(*) AS sibling_count
    FROM Student_sibling
    GROUP BY student_sibling_group
) AS counts
GROUP BY sibling_count
ORDER BY sibling_count;

/* --------------------------------- query 3: instructor lesson per month  ------------------------------------- */

-- query:

WITH constants AS (
	SELECT 
              2023 AS desired_year,
              7 AS desired_month, 
              0 AS desired_minimum_lesson
)
SELECT instructor_id_id, instructor_fname, instructor_lname, COUNT(*) AS lesson_count
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
LEFT JOIN Instructor ON instructor_id_id = Instructor.instructor_id
GROUP BY instructor_id_id, instructor_fname, instructor_lname
HAVING COUNT(*) > (SELECT desired_minimum_lesson FROM constants)
ORDER BY lesson_count DESC;


-- verify prior query:

WITH constants AS (
       SELECT 
              2023 AS desired_year, 
              7 AS desired_month, 
              0 AS desired_minimum_lesson
)
       SELECT instructor_id_id, individual_lesson_start_time 
       FROM Individual_lesson
       WHERE EXTRACT(MONTH FROM individual_lesson_start_time) = (SELECT desired_month FROM constants)
       AND EXTRACT(YEAR FROM individual_lesson_start_time) = (SELECT desired_year FROM constants)
UNION ALL
       SELECT instructor_id_id, group_lesson_start_time 
       FROM Group_lesson
       WHERE EXTRACT(MONTH FROM group_lesson_start_time) = (SELECT desired_month FROM constants)
       AND EXTRACT(YEAR FROM group_lesson_start_time) = (SELECT desired_year FROM constants)
UNION ALL
       SELECT instructor_id_id, ensemble_start_time 
       FROM Ensemble
       WHERE EXTRACT(MONTH FROM ensemble_start_time) = (SELECT desired_month FROM constants)
       AND EXTRACT(YEAR FROM ensemble_start_time) = (SELECT desired_year FROM constants)
ORDER BY instructor_id_id;


/* --------------------------------- query 4: ensembles next week ------------------------------------- */

-- query:

WITH constant AS(
	SELECT 8 AS desired_week
)
SELECT 
       TO_CHAR(e.ensemble_start_time, 'FMDay') AS day_of_week, 
	et.ensemble_type_name,
       CASE
              WHEN e.ensemble_max_students - COUNT(ee.ensemble_lesson_id_id) <= 0 THEN 'No seats'
              WHEN e.ensemble_max_students - COUNT(ee.ensemble_lesson_id_id) BETWEEN 1 AND 2 THEN '1 or 2 seats'
              ELSE 'Many seats'
       END AS remaining_slots
FROM Ensemble e
LEFT JOIN Ensemble_enrollment ee ON e.ensemble_id = ee.ensemble_lesson_id_id
LEFT JOIN Ensemble_type et ON e.ensemble_type_id_id = et.ensemble_type_id
WHERE DATE_PART('week', e.ensemble_start_time) = (SELECT desired_week FROM constant)
GROUP BY e.ensemble_start_time, e.ensemble_max_students, et.ensemble_type_name;

-- debugg:

WITH constant AS(
	SELECT 8 AS desired_week
)
SELECT
       e.ensemble_id,
       TO_CHAR(e.ensemble_start_time, 'FMDay') AS day_of_week,
	et.ensemble_type_name,
       (e.ensemble_max_students - COUNT(*)) AS remaining_slots
FROM Ensemble e
LEFT JOIN Ensemble_enrollment ee ON e.ensemble_id = ee.ensemble_lesson_id_id
LEFT JOIN Ensemble_type et ON e.ensemble_type_id_id = et.ensemble_type_id
WHERE DATE_PART('week', e.ensemble_start_time) = (SELECT desired_week FROM constant)
GROUP BY e.ensemble_start_time, e.ensemble_max_students, et.ensemble_type_name, e.ensemble_id;