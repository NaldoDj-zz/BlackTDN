BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE SUBSTR(object_name,4,3)='C40' 
                      AND SUBSTR(object_name,1,2)<>'T_'  
                      AND SUBSTR(object_name,1,3)<>'SX5'
                      AND SUBSTR(object_name,1,3)<>'SX2'
                      AND SUBSTR(object_name,1,3)<>'CTO'
                      AND SUBSTR(object_name,1,3)<>'SM2'
                      AND (
                                SUBSTR(object_name,1,2) IN ('SR','SP','SQ')
                                OR
                                SUBSTR(object_name,1,1)='R'
                      )                                
                      AND object_type IN
                            (
                               'TABLE'
                              ,'VIEW'
                              ,'PACKAGE'
                              ,'PROCEDURE'
                              ,'FUNCTION'
                              ,'SEQUENCE'
                            ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
