REPORT BC430_CHECK .

***********************************************************************
* This report fills the tables of the participants of the course      *
* BC430 (ABAP Dictionary) with example data                           *
***********************************************************************

TABLES: SSALARY, SFUNCTION, SFUNCTEXT, SEMPLOYES, SFLCREW, BC430_DS.
TABLES: X030L.

DATA: NAME_SALARY LIKE DD03L-TABNAME,
      NAME_FUNCTION LIKE DD03L-TABNAME,
      NAME_EMPLOY LIKE DD03L-TABNAME,
      NAME_CREW LIKE DD03L-TABNAME,
      NAME_FUNCTEXT LIKE DD03L-TABNAME.

DATA: STATE_EMP LIKE DCOBJDEF-STATE,
      STATE_SAL LIKE DCOBJDEF-STATE,
      STATE_FUNC LIKE DCOBJDEF-STATE,
      STATE_CREW LIKE DCOBJDEF-STATE,
      STATE_FUNCTEXT LIKE DCOBJDEF-STATE.

DATA: ERRORS(1).
      ERRORS = ' '.

DATA: TCODE LIKE SY-TCODE.

DATA: COURSE_NAME(6),
      COURSE_GROUP(2).

DATA: KAP2(1),
      KAP3(1),
      KAP4(1).

TYPES: BEGIN OF FEEDBACK,
        COLORS(1),
        TEXT(100),
      END OF FEEDBACK.

DATA: FEEDBACK TYPE FEEDBACK OCCURS 20 WITH HEADER LINE.

* Define data structures to compare the tables tab1 and tab2.
TYPES: BEGIN OF TABSTRUCT,
        FIELDNAME LIKE DD03L-FIELDNAME,
        KEYFLAG LIKE DD03L-KEYFLAG,
        DATATYPE LIKE DD03L-DATATYPE,
        LENG LIKE DD03L-LENG,
        DECIMALS LIKE DD03L-DECIMALS,
        OFFSET LIKE DFIES-OFFSET,
        POSITION LIKE DFIES-POSITION,
       END OF TABSTRUCT.

TYPES: BEGIN OF ASSIGN,
         FELD1 LIKE DFIES-FIELDNAME,
         POS1 LIKE DFIES-POSITION,
         OFFSET1 LIKE DFIES-OFFSET,
         LENG1 LIKE DFIES-LENG,
         FELD2 LIKE DFIES-FIELDNAME,
         POS2 LIKE DFIES-POSITION,
         OFFSET2 LIKE DFIES-OFFSET,
         LENG2 LIKE DFIES-LENG,
       END OF ASSIGN.

* If the user is a standard course user (BC430-xx) the names for the
* tables in the exercises are known.

MOVE SY-UNAME(6) TO COURSE_NAME.

IF COURSE_NAME = 'BC430-'.
  MOVE SY-UNAME+6(2) TO COURSE_GROUP.
  MOVE 'ZEMPLOY' TO NAME_EMPLOY.
  MOVE COURSE_GROUP TO NAME_EMPLOY+7.
  MOVE 'ZSALARY' TO NAME_SALARY.
  MOVE COURSE_GROUP TO NAME_SALARY+7.
  MOVE 'ZFUNCTION' TO NAME_FUNCTION.
  MOVE COURSE_GROUP TO NAME_FUNCTION+9.
  MOVE 'ZFLCREW' TO NAME_CREW.
  MOVE COURSE_GROUP TO NAME_CREW+5.
  MOVE 'ZFUNCTIONT' TO NAME_FUNCTEXT.
  MOVE COURSE_GROUP TO NAME_FUNCTEXT+10.
ENDIF.

* Check if the prerequisites are fulfilled, i.e. that the tables
* SEMPLOYES, SSALARY, SFUNCTION, SFUNCTEXT and SCREW contain data.
PERFORM CHECK_PREREQUISITES.

* Aufruf des Startbildes
CALL SCREEN 1100.

***********************************************************************
* MODULE STATUS_1100                                                  *
***********************************************************************

MODULE STATUS_1100 OUTPUT.

SET TITLEBAR 'CHECK_TITLE'.
SET PF-STATUS 'CHECK'.

ENDMODULE.

***********************************************************************
* MODULE USER_COMMAND_1100                                            *
***********************************************************************

MODULE USER_COMMAND_1100.

CASE TCODE.
  WHEN 'ABBR'.
    LEAVE. SET SCREEN 0. LEAVE SCREEN.
  WHEN 'BACK'.
    LEAVE. SET SCREEN 0. LEAVE SCREEN.
  WHEN 'AUSF'.
    REFRESH FEEDBACK.
    ERRORS = ' '.
    LEAVE TO LIST-PROCESSING.
    IF KAP2 = 'X'.
      PERFORM CHECK_KAP_2.
    ENDIF.
    IF KAP3 = 'X'.
      PERFORM CHECK_KAP_3.
    ENDIF.
    IF KAP4 = 'X'.
      PERFORM CHECK_KAP_4.
    ENDIF.
ENDCASE.

ENDMODULE.

***********************************************************************
* FORM CHECK_PREREQUISITES                                            *
* The report copies the data from SEMPLOYES, SSALARY, SFUNCTION,      *
* SFUNCTEXT and SCREW to the corresponding tables of the participants.*
* To ensure that this works properly two checks are performed:        *
*  1) If one of the tables is empty, the data must be generated.      *
*  2) If the data are built too long ago they may not fit to the      *
*     data in the other tables of the flight model (SPFLI, SFLIGHT).  *
*     The data are generated again if they are not generated this     *
*     or the day before.                                              *
***********************************************************************

FORM CHECK_PREREQUISITES.

DATA: START_FILL_REPORT(1).
      START_FILL_REPORT = '0'.

* First check: Do the tables contain data?
DATA: ENTR_EMPLOYES TYPE I,
      ENTR_SALARY TYPE I,
      ENTR_FUNCTION TYPE I,
      ENTR_FUNCTEXT TYPE I,
      ENTR_CREW TYPE I.

SELECT COUNT(*) FROM SEMPLOYES INTO ENTR_EMPLOYES UP TO 2 ROWS.
SELECT COUNT(*) FROM SSALARY INTO ENTR_SALARY UP TO 2 ROWS.
SELECT COUNT(*) FROM SFUNCTION INTO ENTR_FUNCTION UP TO 2 ROWS.
SELECT COUNT(*) FROM SFUNCTEXT INTO ENTR_FUNCTEXT UP TO 2 ROWS.
SELECT COUNT(*) FROM SFLCREW INTO ENTR_CREW UP TO 2 ROWS.

IF ENTR_EMPLOYES = 0 OR ENTR_SALARY = 0 OR ENTR_FUNCTION = 0 OR
   ENTR_FUNCTEXT = 0 OR ENTR_CREW = 0.
        START_FILL_REPORT = '1'.
ENDIF.

* Second check: When are the data built the last time.
DATA: NEWEST_CR_DATE TYPE SY-DATUM.

SELECT * FROM BC430_DS.
  IF BC430_DS-CR_DATE GT NEWEST_CR_DATE.
    NEWEST_CR_DATE = BC430_DS-CR_DATE.
  ENDIF.
ENDSELECT.

* If the generation report was not started in the system, table
* BC430_DS is empty. In this case the data generation is started.
IF SY-SUBRC > 0.
  START_FILL_REPORT = '1'.
ENDIF.

* If the data generation was not started at this day or the day
* before, it must be started again.
NEWEST_CR_DATE = NEWEST_CR_DATE + 1.
IF NEWEST_CR_DATE LT SY-DATUM.
  START_FILL_REPORT = '1'.
ENDIF.

* If one of the checks failed, generate data
IF START_FILL_REPORT = '1'.
  SUBMIT BC430_FILL AND RETURN.
ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_2                                                    *
* Check correctness of the exercise for chapter 2.                    *
* If everything is OK the tables are filled with data. Since all      *
* tables of this chapter are used later on, we fill in data only if   *
* all three tables are correct!                                       *
***********************************************************************

FORM CHECK_KAP_2.

* First Check: Are all tables defined in the ABAP Dictionary and are
* they active? If not give error messages!

* Check if ZEMPLOYxx is active
PERFORM CHECK_TABLE_EXISTS USING NAME_EMPLOY
                           CHANGING STATE_EMP.
* If ZEMPLOYxx is not active, report error
IF STATE_EMP = ' ' OR STATE_EMP = 'N' OR STATE_EMP = 'M'.
  ERRORS = 'X'.
  PERFORM GIVE_FEEDBACK_TABLE_EXISTS USING NAME_EMPLOY STATE_EMP.
ENDIF.

* Check if ZSALARYxx is active
PERFORM CHECK_TABLE_EXISTS USING NAME_SALARY
                           CHANGING STATE_SAL.
* If ZSALARYxx is not active, report error
IF STATE_SAL = ' ' OR STATE_SAL = 'N' OR STATE_SAL = 'M'.
  ERRORS = 'X'.
  PERFORM GIVE_FEEDBACK_TABLE_EXISTS USING NAME_SALARY STATE_SAL.
ENDIF.

* Check if ZFUNCTIONxx is active
PERFORM CHECK_TABLE_EXISTS USING NAME_FUNCTION
                           CHANGING STATE_FUNC.
* If ZFUNCTIONxx is not active, report error
IF STATE_FUNC = ' ' OR STATE_FUNC = 'N' OR STATE_FUNC = 'M'.
  ERRORS = 'X'.
  PERFORM GIVE_FEEDBACK_TABLE_EXISTS USING NAME_FUNCTION STATE_FUNC.
ENDIF.

* Second Check: Have the tables the correct structure? If not, give
* error messages!
DATA: STRUC_EMP(1),
      STRUC_SAL(1),
      STRUC_FUNC(1).

IF STATE_EMP = 'A'.
  PERFORM CHECK_STRUCTURE USING NAME_EMPLOY 'SEMPLOYES'
                          CHANGING STRUC_EMP.
  IF STRUC_EMP = 'N'.
    ERRORS = 'X'.
  ENDIF.
ENDIF.

IF STATE_SAL = 'A'.
  PERFORM CHECK_STRUCTURE USING NAME_SALARY 'SSALARY'
                          CHANGING STRUC_SAL.
  IF STRUC_SAL = 'N'.
    ERRORS = 'X'.
  ENDIF.
ENDIF.

IF STATE_FUNC = 'A'.
  PERFORM CHECK_STRUCTURE USING NAME_FUNCTION 'SFUNCTION'
                          CHANGING STRUC_FUNC.
  IF STRUC_FUNC = 'N'.
    ERRORS = 'X'.
  ENDIF.
ENDIF.

* If errors occur write the table FEEDBACK. Otherwise fill the tables
* with data.
IF ERRORS = 'X'.
  PERFORM WRITE_FEEDBACK.
ELSEIF ERRORS = ' '.
  PERFORM FILL_TABLES USING NAME_EMPLOY 'SEMPLOYES'.
  PERFORM FILL_TABLES USING NAME_SALARY 'SSALARY'.
  PERFORM FILL_TABLES USING NAME_FUNCTION 'SFUNCTION'.
  PERFORM GIVE_FEEDBACK_SUCCESS.
  PERFORM WRITE_FEEDBACK.
ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_3                                                    *
* Check the correctness of the exercise 3 in chapter 3. Here the      *
* table SFLCREW should be copied to the table ZFLCREWxx. If this table*
* is correct it is filled with data.                                  *
***********************************************************************

FORM CHECK_KAP_3.

* First Check: Is the table defined in the ABAP Dictionary and is
* it active? If not give error messages!

* Check if ZFLCREWxx is active
PERFORM CHECK_TABLE_EXISTS USING NAME_CREW
                           CHANGING STATE_CREW.
* If ZFLCREWxx is not active, report error
IF STATE_CREW = ' ' OR STATE_CREW = 'N' OR STATE_CREW = 'M'.
  ERRORS = 'X'.
  PERFORM GIVE_FEEDBACK_TABLE_EXISTS USING NAME_CREW STATE_CREW.
ENDIF.

* Second Check: Has the table the correct structure? If not, give
* error messages!
DATA: STRUC_CREW(1).

IF STATE_CREW = 'A'.
  PERFORM CHECK_STRUCTURE USING NAME_CREW 'SCREW'
                          CHANGING STRUC_CREW.
  IF STRUC_CREW = 'N'.
    ERRORS = 'X'.
  ENDIF.
ENDIF.

* If errors occur write the table FEEDBACK. Otherwise fill the tables
* with data.
IF ERRORS = 'X'.
  PERFORM WRITE_FEEDBACK.
ELSEIF ERRORS = ' '.
  PERFORM FILL_TABLES USING NAME_CREW 'SCREW'.
  PERFORM GIVE_FEEDBACK_SUCCESS.
  PERFORM WRITE_FEEDBACK.
ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_4                                                    *
* Check the correctness of the exercise 3 in chapter 4. Here the      *
* table ZFUNCTIONTxx must be generated by the participants.           *
* If the table is correct it is filled with data.                     *
***********************************************************************

FORM CHECK_KAP_4.

* First Check: Is the table defined in the ABAP Dictionary and is
* it active? If not give error messages!

* Check if ZFUNCTIONTxx is active
PERFORM CHECK_TABLE_EXISTS USING NAME_FUNCTEXT
                           CHANGING STATE_FUNCTEXT.
* If ZFUNCTIONxx is not active, report error
IF STATE_FUNCTEXT = ' ' OR STATE_FUNCTEXT = 'N'
   OR STATE_FUNCTEXT = 'M'.
  ERRORS = 'X'.
  PERFORM GIVE_FEEDBACK_TABLE_EXISTS USING NAME_FUNCTEXT STATE_FUNCTEXT.
ENDIF.

* Second Check: Has the table the correct structure? If not, give
* error messages!
DATA: STRUC_FUNCTEXT(1).

IF STATE_FUNCTEXT = 'A'.
  PERFORM CHECK_STRUCTURE USING NAME_FUNCTEXT 'SFUNCTEXT'
                          CHANGING STRUC_FUNCTEXT.
  IF STRUC_FUNCTEXT = 'N'.
    ERRORS = 'X'.
  ENDIF.
ENDIF.

* If errors occur write the table FEEDBACK. Otherwise fill the tables
* with data.
IF ERRORS = 'X'.
  PERFORM WRITE_FEEDBACK.
ELSEIF ERRORS = ' '.
  PERFORM FILL_TABLES USING NAME_FUNCTEXT 'SFUNCTEXT'.
  PERFORM GIVE_FEEDBACK_SUCCESS.
  PERFORM WRITE_FEEDBACK.
ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_TABLE_EXISTS                                             *
* Checks if a table is defined and active in the ABAP Dictionary      *
***********************************************************************

FORM CHECK_TABLE_EXISTS USING TABNAME
                        CHANGING STATE LIKE DCOBJDEF-STATE.

CALL FUNCTION 'DDIF_STATE_GET'
     EXPORTING
          TYPE          = 'TABL'
          NAME          = TABNAME
*         ID            =
*         STATE         = 'M'
     IMPORTING
          GOTSTATE      = STATE
     EXCEPTIONS
          ILLEGAL_INPUT = 1
          OTHERS        = 2.

ENDFORM.

***********************************************************************
* FORM GIVE_FEEDBACK_TABLE_EXISTS                                     *
* Writes the reasons for an error in the feedback table.              *
***********************************************************************

FORM GIVE_FEEDBACK_TABLE_EXISTS USING TABNAME STATE.

FEEDBACK-COLORS = 'R'.
FEEDBACK-TEXT = 'Fehler bei Tabelle:'(009).
MOVE TABNAME TO FEEDBACK-TEXT+23.
APPEND FEEDBACK.
  CASE STATE.
    WHEN ' '.
      FEEDBACK-COLORS = 'R'.
      FEEDBACK-TEXT = TEXT-001.
      APPEND FEEDBACK.
      FEEDBACK-COLORS = ' '.
      FEEDBACK-TEXT = TEXT-002.
      APPEND FEEDBACK.
    WHEN 'N'.
      FEEDBACK-COLORS = 'R'.
      FEEDBACK-TEXT = TEXT-003.
      APPEND FEEDBACK.
      FEEDBACK-COLORS = ' '.
      FEEDBACK-TEXT = TEXT-004.
      APPEND FEEDBACK.
    WHEN 'M'.
      FEEDBACK-COLORS = 'R'.
      FEEDBACK-TEXT = TEXT-005.
      APPEND FEEDBACK.
      FEEDBACK-COLORS = ' '.
      FEEDBACK-TEXT = TEXT-004.
      APPEND FEEDBACK.
  ENDCASE.
  FEEDBACK-COLORS = 'L'.
  FEEDBACK-TEXT = ' '.
  APPEND FEEDBACK.

ENDFORM.

***********************************************************************
* FORM WRITE_FEEDBACK                                                 *
* Writes the messages in the internal table FEEDBACK to the screen.   *
***********************************************************************

FORM WRITE_FEEDBACK.

LOOP AT FEEDBACK.
  IF FEEDBACK-COLORS = 'R'.
    WRITE: FEEDBACK-TEXT COLOR COL_NEGATIVE. NEW-LINE.
  ELSEIF FEEDBACK-COLORS = 'L'.
    WRITE: FEEDBACK-TEXT. SKIP. ULINE. SKIP.
  ELSEIF FEEDBACK-COLORS = 'G'.
    WRITE: FEEDBACK-TEXT COLOR COL_POSITIVE. NEW-LINE.
  ELSE.
    WRITE: FEEDBACK-TEXT. NEW-LINE.
  ENDIF.
ENDLOOP.

ENDFORM.

***********************************************************************
* FORM CHECK_STRUCTURE                                                *
* Checks if the structure of the participants table is equal to the   *
* structure of the predefined table.                                  *
* The first parameter TAB1 is the name of the participants table.     *
* The second parameter TAB2 is the name of the solution table.        *
***********************************************************************

FORM CHECK_STRUCTURE USING TAB1 TAB2
                     CHANGING STRU_EQ.

STRU_EQ = 'Y'.

DATA: TAB1_F TYPE TABSTRUCT OCCURS 20 WITH HEADER LINE.
DATA: TAB2_F TYPE TABSTRUCT OCCURS 20 WITH HEADER LINE.

DATA: DFIES_A LIKE DFIES OCCURS 10 WITH HEADER LINE.

DATA: FOUND(1).

* Reads table TAB1 from the dictionary.
CALL FUNCTION 'DDIF_FIELDINFO_GET'
     EXPORTING
          TABNAME        = TAB1
*         FIELDNAME      = ' '
          LANGU          = SY-LANGU
     IMPORTING
          X030L_WA       = X030L
     TABLES
          DFIES_TAB      = DFIES_A
     EXCEPTIONS
          NOT_FOUND      = 1
          INTERNAL_ERROR = 2
          OTHERS         = 3.

IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

LOOP AT DFIES_A.
  MOVE-CORRESPONDING DFIES_A TO TAB1_F.
  APPEND TAB1_F.
ENDLOOP.

REFRESH DFIES_A.

* Reads Table TAB2 from the dictionary
CALL FUNCTION 'DDIF_FIELDINFO_GET'
     EXPORTING
          TABNAME        = TAB2
*         FIELDNAME      = ' '
          LANGU          = SY-LANGU
     IMPORTING
          X030L_WA       = X030L
     TABLES
          DFIES_TAB      = DFIES_A
     EXCEPTIONS
          NOT_FOUND      = 1
          INTERNAL_ERROR = 2
          OTHERS         = 3.

IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

LOOP AT DFIES_A.
  MOVE-CORRESPONDING DFIES_A TO TAB2_F.
  APPEND TAB2_F.
ENDLOOP.

* Compare the tables TAB1_F and TAB2_F.
* They are considered to be OK if for every field in TAB2 a field
* with same type, length, decimals and keyflag exists in TAB1.
* Thus, if TAB1 contains additional fields this is not considered to
* be an error.
LOOP AT TAB2_F.
  FOUND = 'N'.
  LOOP AT TAB1_F.
    IF TAB1_F-LENG = TAB2_F-LENG AND
       TAB1_F-DATATYPE = TAB2_F-DATATYPE AND
       TAB1_F-DECIMALS = TAB2_F-DECIMALS AND
       TAB1_F-KEYFLAG = TAB2_F-KEYFLAG.
       FOUND = 'Y'.
    ENDIF.
  ENDLOOP.
  IF FOUND = 'N'.
    STRU_EQ = 'N'.
  ENDIF.
ENDLOOP.

* If the structure of TAB1 is not OK the corresponding error
* messages must be written into the table FEEDBACK.
IF STRU_EQ = 'N'.
  FEEDBACK-COLORS = 'R'.
  FEEDBACK-TEXT = 'Fehler bei Tabelle:'(009).
  MOVE TAB1 TO FEEDBACK-TEXT+23.
  APPEND FEEDBACK.
  FEEDBACK-TEXT = 'Feldstruktur der Tabelle ist nicht korrekt!'(006).
  APPEND FEEDBACK.
  FEEDBACK-COLORS = ' '.
  FEEDBACK-TEXT = 'Erwartete Feldstruktur:'(007).
  APPEND FEEDBACK.
  CLEAR FEEDBACK-TEXT.
  MOVE 'Feld'(010) TO FEEDBACK-TEXT+2.
  MOVE 'Key'(011) TO FEEDBACK-TEXT+32.
  MOVE 'Typ'(012) TO FEEDBACK-TEXT+37.
  MOVE 'Länge'(013) TO FEEDBACK-TEXT+43.
  MOVE 'Dec.'(014) TO FEEDBACK-TEXT+51.
  APPEND FEEDBACK.
  LOOP AT TAB2_F.
    MOVE TAB2_F-FIELDNAME TO FEEDBACK-TEXT+2.
    MOVE TAB2_F-KEYFLAG TO FEEDBACK-TEXT+33.
    MOVE TAB2_F-DATATYPE TO FEEDBACK-TEXT+37.
    WRITE TAB2_F-LENG TO FEEDBACK-TEXT+43 NO-ZERO.
    WRITE TAB2_F-DECIMALS TO FEEDBACK-TEXT+51 NO-ZERO.
    APPEND FEEDBACK.
  ENDLOOP.
  FEEDBACK-COLORS = 'L'.
  FEEDBACK-TEXT = ' '.
  APPEND FEEDBACK.
ENDIF.


ENDFORM.

***********************************************************************
* FORM FILL_TABLES                                                    *
* If the tables have the correct structure, they are filled with      *
* the data from the predefined tables.                                *
* TAB1 is the participants table (empty). TAB2 is the predefined      *
* table which contains the example data.                              *
***********************************************************************

FORM FILL_TABLES USING TAB1 TAB2.

* Data declarations to calculate the field assignments.
DATA: TAB1_F TYPE TABSTRUCT OCCURS 20 WITH HEADER LINE.
DATA: TAB2_F TYPE TABSTRUCT OCCURS 20 WITH HEADER LINE.

DATA: DFIES_A LIKE DFIES OCCURS 10 WITH HEADER LINE.

DATA: ASSIGN_FIELD TYPE ASSIGN OCCURS 10 WITH HEADER LINE.

* Data declarations to fill in the table entries
TYPES: BEGIN OF RECORDS,
         RECORD(200),
       END OF RECORDS.

DATA: REC_TAB1 TYPE RECORDS OCCURS 50 WITH HEADER LINE.
DATA: REC_TAB2 TYPE RECORDS OCCURS 50 WITH HEADER LINE.

* Reads table TAB1 from the dictionary.
CALL FUNCTION 'DDIF_FIELDINFO_GET'
     EXPORTING
          TABNAME        = TAB1
*         FIELDNAME      = ' '
          LANGU          = SY-LANGU
     IMPORTING
          X030L_WA       = X030L
     TABLES
          DFIES_TAB      = DFIES_A
     EXCEPTIONS
          NOT_FOUND      = 1
          INTERNAL_ERROR = 2
          OTHERS         = 3.

IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

LOOP AT DFIES_A.
  MOVE-CORRESPONDING DFIES_A TO TAB1_F.
  APPEND TAB1_F.
ENDLOOP.

REFRESH DFIES_A.

* Reads Table TAB2 from the dictionary
CALL FUNCTION 'DDIF_FIELDINFO_GET'
     EXPORTING
          TABNAME        = TAB2
*         FIELDNAME      = ' '
          LANGU          = SY-LANGU
     IMPORTING
          X030L_WA       = X030L
     TABLES
          DFIES_TAB      = DFIES_A
     EXCEPTIONS
          NOT_FOUND      = 1
          INTERNAL_ERROR = 2
          OTHERS         = 3.

IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

LOOP AT DFIES_A.
  MOVE-CORRESPONDING DFIES_A TO TAB2_F.
  APPEND TAB2_F.
ENDLOOP.

* Create the field assignment. If TAB1 contains additional field, i.e.
* field which are not contained in TAB2, these fields are ignored.
LOOP AT TAB2_F.
  LOOP AT TAB1_F.
    IF TAB1_F-LENG = TAB2_F-LENG AND
       TAB1_F-DATATYPE = TAB2_F-DATATYPE AND
       TAB1_F-DECIMALS = TAB2_F-DECIMALS AND
       TAB1_F-KEYFLAG = TAB2_F-KEYFLAG.

       ASSIGN_FIELD-FELD1 = TAB1_F-FIELDNAME.
       ASSIGN_FIELD-POS1 = TAB1_F-POSITION.
       ASSIGN_FIELD-OFFSET1 = TAB1_F-OFFSET.
       ASSIGN_FIELD-LENG1 = TAB1_F-LENG.
       ASSIGN_FIELD-FELD2 = TAB2_F-FIELDNAME.
       ASSIGN_FIELD-POS2 = TAB2_F-POSITION.
       ASSIGN_FIELD-OFFSET2 = TAB2_F-OFFSET.
       ASSIGN_FIELD-LENG2 = TAB2_F-LENG.
       APPEND ASSIGN_FIELD.
    ENDIF.
  ENDLOOP.
ENDLOOP.

* Daten aus TAB2 lesen.
SELECT * FROM (TAB2) INTO REC_TAB2.
  APPEND REC_TAB2.
ENDSELECT.

* Daten in interne Tabelle einfüllen.
LOOP AT REC_TAB2.
  LOOP AT ASSIGN_FIELD.
    REC_TAB1+ASSIGN_FIELD-OFFSET1(ASSIGN_FIELD-LENG1) =
    REC_TAB2+ASSIGN_FIELD-OFFSET2(ASSIGN_FIELD-LENG2).
  ENDLOOP.
  APPEND REC_TAB1.
ENDLOOP.

* Daten auf die Datenbank schreiben.
INSERT (TAB1) FROM TABLE REC_TAB1 ACCEPTING DUPLICATE KEYS.

ENDFORM.

***********************************************************************
* FORM GIVE_FEEDBACK_SUCCESS                                          *
* Writes messages that solution is OK.                                *
***********************************************************************

FORM GIVE_FEEDBACK_SUCCESS.

REFRESH FEEDBACK.

FEEDBACK-COLORS = 'G'.
FEEDBACK-TEXT = TEXT-022.
APPEND FEEDBACK.

FEEDBACK-COLORS = 'G'.
FEEDBACK-TEXT = TEXT-024.
APPEND FEEDBACK.

ENDFORM.
