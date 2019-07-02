
1.The (+) operator can be applied only to a column, not to an arbitrary expression. However, an arbitrary 
  expression can contain one or more columns marked with the (+) operator.
2.A WHERE condition containing the (+) operator cannot be combined with another condition using the OR logical operator.
3.A WHERE condition cannot use the IN comparison condition to compare a column marked with the (+) operator with an expression.
4.A WHERE condition cannot compare any column marked with the (+) operator with a subquery.

If the WHERE clause contains a condition that compares a column from table B with a constant
, then the (+) operator must be applied to the column so that Oracle returns the rows from table A for 
which it has generated nulls for this column. Otherwise Oracle returns only the results of a simple join.
================================================================================================================
SQL> SELECT * FROM TABLEONE;
----------------------------
 ID NAME
--- ------------------------
  1 ADARSH KUMAR
  2 RADHA SINGH
  3 AMIT KUMAR
  4 SONU SINGH
  5 MONU SINGH
  6 TABLEONE6
  7 TABLEONE7
  8 TABLEONE8
====================
8 rows selected.
================================================================================================================
SQL> SELECT * FROM TABLETWO;
----------------------------
 ID NAME
--- ------------------------
  1 ADARSH KUMAR
  2 RADHA SINGH
  3 AMIT KUMAR
  4 SONU SINGH
  5 MONU SINGH
  6 TABLETWO6
  7 TABLETWO7
  8 TABLETWO8
====================
8 rows selected.
================================================================================================================
SQL> SELECT * FROM TABLETHREE;
----------------------------
 ID NAME
--- --------------------------
  1 ADARSH KUMAR
  2 RADHA SINGH
  3 AMIT KUMAR
  4 SONU SINGH
  5 MONU SINGH
  6 TABLETHREE6
  7 TABLETHREE7
  8 TABLETHREE8
====================
8 rows selected.
================================================================================================================
RIGHT OUTER JOIN TWO TABLE
================================================================================================================
SELECT NVL(T1.ID,0) AS TABLEONE_ID ,NVL(T1.NAME,'NO DATA FOUND')AS TABLONE_NAME
      ,NVL(T2.ID,0)AS TABLETWO_ID,NVL(T2.NAME,'NO DATA FOUND')AS TABLETWO_NAME
FROM TABLEONE T1,TABLETWO T2
WHERE T1.NAME(+) =T2.NAME;
------------------------------------------------------------------------------------------
TABLEONE_ID TABLONE_NAME        TABLETWO_ID TABLETWO_NAME
----------- --------------------------------------------- ----------- --------------------
          1 ADARSH KUMAR        1 ADARSH KUMAR
          2 RADHA SINGH         2 RADHA SINGH
          3 AMIT KUMAR          3 AMIT KUMAR
          4 SONU SINGH          4 SONU SINGH
          5 MONU SINGH          5 MONU SINGH
          0 NO DATA FOUND       8 TABLETWO8
          0 NO DATA FOUND       7 TABLETWO7
          0 NO DATA FOUND       6 TABLETWO6
================================================================================================================
LEFT OUTER JOIN TWO TABLE
================================================================================================================
SELECT NVL(T1.ID,0) AS TABLEONE_ID ,NVL(T1.NAME,'NO DATA FOUND')AS TABLONE_NAME
      ,NVL(T2.ID,0)AS TABLETWO_ID,NVL(T2.NAME,'NO DATA FOUND')AS TABLETWO_NAME
FROM TABLETWO T2 ,TABLEONE T1
WHERE T2.NAME (+)=T1.NAME;
------------------------------------------------------------------------------------------
TABLEONE_ID TABLONE_NAME        TABLETWO_ID TABLETWO_NAME
----------- --------------------------------------------- ----------- -----------------
          1 ADARSH KUMAR         1 ADARSH KUMAR
          2 RADHA SINGH          2 RADHA SINGH
          3 AMIT KUMAR           3 AMIT KUMAR
          4 SONU SINGH           4 SONU SINGH
          5 MONU SINGH           5 MONU SINGH
          8 TABLEONE8            0 NO DATA FOUND
          7 TABLEONE7            0 NO DATA FOUND
          6 TABLEONE6            0 NO DATA FOUND
================================================================================================================
RIGHT OUTER JOIN THREE TABLE
================================================================================================================
SELECT NVL(T1.ID,0) AS TABLEONE_ID ,NVL(T1.NAME,'NO DATA FOUND')AS TABLONE_NAME
      ,NVL(T2.ID,0)AS TABLETWO_ID,NVL(T2.NAME,'NO DATA FOUND')AS TABLETWO_NAME
	  ,NVL(T3.ID,0)AS TABLETHREE_ID,NVL(T3.NAME,'NO DATA FOUND')AS TABLETHREE_NAME
FROM TABLEONE T1,TABLETWO T2,TABLETHREE T3
WHERE T1.NAME(+) = T2.NAME
  AND T2.NAME(+) = T3.NAME
  ORDER BY T1.ID;   
----------------------------------------------------------------------------------------------
TABLEONE_ID TABLONE_NAME   TABLETWO_ID TABLETWO_NAME  TABLETHREE_ID TABLETHREE_NAME
-------------------------------- ----------- ----------------- ------------- -----------------
          1 ADARSH KUMAR        1 ADARSH KUMAR           1 ADARSH KUMAR
          2 RADHA SINGH         2 RADHA SINGH            2 RADHA SINGH
          3 AMIT KUMAR          3 AMIT KUMAR             3 AMIT KUMAR
          4 SONU SINGH          4 SONU SINGH             4 SONU SINGH
          5 MONU SINGH          5 MONU SINGH             5 MONU SINGH
          0 NO DATA FOUND       0 NO DATA FOUND          6 TABLETHREE6
          0 NO DATA FOUND       0 NO DATA FOUND          7 TABLETHREE7
          0 NO DATA FOUND       0 NO DATA FOUND          8 TABLETHREE8
================================================================================================================
LEFT OUTER JOIN THREE TABLE
================================================================================================================
SELECT NVL(T1.ID,0) AS TABLEONE_ID ,NVL(T1.NAME,'NO DATA FOUND')AS TABLONE_NAME
      ,NVL(T2.ID,0)AS TABLETWO_ID,NVL(T2.NAME,'NO DATA FOUND')AS TABLETWO_NAME
	  ,NVL(T3.ID,0)AS TABLETHREE_ID,NVL(T3.NAME,'NO DATA FOUND')AS TABLETHREE_NAME
FROM TABLEONE T1,TABLETWO T2,TABLETHREE T3
WHERE T3.NAME (+)=T2.NAME
AND T2.NAME(+) =T1.NAME
ORDER BY T3.ID ;
----------------------------------------------------------------------------------------------
TABLEONE_ID TABLONE_NAME     TABLETWO_ID TABLETWO_NAME  TABLETHREE_ID TABLETHREE_NAME
----------- ------------------  ----------- ----------------- ------------- ------------------
          1 ADARSH KUMAR         1 ADARSH KUMAR            1 ADARSH KUMAR
          2 RADHA SINGH          2 RADHA SINGH             2 RADHA SINGH
          3 AMIT KUMAR           3 AMIT KUMAR              3 AMIT KUMAR
          4 SONU SINGH           4 SONU SINGH              4 SONU SINGH
          5 MONU SINGH           5 MONU SINGH              5 MONU SINGH
          6 TABLEONE6            0 NO DATA FOUND           0 NO DATA FOUND
          7 TABLEONE7            0 NO DATA FOUND           0 NO DATA FOUND
          8 TABLEONE8            0 NO DATA FOUND           0 NO DATA FOUND
================================================================================================================		  