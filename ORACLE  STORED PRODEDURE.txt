
CREATE TABLE  Employee (
  `EmpNo` integer(10),
  `EmpName` varchar(45) NOT NULL,
  `EmpEmail` varchar(30) NOT NULL,
  PRIMARY KEY (`EmpNo`)
) ;
--------------------------------------------------------------------------------------------------------------------------------------------------
 SET SERVEROUTPUT ON;
 DECLARE
   EMP_INSERT_MSG VARCHAR(50);
   EMP_INSERT_COUNT NUMBER(10) DEFAULT 0;
 BEGIN
   INSERT INTO EMPLOYEE(EMPNO,EMPNAME,EMPEMAIL)VALUES(&EMPNO,'&EMPNAME','&EMPEMAIL');
   EMP_INSERT_COUNT := SQL%ROWCOUNT;
    IF EMP_INSERT_COUNT >0 THEN
	     EMP_INSERT_MSG:='EMPLOYEE INSERT SUCCESSFUL '||EMP_INSERT_COUNT;
	   ELSE
	     EMP_INSERT_MSG:='EMPLOYEE NOT INSERT '||EMP_INSERT_COUNT;
	  END IF;
	COMMIT;
	DBMS_OUTPUT.PUT_LINE(EMP_INSERT_MSG);
 END;
 /
--------------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
 DECLARE
   V_EMP_DATA_CURSOR SYS_REFCURSOR;
   V_EMPNO EMPLOYEE.EMPNO%TYPE;
   V_EMPNAME EMPLOYEE.EMPNAME%TYPE;
   V_EMPEMAIL EMPLOYEE.EMPEMAIL%TYPE;
   V_SELECT_ERROR_MSG VARCHAR(50);
 BEGIN
      getEmpProcedure(&EMPNO,V_EMP_DATA_CURSOR,V_SELECT_ERROR_MSG);
	    IF V_SELECT_ERROR_MSG IS NULL THEN 
			 LOOP
				 FETCH V_EMP_DATA_CURSOR INTO V_EMPNO,V_EMPNAME,V_EMPEMAIL;
				 EXIT WHEN V_EMP_DATA_CURSOR%NOTFOUND;
				 DBMS_OUTPUT.PUT_LINE('EMPLOYEE DATA '||V_EMPNO||','||V_EMPNAME||','||V_EMPEMAIL);
			 END LOOP;
			 CLOSE V_EMP_DATA_CURSOR;
		ELSE
            DBMS_OUTPUT.PUT_LINE(V_SELECT_ERROR_MSG);
        END IF;	
 END;
 /
--------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE getEmpProcedure(V_EMP_NO IN EMPLOYEE.EMPNO%TYPE ,EMP_DATA_CURSOR OUT SYS_REFCURSOR,V_SELECT_ERROR_MSG OUT VARCHAR)
IS
BEGIN
    OPEN EMP_DATA_CURSOR FOR
    SELECT EMP.EMPNO,EMP.EMPNAME,EMP.EMPEMAIL FROM EMPLOYEE EMP WHERE EMP.EMPNO = V_EMP_NO;
	
	 IF EMP_DATA_CURSOR%NOTFOUND THEN
	      V_SELECT_ERROR_MSG :='NO EMPLOYEE FOUND FOR EMPNO '||V_EMP_NO;
	 END IF;  
	
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            RAISE_APPLICATION_ERROR(-20610,'NO EMPLOYEE FOUND');
          END;
        WHEN TOO_MANY_ROWS THEN
          BEGIN
            RAISE_APPLICATION_ERROR(-20612,'MORE THEN ONE EMPLOYEE FOUND FOR EMPNO '||V_EMP_NO);
          END;
        WHEN OTHERS THEN
		    RAISE_APPLICATION_ERROR(-20001, V_EMP_NO || ':$:' || SQLERRM, TRUE) ;
END getEmpProcedure;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
 DECLARE
   V_EMP_DATA_CURSOR SYS_REFCURSOR;
   V_EMPNO EMPLOYEE.EMPNO%TYPE;
   V_EMPNAME EMPLOYEE.EMPNAME%TYPE;
   V_EMPEMAIL EMPLOYEE.EMPEMAIL%TYPE;
   V_SELECT_ERROR_MSG VARCHAR(50);
 BEGIN
    getAllEmpProcedure(V_EMP_DATA_CURSOR,V_SELECT_ERROR_MSG);
	IF V_SELECT_ERROR_MSG IS NULL THEN
			 LOOP
				 FETCH V_EMP_DATA_CURSOR INTO V_EMPNO,V_EMPNAME,V_EMPEMAIL;
				 EXIT WHEN V_EMP_DATA_CURSOR%NOTFOUND;
				 DBMS_OUTPUT.PUT_LINE('EMPLOYEE DATA '||V_EMPNO||','||V_EMPNAME||','||V_EMPEMAIL);
			 END LOOP;
			 CLOSE V_EMP_DATA_CURSOR;
	ELSE
		DBMS_OUTPUT.PUT_LINE(V_SELECT_ERROR_MSG);
    END IF;	
 END;
 /
--------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE getAllEmpProcedure(EMP_ALL_DATA_CURSOR OUT SYS_REFCURSOR,V_SELECT_ERROR_MSG OUT VARCHAR)
IS
BEGIN
  OPEN EMP_ALL_DATA_CURSOR FOR
 
   SELECT EMP.EMPNO,EMP.EMPNAME,EMP.EMPEMAIL FROM EMPLOYEE EMP;
  
       IF EMP_ALL_DATA_CURSOR%NOTFOUND THEN
	      V_SELECT_ERROR_MSG :='NO EMPLOYEE FOUND ';
	   END IF;  
 
 EXCEPTION
      WHEN NO_DATA_FOUND THEN
          BEGIN
            V_SELECT_ERROR_MSG:='NO EMPLOYEE FOUND';
          END;
      WHEN OTHERS THEN
	      RAISE_APPLICATION_ERROR (-20001, 'EXCEPTION GENERATED :$:' || SQLERRM, TRUE) ;
END getAllEmpProcedure;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
   DATA VARCHAR(50) ;
BEGIN
insertEmpProcedure(&EMPNO,'&EMPNAME','&EMPEMAIL' ,DATA);
DBMS_OUTPUT.PUT_LINE(DATA);
END;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE insertEmpProcedure(
  V_EMPNO IN EMPLOYEE.EMPNO%TYPE
 ,V_EMPNAME IN EMPLOYEE.EMPNAME%TYPE
 ,V_EMPEMAIL IN EMPLOYEE.EMPEMAIL%TYPE
 ,V_EMP_INSERT_MSG OUT VARCHAR)
IS
  V_EMP_INSERT_COUNT NUMBER(10) DEFAULT 0;
BEGIN
	INSERT INTO EMPLOYEE (EMPNO,EMPNAME,EMPEMAIL) VALUES(V_EMPNO,V_EMPNAME,V_EMPEMAIL);
		   V_EMP_INSERT_COUNT := SQL%ROWCOUNT;
	
	   IF V_EMP_INSERT_COUNT >0 THEN
	       V_EMP_INSERT_MSG:='EMPLOYEE INSERT SUCCESSFUL '||V_EMP_INSERT_COUNT;
	   ELSE
	       V_EMP_INSERT_MSG:='EMPLOYEE NOT INSERT '||V_EMP_INSERT_COUNT;
	  END IF;
	  COMMIT;
	  
  EXCEPTION 
        WHEN OTHERS THEN RAISE_APPLICATION_ERROR (-20001, V_EMPNO ||':$:'||V_EMPNAME||':$:'||V_EMPEMAIL|| ':$:' ||SQLERRM, TRUE) ;
END insertEmpProcedure;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
   DATA VARCHAR(50) ;
BEGIN
updateEmpProcedure(&EMPNO,'&EMPNAME','&EMPEMAIL' ,DATA);
DBMS_OUTPUT.PUT_LINE(DATA);
END;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE updateEmpProcedure(
  V_EMPNO IN EMPLOYEE.EMPNO%TYPE
 ,V_EMPNAME IN EMPLOYEE.EMPNAME%TYPE
 ,V_EMPEMAIL IN EMPLOYEE.EMPEMAIL%TYPE
 ,V_EMP_UPDATE_MSG OUT VARCHAR)
IS
    V_EMP_UPDATE_COUNT NUMBER(10) DEFAULT 0;
BEGIN
	 UPDATE EMPLOYEE SET EMPNAME=V_EMPNAME, EMPEMAIL=V_EMPEMAIL WHERE EMPNO=V_EMPNO;
	 V_EMP_UPDATE_COUNT := SQL%ROWCOUNT;
	   IF V_EMP_UPDATE_COUNT >0 THEN
	     V_EMP_UPDATE_MSG:='EMPLOYEE UPDATED SUCCESSFUL '||V_EMP_UPDATE_COUNT;
	   ELSE
	     V_EMP_UPDATE_MSG:='EMPLOYEE NOT UPDATED '||V_EMP_UPDATE_COUNT;
	  END IF;
	COMMIT;
	EXCEPTION 
	      WHEN OTHERS THEN RAISE_APPLICATION_ERROR (-20001, V_EMPNO    || ':$:' || SQLERRM, TRUE);
COMMIT;
END updateEmpProcedure;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON;
DECLARE
   V_EMP_DEL_MSG VARCHAR(50) ;
BEGIN
	deleteEmpProcedure(&EMPNO,V_EMP_DEL_MSG);
	DBMS_OUTPUT.PUT_LINE(V_EMP_DEL_MSG);
END;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE deleteEmpProcedure(V_EMP_NO IN EMPLOYEE.EMPNO%TYPE,V_EMP_DEL_MSG OUT VARCHAR)
   IS
     V_EMP_DEL_COUNT NUMBER(10) DEFAULT 0;
   BEGIN
      DELETE FROM EMPLOYEE WHERE EMPNO = V_EMP_NO;
	         V_EMP_DEL_COUNT := SQL%ROWCOUNT;
	  IF V_EMP_DEL_COUNT >0 THEN
	     V_EMP_DEL_MSG:='EMPLOYEE DELETED SUCCESSFUL '||V_EMP_DEL_COUNT;
	  ELSE
	     V_EMP_DEL_MSG:='EMPLOYEE NOT DELETED '||V_EMP_DEL_COUNT;
	  END IF;	  
	  COMMIT;
	  
	  EXCEPTION 
	     WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20001, V_EMP_NO || ':$:' || SQLERRM, TRUE);
   END deleteEmpProcedure;
/
--------------------------------------------------------------------------------------------------------------------------------------------------
