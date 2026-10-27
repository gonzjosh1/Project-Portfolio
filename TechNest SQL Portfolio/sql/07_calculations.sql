-- ==================================================================
-- TechNest | 07 Calculations
-- ==================================================================

-- Expected results reflect the data as of late October 2026. Queries that
-- use CURDATE() or NOW() compare against today's date, so some results
-- shift over time (see "A note on dates" in the README).

USE technest;

-- ------------------------------------------------------------------
-- 1. Total PTO Check (Rule 12)
-- Question: Is anyone over the sick, vacation, personal, or 30-day total limits?
-- Expected: Every employee 'Within Limits'
-- ------------------------------------------------------------------
SELECT
    EmployeeID,
    FName AS `First Name`,
    LName AS `Last Name`,
    SickTime,
    VacationTime,
    PersonalTime,
    SickTime + VacationTime + PersonalTime AS TotalPTO,
    CASE
        WHEN SickTime > 9
          OR VacationTime > 14
          OR PersonalTime > 7
          OR SickTime + VacationTime + PersonalTime > 30
            THEN 'Violation'
        ELSE 'Within Limits'
    END AS PTOStatus
FROM employees
ORDER BY TotalPTO DESC, EmployeeID;

-- ------------------------------------------------------------------
-- 2. Minor Employment Check (Rule 15)
-- Question: Are any employees under 18 working more than part-time?
-- Expected: Employee 24 'Violation'. Employee 25 'Compliant'
-- ------------------------------------------------------------------
SELECT
    EmployeeID,
    FName AS `First Name`,
    LName AS `Last Name`,
    DOB,
    TIMESTAMPDIFF(YEAR, DOB, CURDATE()) AS Age,
    EmploymentType,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, DOB, CURDATE()) < 18
             AND EmploymentType <> 'Part-Time'
            THEN 'Violation'
        ELSE 'Compliant'
    END AS EmploymentStatus
FROM employees
ORDER BY Age, EmployeeID;
