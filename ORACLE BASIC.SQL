=================================================================================================================
/* ORACLE BLOCK EXAMPLE */
SET SERVEROUTPUT ON;
DECLARE 
 V_MSG VARCHAR2(50) DEFAULT ' ';
 V_VARIABLEONE NUMBER(3):=&V_VARIABLEONE;
 V_VAIABLETWO NUMBER(3) :=&V_VAIABLETWO;      
BEGIN
    V_MSG:='ADDITION OF THE INPUTED NUMBER IS '||(V_VARIABLEONE+V_VAIABLETWO);    	
    DBMS_OUTPUT.PUT_LINE(V_MSG); 
  EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,V_VARIABLEONE ||' '||V_VAIABLETWO|| ':$:' || SQLERRM, TRUE) ;	     
END;
/
=================================================================================================================
/* IF ELSE EXAMPLE */

SET SERVEROUTPUT ON;
DECLARE
    V_MSG VARCHAR2(50) DEFAULT ' ';
    V_NUMBER  NUMBER := &V_VARIABLE;
BEGIN							
            IF (V_NUMBER BETWEEN 10 AND 19) THEN 
	           V_MSG:='IN RANGE OF 10 T0 20 ';
			ELSIF (V_NUMBER BETWEEN 20 AND 29)  THEN 
			   V_MSG:='IN RANGE OF 20 T0 30 ';
			ELSIF (V_NUMBER BETWEEN 30 AND 39)  THEN 
		      V_MSG:='IN RANGE OF 30 T0 40 ';  
			ELSE 
			  V_MSG:='DATA NOT IN RANGE';  
			END IF;  
	DBMS_OUTPUT.PUT_LINE(V_MSG);		
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,':$:' || SQLERRM, TRUE) ;	
END;
/

=================================================================================================================
/* EVEN ODD NUMBER EXAMPLE */
SET SERVEROUTPUT ON;
DECLARE 
 V_MSG VARCHAR2(50) DEFAULT ' ';
 V_VARIABLE NUMBER(3):=&V_VARIABLEONE;
BEGIN
     IF MOD(V_VARIABLE,2)=0 THEN
         V_MSG:=(V_VARIABLE||' '||'Is Even Number!');
      ELSE
          V_MSG:=(V_VARIABLE||' '||'Is Odd Number!');
      END IF;    
    DBMS_OUTPUT.PUT_LINE(V_MSG); 
  EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,V_VARIABLE|| ':$:' || SQLERRM, TRUE) ;	     
END;
/
=================================================================================================================
/* PRIME NUMBER EXAMPLE */
SET SERVEROUTPUT ON;
DECLARE 
   V_MSG VARCHAR2(50) DEFAULT ' ';
   V_VARIABLE NUMBER:=&V_VARIABLE;
   V_COUNT NUMBER:=0;
BEGIN
		  FOR I IN 1..V_VARIABLE LOOP
				IF MOD(V_VARIABLE,I)=0 THEN
						V_COUNT:=V_COUNT+1;
				END IF;
		  END LOOP;
		  
		  IF V_COUNT<=2 THEN
			 V_MSG:=(V_VARIABLE||' ' ||'IS PRIME NUMBER');
		   ELSE
			 V_MSG:=(V_VARIABLE||' '||' IS NOT  PRIME NUMBER');
		  END IF;  
		
		  DBMS_OUTPUT.PUT_LINE(V_MSG);
   
   EXCEPTION
      WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20001,V_VARIABLE|| ':$:' || SQLERRM, TRUE) ;
END;
/
=================================================================================================================
/* FEBONASI SERIES EXAMPLE */
SET SERVEROUTPUT ON;
DECLARE
	RESULT NUMBER DEFAULT 1;
	previous NUMBER DEFAULT -1;
	V_SUM NUMBER;
	V_INDEX NUMBER;
	LOOP_LIMIT NUMBER := &LIMIT;
BEGIN
    FOR V_INDEX IN 1 .. LOOP_LIMIT LOOP
		V_SUM := RESULT + previous;
		previous := RESULT;
		RESULT := V_SUM;
		DBMS_OUTPUT.PUT_LINE(V_SUM);
	END LOOP;
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,LOOP_LIMIT|| ':$:' || SQLERRM, TRUE) ;	
END;
=================================================================================================================
/* FOR LOOP EXAMPLE */
SET SERVEROUTPUT ON;
DECLARE
    V_INDEX_LIMIT  NUMBER := &V_VARIABLE;
BEGIN
		FOR V_INDEX IN 1..V_INDEX_LIMIT LOOP
			 DBMS_OUTPUT.PUT_LINE(V_INDEX); 			 
		END LOOP;
		
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,V_INDEX_LIMIT|| ':$:' || SQLERRM, TRUE) ;	
END;
/
=================================================================================================================
/* FOR LOOP EXAMPLE */
SET SERVEROUTPUT ON;
DECLARE
    V_INDEX NUMBER :=0;
    V_INDEX_LIMIT  NUMBER := &V_VARIABLE;
BEGIN				
		WHILE V_INDEX < V_INDEX_LIMIT LOOP
			 DBMS_OUTPUT.PUT_LINE(V_INDEX); 
             V_INDEX:=V_INDEX+1;			 
		END LOOP;
		
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,V_INDEX_LIMIT|| ':$:' || SQLERRM, TRUE) ;	
END;
/	
=================================================================================================================
/* BASIC LOOP EXAMPLE  */
SET SERVEROUTPUT ON;
DECLARE
    V_INDEX NUMBER :=0;
    V_INDEX_LIMIT  NUMBER := &V_VARIABLE;
BEGIN								
		LOOP
		   DBMS_OUTPUT.PUT_LINE(V_INDEX); 	
           IF V_INDEX=V_INDEX_LIMIT THEN		   
		    EXIT; 		    
		   END IF;
		   V_INDEX:=V_INDEX+1;
		 END LOOP;
		
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,V_INDEX_LIMIT|| ':$:' || SQLERRM, TRUE) ;	
END;
/	
=================================================================================================================
/* SWITCH CASE STATEMENT */
SET SERVEROUTPUT ON;
DECLARE
    V_MSG VARCHAR2(50) DEFAULT ' ';
    V_NUMBER  NUMBER := &V_VARIABLE;
BEGIN						
	
    V_MSG :=CASE V_NUMBER
	           WHEN 10 THEN 'TEN'
			   WHEN 20 THEN 'TWENTY'
			   WHEN 30 THEN 'THRITY'
               WHEN 40 THEN 'FOURTY'
               WHEN 50 THEN 'FIFTY'
		       ELSE 'NOT MATCHED'
			END;  
	DBMS_OUTPUT.PUT_LINE(V_MSG);		
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,':$:' || SQLERRM, TRUE) ;	
END;
/	
------------------------------------------------------------------
/* SWITCH CASE STATEMENT */
SET SERVEROUTPUT ON;
DECLARE
    V_MSG VARCHAR2(50) DEFAULT ' ';
    V_NUMBER  NUMBER := &V_VARIABLE;
BEGIN						
	
    V_MSG :=CASE 
	           WHEN V_NUMBER BETWEEN 10 AND 19 THEN 'IN RANGE OF 10 T0 20 '
			   WHEN V_NUMBER BETWEEN 20 AND 29  THEN 'IN RANGE OF 20 T0 30 '
			   WHEN V_NUMBER BETWEEN 30 AND 39  THEN 'IN RANGE OF 30 T0 40 '              
		       ELSE 'NOT MATCHED'
			END;  
	DBMS_OUTPUT.PUT_LINE(V_MSG);		
	EXCEPTION
      WHEN OTHERS THEN
		   RAISE_APPLICATION_ERROR(-20001,':$:' || SQLERRM, TRUE) ;	
END;
/
=================================================================================================================


=================================================================================================================