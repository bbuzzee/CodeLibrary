-- !preview conn=DBI::dbConnect(RSQLite::SQLite())

-- This code chunk requires two datasets (COHORT and AP_NDC_LIST)
-- It restricts the COHORT to observations whos FIRST_NDC match one of the
-- top 3 NDC codes in AP_NDC_LIST

-- This is generalizable to the situation where you have a list of codes in one
-- data table and want to restrict another dataset to only those observations
-- that match one of those codes.

-- Further, by using the LIKE operator, we can search for codes that start or
-- end with certain sequences.

SELECT *
FROM COHORT AS A
INNER JOIN
  (SELECT TOP 3 NDC FROM AP_NDC_LIST) AS B
ON A.FIRST_NDC LIKE CONCAT(B.NDC, '%');
