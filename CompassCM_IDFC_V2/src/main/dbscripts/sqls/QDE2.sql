select * from tb_user
select * from TB_ROLE

select * from TB_USERROLEMAPPING

SELECT REFRESHTIME, EMAILCOUNT, STATUS, MESSAGE, FOLDER, UPDATEDBY
  FROM TB_EMAILREFRESHLOG
 ORDER BY UPDATETIMESTAMP DESC
 
SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME,   
 	   CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTENABLE,   
 	   CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED,   
 	   CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CREDENTIALEXPIRED,        
 	   SUBSTR(NVL(A.ACCESSSTARTTIME,'00:00:00'),0,5) ACCESSSTARTTIME, 
 	   SUBSTR(NVL(A.ACCESSENDTIME,'23:59:59'),0,5) ACCESSENDTIME,        
 	   CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN NULL ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE,
 	   B.APPROVEDBY APPROVEDBY, TO_CHAR(NVL(B.APPROVEDTIMESTAMP, SYSDATE), 'DD/MM/YYYY') APPROVEDTIMESTAMP   
 FROM TB_USER A, TB_USER_CHECKERACTIVITY B  
WHERE A.USERCODE = B.USERCODE    
  AND A.MAKERCODE = B.MAKERCODE  
  AND A.USERCODE = 'xen.002'
  
SELECT * FROM TB_USER_MAKER

SELECT * FROM TB_USER_CHECKERACTIVITY

UPDATE TB_USER_CHECKERACTIVITY 
   SET USERDETAILSUPDATEED = 'Y', USERDETAILSUPDATEDBY = '', USERDETAILSUPDATETIME = SYSTIMESTAMP,
       ACTIONSTATUS = 'P', UPDATETIMESTAMP = SYSTIMESTAMP 
 WHERE MAKERCODE = ''
 
SELECT A.USERCODE USERCODE, '_USER' AS USETABLE, A.FIRSTNAME || ' ' || A.LASTNAME || '[' || A.USERCODE || '] (Checked)' AS USERSTATUS 
  FROM TB_USER A 
 UNION ALL
SELECT B.USERCODE, '_USER_MAKER' AS USETABLE,
       CASE NVL(C.ACTIONSTATUS , 'P') WHEN 'P' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '[' || B.USERCODE || '] (Pending)' ELSE B.FIRSTNAME || ' ' || B.LASTNAME || '[' || B.USERCODE || '] (Rejected)' END AS USERSTATUS 
  FROM TB_USER_MAKER B, TB_USER_CHECKERACTIVITY C
 WHERE B.USERCODE = C.USERCODE
   AND B.MAKERCODE = C.MAKERCODE

  SELECT CASE NVL(APPROVEDTIMESTAMP, NULL) WHEN NULL 'A' ELSE 'B' END from TB_USER_CHECKERACTIVITY
  SELECT CASE APPROVEDTIMESTAMP WHEN NULL THEN '' ELSE TO_CHAR(APPROVEDTIMESTAMP, 'DD/MM/YYYY') END APPROVEDTIMESTAMP from TB_USER_CHECKERACTIVITY
  
select * from tb_usermodulemapping
  
  
   xen.002  ADMIN  caseWorkflow     SYSTEM    2015-03-17 13:00:13.732
 xen.002  ADMIN  pendingCase      SYSTEM    2015-03-17 13:00:13.862
 xen.002  ADMIN  accountProfiling SYSTEM    2015-03-17 13:00:15.041
 accountProfiling Profiling  M               commonAccountProfiling common/accountProfiling            9 0          SYSTEM    2015-03-17 13:43:12.892

 
 insert into TB_USERMODULEMAPPING values('rintu.biswas','USER','caseWorkflow','SYSTEM',SYSTIMESTAMP);
  
  
  
  select * from tb_module where modulecode='commonAccountProfiling'
  
select * from TB_IPADDRESS_CHECKERACTIVITY

SELECT A.IPADDRESS IPADDRESS, '_IPADDRESS' AS USETABLE, 
	   A.IPADDRESS || '  [ ' || A.SYSTEMNAME || ' ] (Checked)' AS IPSTATUS   
  FROM TB_IPADDRESS A  
 UNION ALL SELECT B.IPADDRESS IPADDRESS, '_IPADDRESS_MAKER' AS USETABLE,   
       CASE NVL(C.ACTIONSTATUS , 'P') WHEN 'P' THEN B.IPADDRESS || '  [ ' || B.SYSTEMNAME || ' ] (Pending)' WHEN 'R' THEN B.IPADDRESS || '  [ ' || B.SYSTEMNAME || ' ] (Rejected)' ELSE B.IPADDRESS || '  [ ' || B.SYSTEMNAME || ' ] (Approved)' END AS IPSTATUS   
  FROM TB_IPADDRESS_MAKER B, TB_IPADDRESS_CHECKERACTIVITY C  
 WHERE B.IPADDRESS = C.IPADDRESS    
   AND B.MAKERCODE = C.MAKERCODE

select * from tb_user_checkeractivity


SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME,        
CASE NVL(A.ISENABLED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ISENABLED 		CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' WHEN 'R' THEN 'Rejected' ELSE 'Approved' END IPSTATUS,        B.APPROVEDBY APPROVEDBY, CASE APPROVEDTIMESTAMP WHEN NULL THEN '' ELSE TO_CHAR(APPROVEDTIMESTAMP, 'DD/MM/YYYY') END APPROVEDTIMESTAMP   FROM TB_IPADDRESS_MAKER A, TB_USER_CHECKERACTIVITY B  WHERE A.IPADDRESS = B.IPADDRESS    AND A.MAKERCODE = B.MAKERCODE    AND A.IPADDRESS = ?    AND A.MAKERCODE = ?

SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, A.ISENABLED ISENABLED, A.UPDATEDBY, A.MAKERCODE, 
       CASE NVL(A.UPDATETIMESTAMP, NULL) WHEN NULL THEN '''' ELSE TO_CHAR(A.UPDATETIMESTAMP,'DD/MM/YYYY') END UPDATETIMESTAMP, 
	   B.ISNEWIPADDRESS ISNEWIPADDRESS, B.UPDATEDBY MAKERUPDATEDBY,
	   CASE NVL(B.UPDATETIMESTAMP, NULL) WHEN NULL THEN '''' ELSE TO_CHAR(B.UPDATETIMESTAMP,'DD/MM/YYYY') END MAKERUPDATETIMESTAMP
  FROM TB_IPADDRESS_MAKER A, TB_IPADDRESS_CHECKERACTIVITY B
 WHERE A.MAKERCODE = B.MAKERCODE
   AND A.MAKERCODE = '21042015161048'
 
select * from tb_ipaddress


select * from TB_IPADDRESS_CHECKERACTIVITY
select * from tb_ipaddress_maker

SELECT 

SELECT B.IPADDRESS, B.SYSTEMNAME, B.ISENABLED, B.UPDATEDBY, B.UPDATETIMESTAMP, B.MAKERCODE 
  FROM TB_IPADDRESS_MAKER B WHERE B.MAKERCODE = '22042015121104'

  
  select ipaddress from tb_ipaddress_maker where ipaddress not in (select ipaddress from tb_ipaddress)

  
 SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME, 'Checked' USERSTATUS 
   FROM TB_USER A
  UNION ALL
 SELECT B.USERCODE USERCODE, B.FIRSTNAME FIRSTNAME, B.LASTNAME, 'Pending' USERSTATUS
   FROM TB_USER_MAKER B, TB_USER_CHECKERACTIVITY C
  WHERE B.USERCODE = C.USERCODE
    AND C.ACTIONSTATUS = 'P'
    AND C.ROLEDETAILSUPDATED = 'Y'
  
  select * from tb_role
  
  
  select * from tb_rolemodulemapping
  select * from TB_USERROLEMAPPING
  select * from TB_USERMODULEMAPPING
  
  
  select a.modulecode, a.modulename from tb_module a, TB_ROLEMODULEMAPPING b
  where a.modulecode = b.modulecode
  and b.roleid='ADMIN'
  and a.MAINORSUBMODULE='M'
  
  select * from tb_userrolemapping
  
  select a.roleid from tb_userrolemapping a
  where a.roleid not in (select b.roleid from TB_USERMODULEMAPPING b where a.usercode = b.usercode)
  and a.usercode='rintu.biswas'
  
  select * from TB_USERMODULEMAPPING where usercode='rintu.biswas'
  
  SELECT DISTINCT ROLEID FROM TB_USERMODULEMAPPING WHERE USERCODE='rintu.biswas'
  select * from tb_userrolemapping_maker where usercode='rintu.biswas'
  select * from TB_USERMODULEMAPPING_MAKER where usercode = 'xen.002'
  
  select * from TB_USER_CHECKERACTIVITY where usercode='xen.002'
  select * from tb_user_maker where usercode='xen.002'
  select * from tb_user
  
  
  select * from tb_role
  
  select a.usercode, CASE NVL(B.USERCODE, 'X') WHEN 'X' THEN 'Pending' ELSE 'Checked' END from tb_user a
  left outer join TB_USERROLEMAPPING b
  on 1=1
  where b.roleid='ADMIN'
  
  select a.usercode, b.roleid from tb_user a
  left outer join TB_USERROLEMAPPING b
  on b.roleid='ADMIN'
  where a.usercode = b.usercode
  
  
  select usercode, firstname, lastname, 'C'
  from tb_user
  union
  select a.usercode, a.firstname, a.lastname, 'P'
  from tb_user_maker a, TB_USER_CHECKERACTIVITY b
  where a.usercode = b.usercode
  and b.actionstatus='P'
  
  select NOTALLOWEDROLES from tb_role where roleid in(
  select roleid from TB_USERROLEMAPPING
  where usercode = 'User'
  union
  select roleid from TB_USERROLEMAPPING_MAKER
  where usercode = 'User'
  )
  
  select a.*,b.* from TB_USERROLEMAPPING a
  full outer join
  TB_USERROLEMAPPING_MAKER b
  on a.usercode = b.usercode
  
  
  select USERCODE, ROLEID, 'C' from TB_USERROLEMAPPING
  where usercode = 'rintu.biswas'
  union
  select USERCODE, ROLEID, 'P' from TB_USERROLEMAPPING_maker
  where usercode = 'rintu.biswas'

  
  
  select * from tb_userrolemapping_maker where usercode='rintu.biswas'
  
  select * from TB_USER_CHECKERACTIVITY where actionstatus='P' and usercode='xen.002'
  
  select * from TB_role
  
  
  
  where usercode not in(
  select usercode
  from TB_USERROLEMAPPING
  where roleid = 'ADMIN'
  union 
  select usercode
  from 
  TB_USERROLEMAPPING_MAKER
  where roleid = 'ADMIN'
  )
  
  select roleid from TB_USERROLEMAPPING
  where usercode = 'AMLUser'
  and roleid='ADMIN'
  union
  select roleid from TB_USERROLEMAPPING_MAKER
  where usercode = 'AMLUser'
  and roleid='ADMIN'
  
  
  SELECT A.*, CASE WHEN B.USERCODE IS NOT NULL THEN 'Y' ELSE 'N' END AS ISPRESENT 
    FROM (
    	 SELECT C.USERCODE, C.FIRSTNAME, C.LASTNAME
    	   FROM TB_USER C
    	  UNION
    	 SELECT D.USERCODE, D.FIRSTNAME, D.LASTNAME
    	   FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E
    	  WHERE D.USERCODE = E.USERCODE
    	    AND E.ACTIONSTATUS = 'P'
    	 ) A
    LEFT OUTER JOIN
         (
         SELECT C.USERCODE, C.ROLEID
           FROM TB_USERROLEMAPPING C
          WHERE C.ROLEID = 'ADMIN'
          UNION
          SELECT D.USERCODE, D.ROLEID
            FROM TB_USERROLEMAPPING_MAKER D
           WHERE D.ROLEID = 'ADMIN'
         ) B
      ON A.USERCODE = B.USERCODE
      
      
select usercode, firstname, lastname
  from tb_user
  union
  select a.usercode, a.firstname, a.lastname
  from tb_user_maker a, TB_USER_CHECKERACTIVITY b
  where a.usercode = b.usercode
  and b.actionstatus='P'
  ) A
  Left Outer Join
  (select usercode,roleid from TB_USERROLEMAPPING
  where roleid='ADMIN'
  union
  select usercode,roleid from TB_USERROLEMAPPING_MAKER
  where roleid='ADMIN')   B On A.usercode = B.usercode
  
  
  
  SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, 'Checked' USERSTATUS, '' USETABLE   
    FROM TB_USER A  
   UNION ALL 
  SELECT B.USERCODE USERCODE, B.FIRSTNAME FIRSTNAME, B.LASTNAME LASTNAME, 'Pending' USERSTATUS, '_MAKER' USETABLE   
    FROM TB_USER B, TB_USER_CHECKERACTIVITY C  
   WHERE B.USERCODE = C.USERCODE    
     AND C.ACTIONSTATUS = 'P'    
     AND C.ROLEDETAILSUPDATED = 'Y'  
   UNION  
  SELECT D.USERCODE USERCODE, D.FIRSTNAME FIRSTNAME, D.LASTNAME LASTNAME, 'Pending' USERSTATUS, '_MAKER' USETABLE    
    FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E  
   WHERE D.MAKERCODE = E.MAKERCODE    
     AND E.ACTIONSTATUS = 'P'    
     AND (E.ROLEDETAILSUPDATED = 'Y'     
     	 OR E.ISNEWUSER = 'Y'
     	 )

SELECT DISTINCT(F.IPADDRESS), F.SYSTEMNAME, F.IPSTATUS
  FROM (
SELECT A.*,
		CASE
	   		WHEN E.STATUS IN ('C') AND E.STATUS NOT IN ('P') THEN 'Pending to remove'
	   		WHEN E.STATUS IN ('P') AND E.STATUS NOT IN ('C') THEN 'Pending to add'
	   		WHEN E.STATUS IN ('C','P') THEN 'Checked'
	   		ELSE ''
	   	END AS IPSTATUS
SELECT A.*,E.*  FROM (
SELECT B.IPADDRESS, B.SYSTEMNAME
  FROM TB_IPADDRESS B
 WHERE ISENABLED = 'Y'
) A 
LEFT OUTER JOIN
(
SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS
FROM TB_USERIPADDRESSMAPPING C
WHERE C.USERCODE = 'rintu.biswas'
UNION
SELECT D.IPADDRESS IPASSIGN, 'P' AS STATUS
FROM TB_USERIPADDRESSMAPPING_MAKER D
WHERE D.USERCODE = 'rintu.biswas'
) E
ON A.IPADDRESS = E.IPASSIGN
) F


select e.*, f.*
from
(
select * from tb_ipaddress
where isenabled = 'Y'
) E
LEFT outer join
(
SELECT CASE 
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN A.IPASSIGN
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN A.IPASSIGN
	        WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN B.IPASSIGN
	        ELSE ''
	   END IPASSIGN,
	   CASE 
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Checked'
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN 'Pending to remove'
	        WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Pending to add'
	        ELSE ''
	    END IPSTATUS
  FROM
(
SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS
FROM TB_USERIPADDRESSMAPPING C
WHERE C.USERCODE = 'rintu.biswas'
) A
FULL OUTER JOIN
(
SELECT D.IPADDRESS IPASSIGN, 'P' AS STATUS
FROM TB_USERIPADDRESSMAPPING_MAKER D
WHERE D.USERCODE = 'rintu.biswas'
) B
ON A.IPASSIGN = B.IPASSIGN
) F
on e.ipaddress = f.IPASSIGN















SELECT CASE 
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN A.IPASSIGN
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN A.IPASSIGN
	        WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN B.IPASSIGN
	        ELSE ''
	   END IPASSIGN,
	   CASE 
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Checked'
	        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN 'Pending to remove'
	        WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Pending to add'
	        ELSE ''
	    END IPSTATUS
  FROM
(
SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS
FROM TB_USERIPADDRESSMAPPING C
WHERE C.USERCODE = 'rintu.biswas'
) A
FULL OUTER JOIN
(
SELECT D.IPADDRESS IPASSIGN, 'P' AS STATUS
FROM TB_USERIPADDRESSMAPPING_MAKER D
WHERE D.USERCODE = 'rintu.biswas'
) B
ON A.IPASSIGN = B.IPASSIGN


select a.firstname||' '||a.lastname || '  [ ' || a.usercode || ' ]  '
from tb_user a


select c.USERDETAILS, c.USERCODE
from(
select 
	   CASE 
	        WHEN NVL(A.userstatus, 'R') IN ('C') AND NVL(B.userstatus, 'R') IN ('P') THEN a.firstname||' '||a.lastname || '  [ ' || a.usercode || ' ]  '
	        WHEN NVL(A.userstatus, 'R') IN ('C') AND NVL(B.userstatus, 'R') IN ('R') THEN a.firstname||' '||a.lastname || '  [ ' || a.usercode || ' ]  '
	        WHEN NVL(A.userstatus, 'R') IN ('R') AND NVL(B.userstatus, 'R') IN ('P') THEN b.firstname||' '||b.lastname || '  [ ' || b.usercode || ' ]  '
	        ELSE ''
	   END USERDETAILS,
	   CASE 
	        WHEN NVL(A.userstatus, 'R') IN ('C') AND NVL(B.userstatus, 'R') IN ('P') THEN a.usercode
	        WHEN NVL(A.userstatus, 'R') IN ('C') AND NVL(B.userstatus, 'R') IN ('R') THEN a.usercode
	        WHEN NVL(A.userstatus, 'R') IN ('R') AND NVL(B.userstatus, 'R') IN ('P') THEN b.usercode
	        ELSE ''
	   END USERCODE
from
(
select usercode, firstname, lastname, 'C' as userstatus
from tb_user
) a
FULL OUTER JOIN
(
select usercode, firstname, lastname, 'P' as userstatus
from tb_user_maker
) b
on a.usercode = b.usercode
) c
where c.USERCODE in (
select d.usercode from (
select usercode from tb_useripaddressmapping
where ipaddress = '192.168.0.2'
union
select usercode from TB_USERIPADDRESSMAPPING_MAKER
where ipaddress = '192.168.0.2'
) d
)


SELECT E.IPADDRESS, E.SYSTEMNAME, F.IPSTATUS   
  FROM (        
       SELECT * 
         FROM TB_IPADDRESS
		WHERE ISENABLED = 'Y' 	   
		) E 
   LEFT OUTER JOIN        
        (
        SELECT CASE 
				    WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN A.IPASSIGN  
				    WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN A.IPASSIGN 
				    WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN B.IPASSIGN                    
				  	ELSE ''
				END IPASSIGN,
			   CASE
			        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Checked'
			        WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN 'Pending for remove'
			        WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Pending to add'                    
			        ELSE 'A'
			    END IPSTATUS           
	 SELECT A.*,B.*      FROM (               
	            SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS          
				  FROM TB_USERIPADDRESSMAPPING C                 
				 WHERE C.USERCODE = 'rintu.biswas'                
				) A        
		   FULL OUTER JOIN                
		   		(                
		   		SELECT D.IPADDRESS IPASSIGN, 'P' AS STATUS
		   		  FROM TB_USERIPADDRESSMAPPING_MAKER D, TB_USER_CHECKERACTIVITY G 
		   		 WHERE D.USERCODE = 'rintu.biswas'
		   		   AND D.USERCODE = G.USERCODE
				   AND (G.ACTIONSTATUS = 'P' OR IPDETAILSUPDATEED = 'Y')
				) B             
		     ON A.IPASSIGN = B.IPASSIGN        
		  ) F
	   ON E.IPADDRESS = F.IPASSIGN 

select * from TB_USER_CHECKERACTIVITY where actionstatus='P' and usercode='User'




SELECT A.*, CASE WHEN B.USERCODE IS NOT NULL THEN 'Y' ELSE 'N' END AS ISPRESENT 
  FROM (
  	   SELECT C.USERCODE, C.FIRSTNAME, C.LASTNAME 
  	     FROM TB_USER C 
  	    UNION 
  	   SELECT D.USERCODE, D.FIRSTNAME, D.LASTNAME 
  	     FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E 
  	    WHERE D.USERCODE = E.USERCODE 
  	      AND E.ACTIONSTATUS = 'P' 
  	   ) A 
  LEFT OUTER JOIN 
  	   (
  	   SELECT C.USERCODE, C.IPADDRESS 
  	     FROM TB_USERIPADDRESSMAPPING C 
  	    WHERE C.IPADDRESS = '192.168.0.10' 
  	    UNION 
  	   SELECT D.USERCODE, D.IPADDRESS 
  	     FROM TB_USERIPADDRESSMAPPING_MAKER D 
  	    WHERE D.IPADDRESS = '192.168.0.10'
  	   ) B
  	ON A.USERCODE = B.USERCODE




SELECT USERCODE, CASE NVL(ISNEWUSER,'N') WHEN 'N' THEN 'No' ELSE 'Yes' END AS ISNEWUSER,
	   USERDETAILSUPDATEED,USERDETAILSUPDATEDBY, 
	   TO_CHAR(NVL(USERDETAILSUPDATETIME,SYSDATE),'DD/MM/YYYY'),ROLEDETAILSUPDATED,ROLEDETAILSUPDATEDBY,
		TO_CHAR(NVL(ROLEDETAILSUPDATETIME,SYSDATE),'DD/MM/YYYY'),IPDETAILSUPDATEED,IPDETAILSUPDATEBY,
		TO_CHAR(NVL(IPDETAILSUPDATETIME,SYSDATE),'DD/MM/YYYY')
  FROM TB_USER_CHECKERACTIVITY



select * from tb_user_checkeractivity where usercode='rintu.biswas' and actionstatus='P'

SELECT E.IPADDRESS, E.SYSTEMNAME, F.IPSTATUS ,  ASTSTUS, BSTSTUS
  FROM (        
  		SELECT *          
  		  FROM TB_IPADDRESS         
  		 WHERE ISENABLED = 'Y' 	   
  	   ) E   
  LEFT OUTER JOIN        
       (        
       SELECT A.STATUS ASTSTUS, B.STATUS BSTSTUS, CASE                    
       			   WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN A.IPASSIGN                    
       			   WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN A.IPASSIGN                    
       			   WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN B.IPASSIGN                    
       			   ELSE ''                
       		    END IPASSIGN,               
       		   CASE                    
       		       WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Checked'                    
       		       WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN 'Pending for remove'        
       		       WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Pending to add'            
       		       ELSE 'A'                
       		    END IPSTATUS           
     	  FROM (                
       	        SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS                 
       	          FROM TB_USERIPADDRESSMAPPING C                
       	         WHERE C.USERCODE = 'AMLUser'              
       	       ) A           
       	       FULL OUTER JOIN                
       	       (                
       	       SELECT (D.IPADDRESS) IPASSIGN, 'P' AS STATUS                  
       	         FROM TB_USERIPADDRESSMAPPING_MAKER D, TB_USER_CHECKERACTIVITY G                 
       	        WHERE D.USERCODE = 'AMLUser'                   
       	          AND D.USERCODE = G.USERCODE                  
       	          AND (G.ACTIONSTATUS = 'P' OR IPDETAILSUPDATEED = 'Y')                
       	        ) B            
       	        ON A.IPASSIGN = B.IPASSIGN        ) F     
       	     ON E.IPADDRESS = F.IPASSIGN 
       	     
       	     SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS                 
       	          FROM TB_USERIPADDRESSMAPPING C                
       	         WHERE C.USERCODE = 'AMLUser'
       	     select * from TB_USER_CHECKERACTIVITY where USERCODE = 'User'    
       	     
       	     SELECT DISTINCT(D.IPADDRESS)                
       	         FROM TB_USERIPADDRESSMAPPING_MAKER D, TB_USER_CHECKERACTIVITY G                 
       	        WHERE D.USERCODE = 'User'                   
       	          AND D.USERCODE = G.USERCODE                  
       	          AND (G.ACTIONSTATUS = 'P' OR IPDETAILSUPDATEED = 'Y')   
       	          AND ROWNUM = 1

SELECT DISTINCT(D.IPADDRESS) IPASSIGN, 'P' AS STATUS 
   FROM TB_USERIPADDRESSMAPPING_MAKER D, TB_USER_CHECKERACTIVITY G 
 WHERE D.USERCODE = 'User' AND D.USERCODE = G.USERCODE 
 AND (G.ACTIONSTATUS = 'P' OR IPDETAILSUPDATEED = 'Y')

select * from tb_userrolemapping where usercode='xen.002'

select * from tb_usermodulemapping where usercode='xen.002'