-- ========================================== 
-- AI STUDENT IMPACT ANALYSIS PORTFOLIO PROJECT 
-- ========================================== 
 
-- ========================================== 
-- 1. DATA EXPLORATION 
-- ========================================== 
 
SELECT * 
FROM `ai_student_impact_dataset csv` 
LIMIT 10; 
 
SELECT 
COUNT(*) AS Total_Students 
FROM `ai_student_impact_dataset csv`; 
 
SELECT 
COUNT(DISTINCT Major_Category) AS Total_Majors 
FROM `ai_student_impact_dataset csv`; 
 
SELECT 
COUNT(DISTINCT Year_of_Study) AS Total_Study_Levels 
FROM `ai_student_impact_dataset csv`; 
 
-- ========================================== 
-- 2. KPI DASHBOARD 
-- ========================================== 
 
SELECT 
COUNT(*) AS Students, 
ROUND(AVG(Weekly_GenAI_Hours),2) AS Avg_AI_Hours, 
ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA),3) AS Avg_GPA_Improvement, 
ROUND(AVG(Anxiety_Level_During_Exams),2) AS Avg_Anxiety, 
ROUND(AVG(Skill_Retention_Score),2) AS Avg_Skill_Retention 
FROM `ai_student_impact_dataset csv`; 
 
-- ========================================== 
-- 3. DATA QUALITY CHECKS 
-- ========================================== 
 
SELECT 
COUNT(*) AS Total_Rows, 
COUNT(Weekly_GenAI_Hours) AS AI_Usage_Count, 
COUNT(Post_Semester_GPA) AS Post_GPA_Count, 
COUNT(Anxiety_Level_During_Exams) AS Anxiety_Count, 
COUNT(Skill_Retention_Score) AS Skill_Count 
FROM `ai_student_impact_dataset csv`; 
 
-- ========================================== 
-- 4. GPA PERFORMANCE ANALYSIS 
-- ========================================== 
 
SELECT 
Prompt_Engineering_Skill, 
COUNT(*) AS Students, 
ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA),3) AS Avg_GPA_Improvement, 
ROUND(MIN(Post_Semester_GPA - Pre_Semester_GPA),3) AS Lowest_Improvement, 
ROUND(MAX(Post_Semester_GPA - Pre_Semester_GPA),3) AS Highest_Improvement, 
ROUND(STDDEV(Post_Semester_GPA - Pre_Semester_GPA),3) AS GPA_Variability 
FROM `ai_student_impact_dataset csv` 
GROUP BY Prompt_Engineering_Skill 
ORDER BY Avg_GPA_Improvement DESC; 
 
SELECT 
Major_Category, 
ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA),3) AS Avg_GPA_Improvement 
FROM `ai_student_impact_dataset csv` 
GROUP BY Major_Category 
ORDER BY Avg_GPA_Improvement DESC; 
 
-- ========================================== 
-- 5. AI USAGE ANALYSIS 
-- ========================================== 
 
SELECT 
Year_of_Study, 
ROUND(AVG(Weekly_GenAI_Hours),2) AS Avg_AI_Hours 
FROM `ai_student_impact_dataset csv` 
GROUP BY Year_of_Study 
ORDER BY Avg_AI_Hours DESC; 
 
SELECT 
Primary_Use_Case, 
COUNT(*) AS Student_Count 
FROM `ai_student_impact_dataset csv` 
GROUP BY Primary_Use_Case 
ORDER BY Student_Count DESC; 
 
-- ========================================== 
-- 6. BURNOUT ANALYSIS 
-- ========================================== 
 
SELECT 
Burnout_Risk_Level, 
COUNT(*) AS Students 
FROM `ai_student_impact_dataset csv` 
GROUP BY Burnout_Risk_Level; 
 
SELECT 
Prompt_Engineering_Skill, 
ROUND( 
AVG( 
CASE 
WHEN Burnout_Risk_Level = ‘High’ 
THEN 1 
ELSE 0 
END 
) * 100, 2 
) AS Burnout_Percentage 
FROM `ai_student_impact_dataset csv` 
GROUP BY Prompt_Engineering_Skill; 
 
-- ========================================== 
-- 7. CONDITIONAL AGGREGATION 
-- ========================================== 
 
SELECT 
Major_Category, 
 
COUNT( 
CASE 
WHEN (Post_Semester_GPA - Pre_Semester_GPA) > 0.5 
THEN 1 
END 
) AS High_Performers, 
 
COUNT( 
CASE 
WHEN (Post_Semester_GPA - Pre_Semester_GPA) <= 0.5 
THEN 1 
END 
) AS Low_Performers 
 
FROM `ai_student_impact_dataset csv` 
GROUP BY Major_Category; 
 
-- ========================================== 
-- 8. WINDOW FUNCTIONS 
-- ========================================== 
 
SELECT 
Student_ID, 
(Post_Semester_GPA - Pre_Semester_GPA) AS GPA_Improvement, 
 
RANK() OVER( 
ORDER BY (Post_Semester_GPA - Pre_Semester_GPA) DESC 
) AS Student_Rank 
 
FROM `ai_student_impact_dataset csv`; 
 
SELECT 
Student_ID, 
Major_Category, 
(Post_Semester_GPA - Pre_Semester_GPA) AS GPA_Improvement, 
 
RANK() OVER( 
PARTITION BY Major_Category 
ORDER BY (Post_Semester_GPA - Pre_Semester_GPA) DESC 
) AS Major_Rank 
 
FROM `ai_student_impact_dataset csv`; 
 
SELECT 
Student_ID, 
Major_Category, 
(Post_Semester_GPA - Pre_Semester_GPA) AS GPA_Improvement, 
 
AVG(Post_Semester_GPA - Pre_Semester_GPA) 
OVER( 
PARTITION BY Major_Category 
) AS Major_Average 
 
FROM `ai_student_impact_dataset csv`; 
 
-- ========================================== 
-- 9. QUARTILE ANALYSIS 
-- ========================================== 
 
WITH AIQuartiles AS 
( 
SELECT *, 
NTILE(4) OVER( 
ORDER BY Weekly_GenAI_Hours DESC 
) AS Quartile 
FROM `ai_student_impact_dataset csv` 
) 
 
SELECT 
Quartile, 
ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA),3) AS Avg_GPA_Improvement, 
ROUND(AVG(Anxiety_Level_During_Exams),2) AS Avg_Anxiety 
FROM AIQuartiles 
GROUP BY Quartile; 
 
-- ========================================== 
-- 10. TOP PERFORMERS 
-- ========================================== 
 
WITH RankedStudents AS 
( 
SELECT 
Student_ID, 
Major_Category, 
(Post_Semester_GPA - Pre_Semester_GPA) AS GPA_Improvement, 
 
ROW_NUMBER() OVER( 
PARTITION BY Major_Category 
ORDER BY (Post_Semester_GPA - Pre_Semester_GPA) DESC 
) AS Position 
 
FROM `ai_student_impact_dataset csv` 
) 
 
SELECT * 
FROM RankedStudents 
WHERE Position <= 5; 
 
-- ========================================== 
-- 11. ABOVE AVERAGE STUDENTS 
-- ========================================== 
 
WITH AvgGPA AS 
( 
SELECT 
AVG(Post_Semester_GPA - Pre_Semester_GPA) AS Overall_Avg 
FROM `ai_student_impact_dataset csv` 
) 
 
SELECT * 
FROM `ai_student_impact_dataset csv` 
WHERE (Post_Semester_GPA - Pre_Semester_GPA) > 
( 
SELECT Overall_Avg 
FROM AvgGPA 
); 
 
-- ========================================== 
-- 12. EXECUTIVE SUMMARY 
-- ========================================== 
 
SELECT 
Major_Category, 
 
ROUND(AVG(Weekly_GenAI_Hours),2) AS Avg_AI_Hours, 
 
ROUND(AVG(Post_Semester_GPA - Pre_Semester_GPA),3) AS Avg_GPA_Improvement, 
 
ROUND(AVG(Anxiety_Level_During_Exams),2) AS Avg_Anxiety, 
 
ROUND(AVG(Skill_Retention_Score),2) AS Avg_Skill_Retention 
 
FROM `ai_student_impact_dataset csv` 
 
GROUP BY Major_Category 
 
ORDER BY Avg_GPA_Improvement DESC; 
