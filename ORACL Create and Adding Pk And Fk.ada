/* LIST THE TABLE NAMES */
SELECT OWNER ,TABLE_NAME 
FROM [DBA_TABLE | ALL_TABLES] ;
OR
SELECT TABLE_NAME 
FROM  USER_TABLES;


/* SELECTING THE CONSTRIANTS FOR THE TABLE */
SELECT OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME,STATUS 
FROM DBA_CONSTRAINTS
WHERE TABLE_NAME='&TABLENAME';
OR
SELECT OWNER,CONSTRAINT_NAME,CONSTRAINT_TYPE,TABLE_NAME,STATUS 
FROM USER_CONSTRAINTS
WHERE TABLE_NAME='&TABLENAME';

/* DESABLING AND ENABLING THE CONSTRAINTS */

ALTER TABLE <TABLE_NAME>
ENABLE CONSTRAINT<CONSTRAINT_NAME>;

ALTER TABLE <TABLE_NAME>
DISABLE CONSTRAINT<CONSTRAINT_NAME>;

/*
=============================================TABLE CREATION=======================================
=========================================COLUMN LEVEL CONSTRAINT =================================
==================================================================================================
***************************************CREATING TABLE ADDRESS ************************************
---------------------------------------------------------------------------------------------------
*/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Address';
   EXCEPTION 
       WHEN OTHERS THEN
				  IF SQLCODE != -942 THEN
					 RAISE;
				  END IF;
END;

CREATE TABLE Address(
      Address_Id NUMBER(3) NOT NULL 
	  CONSTRAINT Address_Pk_addr_id PRIMARY KEY  
    , Street_Address VARCHAR2(40)
    , Postal_Code    VARCHAR2(12)
    , City       VARCHAR2(30) NOT NULL 
    , State_Province VARCHAR2(25)
    , Country     VARCHAR2(20)
	    CONSTRAINT Address_Unq_county UNIQUE  
) ;

/*
---------------------------------------------------------------------------------------------------
************************************ADDING CONSTRAINT AND KEYS TO ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
DROP INDEX Index_city;

/*
---------------------------------------------------------------------------------------------------
*********************************DROPPING CONSTRAINT AND KEYS FROM ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER TABLE Address 
DROP CONSTRAINT Address_Pk_addr_id ;

/* removing not null */
ALTER TABLE Address 
MODIFY (City VARCHAR2(30) NULL);

/* dropping unique constraint */
ALTER TABLE Address 
DROP CONSTRAINT Address_Unq_county;

/* dropping table */
DROP TABLE Address;
/*
===================================================================================================
************************************CREATING TABLE DEPARTMENT************************************
---------------------------------------------------------------------------------------------------
*/

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE Department';
   EXCEPTION 
       WHEN OTHERS THEN
				  IF SQLCODE != -942 THEN
					 RAISE;
				  END IF;
END;


CREATE TABLE Department(
	Department_Id NUMBER(3) NOT NULL 
		CONSTRAINT Department_pk_dept_id PRIMARY KEY
   ,Department_Name VARCHAR2(20) NOT NULL
   ,Department_Location NUMBER(3) DEFAULT NULL 
		CONSTRAINT  Department_Fk_dept_loc_addr_id 	
		REFERENCES Address(Address_Id)
        ON DELETE CASCADE 
   ,Department_Code VARCHAR2(10)
		CONSTRAINT Department_Unq_dept_code UNIQUE
   ,Manager_Id NUMBER(3) DEFAULT NULL       
);

/*
---------------------------------------------------------------------------------------------------
*********************************ADDING CONSTRAINT AND KEYS TO DEPARTMENT**************************
---------------------------------------------------------------------------------------------------
*/

/* creating index */
CREATE INDEX Index_Department_Name 
ON Department(Department_Name);

/* dropping unique constraint */
DROP INDEX Index_Department_Name;

/*
---------------------------------------------------------------------------------------------------
***************************DROPPING CONSTRAINT AND KEYS FROM DEPARTMENT****************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Department 
DROP CONSTRAINT Department_pk_dept_id;

/* removing not null */
ALTER TABLE Department 
MODIFY (Department_Name VARCHAR(20) NULL);

/* removing forigen key */
ALTER TABLE Department
DROP CONSTRAINT Department_Fk_dept_loc_addr_id;

/* removing unidque key */
ALTER TABLE Department
DROP CONSTRAINT Department_Unq_dept_code;

/* dropping table */
DROP TABLE Department;

/*
==================================================================================================
***************************************CREATING TABLE EMPLOYEE************************************
---------------------------------------------------------------------------------------------------
*/
DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee(
	Employee_Id NUMBER(3)
	   CONSTRAINT Employee_pk_emp_id PRIMARY KEY 
	,First_Name VARCHAR2(20)  NOT NULL
	,Middle_Name VARCHAR2(20) DEFAULT NULL
	,Last_Name VARCHAR2(20)  NOT NULL
	,Emp_Gender VARCHAR2(6) NOT NULL 
	  CONSTRAINT Employee_Chk_emp_gender 
	  CHECK(Emp_Gender IN('Male', 'Female'))
	,Hire_Date DATE  NOT NULL
	,Emp_Phone VARCHAR2(10)DEFAULT NULL 
	,Emp_Email VARCHAR2(30) NOT NULL 
	    CONSTRAINT Employee_Unq_emp_email UNIQUE
	,Emp_Salary NUMBER(8,2) DEFAULT NULL
	,Emp_Comm NUMBER(8,2) DEFAULT NULL	
	,Emp_Mgr NUMBER(3) DEFAULT NULL
		CONSTRAINT Employee_Fk_emp_mgr_emp_id 
		REFERENCES Employee(Employee_Id)
	,Emp_Dept NUMBER(3) DEFAULT NULL
	   CONSTRAINT Employee_Fk_emp_dept_dept_id 
	   REFERENCES Department(Department_Id)
	   ON DELETE SET NULL
	,Emp_Address NUMBER(3)
       CONSTRAINT Employee_Fk_emp_addr_addr_id 
	   REFERENCES Address(Address_Id)
 ); 
 
/*
---------------------------------------------------------------------------------------------------
******************************ADDING CONSTRAINT AND KEYS TO EMPLOYOEE******************************
---------------------------------------------------------------------------------------------------
*/

 /* creating index */
CREATE INDEX Index_First_Name 
ON Employee(First_Name);

/* dropping unique constraint */
DROP INDEX Index_First_Name;

/*
---------------------------------------------------------------------------------------------------
****************************DROPPING CONSTRAINT AND KEYS FROM EMPLOYOEE****************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employee 
DROP CONSTRAINT Employee_pk_emp_id;

/* removing not null */
ALTER TABLE Employee 
MODIFY (Last_Name VARCHAR(20) NULL);


/* removing forigen key */
ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_mgr_emp_id;

ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_dept_dept_id;

ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_addr_addr_id;

/* removing unique key */
ALTER Table Employee 
DROP CONSTRAINT Employee_Unq_emp_email;

/* deletting the unique constraint */
ALTER Table Employee 
DROP CONSTRAINT Employee_Unq_emp_email;


/* dropping table */
DROP TABLE Employee;

/*
===================================================================================================
************************************CREATING TABLE EDUCATION **************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Education(
	Education_Id NUMBER(3) 
	    CONSTRAINT Education_Pk_education_id PRIMARY KEY 
	,High_School VARCHAR2(50)  NOT NULL
	,Intermediate VARCHAR2(50) NOT NULL
	,Graduaction VARCHAR2(50)  NULL
	,Post_Graduation VARCHAR2(50)DEFAULT NULL
	,Emp_Id NUMBER(3)CONSTRAINT Education_Fk_emp_id_emp_id 
	     REFERENCES Employee(Employee_Id)
	    ON DELETE CASCADE
 );
 
/*
---------------------------------------------------------------------------------------------------
****************************ADDING CONSTRAINT AND KEYS TO EDUCATION********************************
---------------------------------------------------------------------------------------------------
*/
 
/* creating index */
CREATE INDEX Index_Graduaction 
ON Education(Graduaction);

/* dropping unique constraint */
DROP INDEX Index_Graduaction;

/*
---------------------------------------------------------------------------------------------------
****************************DROPPING CONSTRAINT AND KEYS FROM EDUCATION****************************
---------------------------------------------------------------------------------------------------
*/
 
 /* removing primary key */
ALTER Table Education 
DROP CONSTRAINT Education_Pk_education_id ;

/* removing not null */
ALTER TABLE Education 
MODIFY (Intermediate VARCHAR(50) NULL);

/* removing default value */
ALTER TABLE Education
MODIFY ( Post_Graduation VARCHAR2(50));

/* removing forigen key */
ALTER TABLE Education
DROP FOREIGN KEY Education_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Education;
 
/*
===================================================================================================
**********************************CREATING TABLE EMPOLYMENT_HISTROY********************************
---------------------------------------------------------------------------------------------------
*/


CREATE TABLE Employment_History(
	 Employment_id NUMBER(3) 
		CONSTRAINT Employ_Hist_pk_employ_id PRIMARY KEY
	,Company_Name VARCHAR2(50) DEFAULT NULL
	,Company_Location NUMBER(3) NOT NULL
	    CONSTRAINT Employ_Hist_Fk_coy_loc_addr_id 
	    REFERENCES Address(Address_Id)
	    ON DELETE CASCADE 
	,Company_Phone VARCHAR2(12) NOT NULL
		CONSTRAINT Employ_Hist_Unq_Coy_Phone UNIQUE 
	,Emp_Id NUMBER(3)
        CONSTRAINT Employ_Hist_Fk_emp_id_emp_id 
	    REFERENCES Employee(Employee_Id)
	    ON DELETE CASCADE
 );
 
/*
---------------------------------------------------------------------------------------------------
************************ADDING CONSTRAINT AND KEYS TO EMPOLYMENT_HISTROY***************************
---------------------------------------------------------------------------------------------------
*/ 
 /* creating index */
CREATE INDEX Index_Company_Name 
ON Employment_History(Company_Name);

/* dropping unique constraint */
DROP INDEX Index_Company_Name;

/*
---------------------------------------------------------------------------------------------------
*********************DROPPING CONSTRAINT AND KEYS FROM EMPOLYMENT_HISTROY**************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_pk_employ_id;

/* removing not null */
ALTER TABLE Employment_History 
MODIFY (Company_Location NUMBER(3) NULL);

/* dropping unique constraint */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Unq_Coy_Phone;

/* removing forigen key */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Fk_coy_loc_addr_id;

ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Employment_History;

/*
===================================================================================================
========================================TABLE LEVEL CONSTRAINT=====================================
*****************************************CREATING TABLE *******************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Address(
      Address_Id NUMBER(3) NOT NULL
    , Street_Address VARCHAR2(40)
    , Postal_Code    VARCHAR2(12)
    , City       VARCHAR2(30) NOT NULL
    , State_Province VARCHAR2(25)
    , Country     VARCHAR2(20)
    ,CONSTRAINT   Address_Pk_addr_id PRIMARY KEY(Address_Id)
	,CONSTRAINT Address_Unq_country UNIQUE(Country)
) ;

/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
DROP INDEX Index_city;

/*
---------------------------------------------------------------------------------------------------
************************************DROPPING CONSTRAINT AND KEYS **********************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER TABLE Address 
DROP CONSTRAINT Address_Pk_addr_id ;

/* removing not null */
ALTER TABLE Address 
MODIFY (City VARCHAR2(30) NULL);

/* dropping unique constraint */
ALTER TABLE Address 
DROP CONSTRAINT Address_Unq_county;

/* dropping table */
DROP TABLE Address;

/*
===================================================================================================
************************************CREATING TABLE ************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Department(
	 Department_Id NUMBER(3) NOT NULL
	,Department_Name VARCHAR2(20) NOT NULL
	,Department_Code VARCHAR2(10) 
	,Department_location NUMBER(3) DEFAULT NULL
	,Manager_id NUMBER(3) DEFAULT NULL
      ,CONSTRAINT Department_pk_dept_id 
	             PRIMARY KEY(Department_Id)
     ,CONSTRAINT Department_Unq_dept_code 
                 UNIQUE(Department_Code)
     ,CONSTRAINT Department_Fk_dept_loc_addr_id 
	             FOREIGN KEY(Department_location) 
				 REFERENCES Address(Address_Id)
	             ON DELETE CASCADE
);

/* creating index */
CREATE INDEX Index_Department_Name 
ON Department(Department_Name);

/* dropping unique constraint */
DROP INDEX Index_Department_Name;

/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Department 
DROP CONSTRAINT Department_pk_dept_id;

/* removing not null */
ALTER TABLE Department 
MODIFY(Department_Name VARCHAR(20) NULL);

/* removing forigen key */
ALTER TABLE Department
DROP CONSTRAINT Department_Fk_dept_loc_addr_id;

/* removing unidque key */
ALTER TABLE Department
DROP CONSTRAINT Department_Unq_dept_code;

/* dropping table */
DROP TABLE Department;

/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Employee(
	Employee_Id NUMBER(3)
	,First_Name VARCHAR2(20)  NOT NULL
	,Middle_Name VARCHAR2(20) DEFAULT NULL
	,Last_Name VARCHAR2(20)  NOT NULL
	,Emp_Gender VARCHAR2(6) NOT NULL
	,Hire_Date DATE  NOT NULL
	,Emp_Phone VARCHAR2(10)DEFAULT NULL 
	,Emp_Email VARCHAR2(30) NOT NULL 
	,Emp_Salary  NUMBER(8,2)  DEFAULT NULL
	,Emp_Comm NUMBER(8,2) DEFAULT NULL
	,Emp_Mgr NUMBER(3) DEFAULT NULL
	,Emp_Dept NUMBER(3) DEFAULT NULL
	,Emp_Address NUMBER(3)
  ,CONSTRAINT Employee_pk_emp_id 
	PRIMARY KEY(Employee_Id)
  ,CONSTRAINT Employee_Chk_emp_gender
    CHECK(Emp_Gender IN('Male', 'Female'))
  ,CONSTRAINT Employee_Unq_emp_email
    UNIQUE(Emp_Email)
  ,CONSTRAINT Employee_Fk_emp_mgr_emp_id 
	FOREIGN KEY(Emp_Mgr) REFERENCES Employee(Employee_Id)
  ,CONSTRAINT Employee_Fk_emp_dept_dept_id 
	FOREIGN KEY(Emp_Dept) REFERENCES Department(Department_Id)
	 ON DELETE SET NULL
  ,CONSTRAINT Employee_Fk_emp_addr_addr_id 
	FOREIGN KEY(Emp_Address) REFERENCES Address(Address_Id)
 );
 
 /* creating index */
CREATE INDEX Index_First_Name 
ON Employee(First_Name);

/* dropping unique constraint */
DROP INDEX Index_First_Name;
/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employee 
DROP CONSTRAINT Employee_pk_emp_id;

/* removing not null */
ALTER TABLE Employee 
MODIFY (Last_Name VARCHAR(20) NULL);


/* removing forigen key */
ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_mgr_emp_id;

ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_dept_dept_id;

ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_addr_addr_id;

/* removing unique key */
ALTER Table Employee 
DROP CONSTRAINT Employee_Unq_emp_email;

/* deletting the unique constraint */
ALTER Table Employee 
DROP CONSTRAINT Employee_Unq_emp_email;

/* dropping table */
DROP TABLE Employee;

/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Education(
	Education_Id NUMBER(3)
	,High_School VARCHAR2(50) DEFAULT NULL
	,Intermediate VARCHAR2(50)DEFAULT NULL
	,Graducation VARCHAR2(50) DEFAULT NULL
	,Post_Graduation VARCHAR2(50) NULL
	,Emp_Id NUMBER(3)
  ,CONSTRAINT Education_Pk_education_id 
	PRIMARY KEY(Education_Id)
  ,CONSTRAINT Education_Fk_emp_id_emp_id 
	FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_Id)
	ON DELETE CASCADE
 );
 
 ---------------------------------------------------------------------------------------------------
****************************ADDING CONSTRAINT AND KEYS TO EDUCATION********************************
---------------------------------------------------------------------------------------------------
*/
 
/* creating index */
CREATE INDEX Index_Graduaction 
ON Education(Graduaction);

/* dropping unique constraint */
DROP INDEX Index_Graduaction;

/*
---------------------------------------------------------------------------------------------------
****************************DROPPING CONSTRAINT AND KEYS FROM EDUCATION****************************
---------------------------------------------------------------------------------------------------
*/
 
 /* removing primary key */
ALTER Table Education 
DROP CONSTRAINT Education_Pk_education_id ;

/* removing not null */
ALTER TABLE Education 
MODIFY (Intermediate VARCHAR(50) NULL);

/* removing default value */
ALTER TABLE Education
MODIFY ( Post_Graduation VARCHAR2(50));

/* removing forigen key */
ALTER TABLE Education
DROP FOREIGN KEY Education_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Education;
/*
===================================================================================================
CREATING TABLE 
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Employment_History(
	Employment_id NUMBER(3)
	,Company_Name VARCHAR2(50) DEFAULT NULL
	,Company_Location NUMBER(3)  NOT NULL
	,Company_Phone VARCHAR2(12)NOT NULL
	,Emp_Id NUMBER(3)
  ,CONSTRAINT Employ_Hist_pk_employ_id
	PRIMARY KEY(Employment_Id)
  ,CONSTRAINT Employ_Hist_Fk_coy_loc_addr_id
	FOREIGN KEY(Company_Location) 
	REFERENCES Address(Address_Id)
	ON DELETE CASCADE
  ,CONSTRAINT Employ_Hist_Fk_emp_id_emp_id
	FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_id)
	ON DELETE CASCADE
 );
 

/*
---------------------------------------------------------------------------------------------------
************************ADDING CONSTRAINT AND KEYS TO EMPOLYMENT_HISTROY***************************
---------------------------------------------------------------------------------------------------
*/ 
 /* creating index */
CREATE INDEX Index_Company_Name 
ON Employment_History(Company_Name);

/* dropping unique constraint */
DROP INDEX Index_Company_Name;

/*
---------------------------------------------------------------------------------------------------
*********************DROPPING CONSTRAINT AND KEYS FROM EMPOLYMENT_HISTROY**************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_pk_employ_id;

/* removing not null */
ALTER TABLE Employment_History 
MODIFY (Company_Location NUMBER(3) NULL);

/* dropping unique constraint */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Unq_Coy_Phone;

/* removing forigen key */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Fk_coy_loc_addr_id;

ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Employment_History;
 
/*
==================================================================================================
=============================================TABLE CREATION=======================================
==================================SEPERATLY APPLYING CONSTRAINT===================================
==================================================================================================
************************************CREATING TABLE ADDRESS ************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Address(
      Address_Id   NUMBER(3)
    , Street_Address VARCHAR2(40)
    , Postal_Code    VARCHAR2(12)
    , City       VARCHAR2(30) NOT NULL
    , State_Province VARCHAR2(25)
    , Country     VARCHAR2(20)
) ;

/*
---------------------------------------------------------------------------------------------------
************************************ADDING CONSTRAINT AND KEYS TO ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
DROP INDEX Index_city;

/*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
/* adding primary key */
ALTER TABLE Address
ADD CONSTRAINT Address_Pk_addr_id 
PRIMARY KEY (Address_Id);

/* removing unique constraint */
ALTER TABLE Address 
ADD CONSTRAINT Address_Unq_county UNIQUE(City);
/*
---------------------------------------------------------------------------------------------------
************************************ADDING CONSTRAINT AND KEYS TO ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* creating index */
CREATE INDEX Index_city ON Address(City);

/* deleteing index */
DROP INDEX Index_city;

/*
---------------------------------------------------------------------------------------------------
*********************************DROPPING CONSTRAINT AND KEYS FROM ADDRESS*************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER TABLE Address 
DROP CONSTRAINT Address_Pk_addr_id ;

/* removing not null */
ALTER TABLE Address 
MODIFY (City VARCHAR2(30) NULL);

/* dropping unique constraint */
ALTER TABLE Address 
DROP CONSTRAINT Address_Unq_county;

/* dropping table */
DROP TABLE Address;

/*
===================================================================================================
************************************CREATING TABLE DEPARTMENT************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Department(
	Department_id NUMBER
	,Department_Name VARCHAR2(20) NOT NULL
	,Department_Code VARCHAR2(10)
	,Department_location NUMBER(3) DEFAULT NULL
	,Manager_id NUMBER(3) DEFAULT NULL
);


ALTER TABLE Department
ADD CONSTRAINT Department_pk_dept_id  
PRIMARY KEY (Department_id);

ALTER TABLE Department
ADD CONSTRAINT Department_Unq_dept_code 
UNIQUE (Department_Code);

ALTER TABLE Department
ADD CONSTRAINT Department_Fk_dept_loc_addr_id
FOREIGN KEY(Department_location)
REFERENCES Address(Address_Id)
ON DELETE CASCADE;

/* creating index */
CREATE INDEX Index_Department_Name 
ON Department(Department_Name);

/* dropping unique constraint */
DROP INDEX Index_Department_Name;

/*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

ALTER TABLE Department
MODIFY (Department_name varchar(20) DEFAULT 'ORG');

/* removing not null */
ALTER TABLE Department 
MODIFY (Department_Name VARCHAR(20) NULL);

/*
---------------------------------------------------------------------------------------------------
***************************DROPPING CONSTRAINT AND KEYS FROM DEPARTMENT****************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Department 
DROP CONSTRAINT Department_pk_dept_id;

/* removing not null */
ALTER TABLE Department 
MODIFY (Department_Name VARCHAR(20) NULL);

/* removing forigen key */
ALTER TABLE Department
DROP CONSTRAINT Department_Fk_dept_loc_addr_id;

/* removing unidque key */
ALTER TABLE Department
DROP CONSTRAINT Department_Unq_dept_code;

/* dropping table */
DROP TABLE Department;

/*
==================================================================================================
***************************************CREATING TABLE EMPLOYEE************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Employee(
	 Employee_id NUMBER(3)
	,First_Name VARCHAR2(20)
	,Middle_Name VARCHAR2(20)
	,Last_Name VARCHAR2(20) 
	,Emp_Gender VARCHAR2(6)
	,Hire_Date DATE
	,Emp_Phone VARCHAR2(10)
	,Emp_Email VARCHAR2(30) NOT NULL 
	,Emp_Salary NUMBER(8,2)
	,Emp_Comm  NUMBER(8,2)
	,Emp_Address NUMBER(3) DEFAULT NULL
	,Emp_Dept NUMBER(3)  DEFAULT NULL
	,Employee_Mgr NUMBER(3) DEFAULT NULL
 );
 

ALTER TABLE Employee
ADD CONSTRAINT Employee_pk_emp_id 
PRIMARY KEY (Employee_id);
 
 /* adding check constraint */
ALTER TABLE Employee
ADD CONSTRAINT Employee_Chk_emp_gender 
CHECK(Emp_Gender IN('Male', 'Female'));

/* adding unique constraint */
ALTER TABLE Employee
ADD CONSTRAINT Employee_Unq_emp_email 
UNIQUE(Emp_Email)

/* adding the forigen keys */
ALTER TABLE Employee
ADD CONSTRAINT Employee_Fk_emp_dept_dept_id 
FOREIGN KEY(Emp_Dept) 
REFERENCES Department(Department_id)
ON DELETE SET NULL ;

ALTER TABLE Employee 
ADD CONSTRAINT Employee_Fk_emp_mgr_emp_id
FOREIGN KEY(Employee_Mgr)
REFERENCES Employee(Employee_id);

ALTER TABLE Employee
ADD CONSTRAINT Employee_Fk_emp_addr_addr_id
FOREIGN KEY(Emp_Address)
REFERENCES Address(Address_Id);

 /* creating index */
CREATE INDEX Index_First_Name 
ON Employee(First_Name);

/* dropping unique constraint */
DROP INDEX Index_First_Name;
 
 /*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------

ALTER TABLE Employee
MODIFY ( First_Name VARCHAR2(20) NOT NULL);

ALTER TABLE Employee
MODIFY ( Last_Name VARCHAR2(20) NOT NULL);

ALTER TABLE Employee 
MODIFY (Hire_Date date NOT NULL);

ALTER TABLE Employee
MODIFY (Middle_Name VARCHAR2(20) DEFAULT NULL);

ALTER TABLE Employee
MODIFY (Emp_Phone VARCHAR2(10)DEFAULT NULL);

ALTER TABLE Employee
MODIFY (Emp_Salary NUMBER(8,2) DEFAULT NULL);

ALTER TABLE Employee
MODIFY (Emp_Comm NUMBER(8,2) DEFAULT NULL );

/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/
/* removing primary key */
ALTER Table Employee 
DROP CONSTRAINT Employee_pk_emp_id;

/* removing not null */
ALTER TABLE Employee 
MODIFY (Last_Name VARCHAR(20) NULL);


/* removing forigen key */
ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_mgr_emp_id;

ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_dept_dept_id;

ALTER Table Employee 
DROP CONSTRAINT Employee_Fk_emp_addr_addr_id;

/* removing unique key */
ALTER Table Employee 
DROP CONSTRAINT Employee_Unq_emp_email;

/* deletting the unique constraint */
ALTER Table Employee 
DROP CONSTRAINT Employee_Unq_emp_email;


/* dropping table */
DROP TABLE Employee;
/*
===================================================================================================
************************************CREATING TABLE EDUCATION **************************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Education(
	Education_Id NUMBER(3)
	,High_School VARCHAR2(50)
	,Intermediate VARCHAR2(50)
	,Graducation VARCHAR2(50) 
	,Post_Graduation VARCHAR2(50) 
	,Emp_Id NUMBER(3) NOT NULL		
 );
 
ALTER TABLE Education 
ADD CONSTRAINT Education_Pk_education_id 
PRIMARY KEY (Education_Id);

ALTER TABLE Education
ADD CONSTRAINT Education_Fk_emp_id_emp_id
FOREIGN KEY(Emp_Id) REFERENCES Employee(Employee_id)
ON DELETE CASCADE;
 
 /*
---------------------------------------------------------------------------------------------------
ADDING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/


ALTER TABLE Education 
MODIFY (Emp_Id NUMBER(3) NOT NULL);

ALTER TABLE Education
MODIFY (High_School VARCHAR2(50) DEFAULT NULL);

ALTER TABLE Education
MODIFY (Intermediate VARCHAR2(50)DEFAULT NULL);

ALTER TABLE Education
MODIFY (Graducation VARCHAR2(50)DEFAULT NULL);

ALTER TABLE Education
MODIFY (Post_Graduation VARCHAR2(50)DEFAULT NULL);

/* creating index */
CREATE INDEX Index_Graduaction 
ON Education(Graduaction);

/* dropping unique constraint */
DROP INDEX Index_Graduaction;

/*
---------------------------------------------------------------------------------------------------
DROPPING CONSTRAINT AND KEYS 
---------------------------------------------------------------------------------------------------
*/

 /* removing primary key */
ALTER Table Education 
DROP CONSTRAINT Education_Pk_education_id ;

/* removing forigen key */
ALTER TABLE Education
DROP FOREIGN KEY Education_Fk_emp_id_emp_id;

/* removing default value */
ALTER TABLE Education
MODIFY ( Post_Graduation VARCHAR2(50));

/*
===================================================================================================
**********************************CREATING TABLE EMPOLYMENT_HISTROY********************************
---------------------------------------------------------------------------------------------------
*/

CREATE TABLE Employment_History(
	Employement_Id NUMBER(3) NOT NULL
	,Company_Name VARCHAR2(50) DEFAULT NULL
	,Company_Location NUMBER(3) NOT NULL
	,Company_Phone VARCHAR2(12)
	,Emp_Id NUMBER(3) NOT NULL
 );
 
ALTER TABLE Employment_History 
ADD CONSTRAINT Employ_Hist_pk_employ_id 
PRIMARY KEY (Employement_id);

ALTER TABLE Employment_History 
ADD CONSTRAINT Employ_Hist_Fk_coy_loc_addr_id
	 FOREIGN KEY(Company_Location) 
	 REFERENCES Address(Address_Id)
	 ON DELETE CASCADE;

ALTER TABLE Employment_History 
ADD CONSTRAINT Employ_Hist_Fk_emp_id_emp_id
	 FOREIGN KEY(Emp_Id) 
	 REFERENCES Employee(Employee_id)
	 ON DELETE CASCADE;	 
 
 /*
---------------------------------------------------------------------------------------------------
************************ADDING CONSTRAINT AND KEYS TO EMPOLYMENT_HISTROY***************************
---------------------------------------------------------------------------------------------------
*/ 
 /* creating index */
CREATE INDEX Index_Company_Name 
ON Employment_History(Company_Name);

/* dropping unique constraint */
DROP INDEX Index_Company_Name;

/*
---------------------------------------------------------------------------------------------------
*********************DROPPING CONSTRAINT AND KEYS FROM EMPOLYMENT_HISTROY**************************
---------------------------------------------------------------------------------------------------
*/

/* removing primary key */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_pk_employ_id;

/* removing not null */
ALTER TABLE Employment_History 
MODIFY (Company_Location NUMBER(3) NULL);

/* dropping unique constraint */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Unq_Coy_Phone;

/* removing forigen key */
ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Fk_coy_loc_addr_id;

ALTER Table Employment_History 
DROP CONSTRAINT Employ_Hist_Fk_emp_id_emp_id;

/* dropping table */
DROP TABLE Employment_History;

========================================================================================================
CREATE TABLE COMMAND
--------------------------------------------------------------------------------------------------------
CREATE TABLE table-Name
  {
      ( {column-definition | Table-level constraint}
      [ , {column-definition | Table-level constraint} ] * )
  |
      [ ( column-name [ , column-name ] * ) ]
      AS query-expression
      WITH NO DATA
   }
========================================================================================================
ALTER TABLE COMMAND
--------------------------------------------------------------------------------------------------------
ALTER TABLE table-Name
{
    ADD COLUMN column-definition |
    ADD CONSTRAINT clause |
    DROP [ COLUMN ] column-name [ CASCADE | RESTRICT ]
    DROP { PRIMARY KEY | FOREIGN KEY constraint-name | UNIQUE 
	 constraint-name | CHECK constraint-name | CONSTRAINT constraint-name }
    ALTER [ COLUMN ] column-alteration |
    LOCKSIZE { ROW | TABLE }
}
column-definition
--------------------
Simple-column-Name DataType
[ Column-level-constraint ]*
[ [ WITH ] DEFAULT {ConstantExpression | NULL } ]

column-alteration
--------------------
column-Name SET DATA TYPE VARCHAR(integer) |
column-name SET INCREMENT BY integer-constant |
column-name RESTART WITH integer-constant |
column-name [ NOT ] NULL |
column-name [ WITH ] DEFAULT default-value 

========================================================================================================
**********************************COMPOSITE PRIMARY KEY AND FORIGEN KEY ********************************
--------------------------------------------------------------------------------------------------------   
CREATE TABLE MASTER_TABLE(
    ID NUMBER(3)
   ,NAME_ID NUMBER(3)
   ,MASTER_NAME VARCHAR2(30) NOT NULL  
   ,CONSTRAINT PK_MASTER_TABLE_ID_NAME 
              PRIMARY KEY(ID,NAME_ID,MASTER_NAME)
);
SQL>INSERT INTO MASTER_TABLE(ID,NAME_ID,MASTER_NAME)
	VALUES(&ID,&NAME_ID,'&MASTER_NAME');
--------------------------------------------------------------------------------------------------------
CREATE TABLE CHILD_TABLE(
   ID NUMBER(3)
   ,NAME_ID NUMBER(3)
   ,CHILD_NAME VARCHAR2(30) NOT NULL 
   ,CONSTRAINT PK_CHILD_TABLE PRIMARY KEY(ID)
   ,CONSTRAINT FK_CHILD_TABLE_ID_NAME 
              FOREIGN KEY(ID,NAME_ID,CHILD_NAME)
			  REFERENCES MASTER_TABLE(ID,NAME_ID,MASTER_NAME) 
);

SQL>INSERT INTO CHILD_TABLE(ID,NAME_ID,CHILD_NAME)
	VALUES(&ID,&NAME_ID,'&CHILD_NAME');
--------------------------------------------------------------------------------------------------------
========================================================================================================
/* CREATING ON THE FLY TABLE WITH DATA*/
CREATE TABLE TEMP_EMP 
TABLESPACE SYSTEM
AS (SELECT * FROM EMP);

/* CREATING ON THE FLY TABLE WITHOUT DATA*/
CREATE TABLE TEMP_EMP 
TABLESPACE SYSTEM
AS (SELECT * FROM EMP WHERE 1=2);