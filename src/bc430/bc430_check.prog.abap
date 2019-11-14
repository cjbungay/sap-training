REPORT BC430_CHECK.

CALL SCREEN 1100.

* Includes für das Image Control
INCLUDE SIMAGECONTROLCLASSDEF.
INCLUDE SIMAGECONTROLCLASSIMPL.
* Include für die Icons
INCLUDE <ICON>.

***********************************************************************
* Das Programm prüft für die Übungen 2 - 6 die von den Teilnehmern des*
* BC430 (ABAP Dictionary) angelegten Objekte auf Korrektheit. Die     *
* angelegten Tabellen werden mit Beispieldaten gefüllt.               *
***********************************************************************

TABLES: BC430_DS, BC430_FEEDBACK, BC430_ERROR, BC430_PROT.
TABLES: X030L.

TYPES: BEGIN OF FB_TAB,
        COLOR(1),
        TEXT(100),
      END OF FB_TAB.

TYPES: FLAG(1) TYPE C.

DATA: FB_TAB TYPE FB_TAB OCCURS 20 WITH HEADER LINE.
DATA: TEXT_VAR(50) TYPE C,
      TEXT_VAR2(50) TYPE C.

DATA: NAME_EMPLOY TYPE TABNAME,        "Employee table
      NAME_CREW TYPE TABNAME,          "Crew table
      NAME_DEPMENT TYPE TABNAME,       "Department table
      NAME_DEPMENTT TYPE TABNAME,      "Text table for departments
      NAME_CHANGE TYPE TABNAME,        "Include for change info
      NAME_AIRP_APP TYPE TABNAME,      "Append Airport
      INDX_EMPNAME TYPE INDEXID,       "Name-Index for emp. table
      INDX_EMPAREA TYPE INDEXID,       "Area-Index for emp. table
      DOMA_AREA TYPE DOMNAME.          "Domain for area


DATA: ERRORS TYPE BC430_ERROR OCCURS 20 WITH HEADER LINE,
      TEMP_ERRORS TYPE BC430_ERROR OCCURS 20 WITH HEADER LINE,
      NAMES_WA TYPE BC430_NAMES,
      SUCCESS_WA TYPE BC430_SUCCESS.

DATA: TCODE LIKE SY-TCODE,
      SUBRC LIKE SY-SUBRC.

DATA: COURSE_NAME(6),
      COURSE_GROUP(2).

DATA: KAP2(1),
      KAP3(1),
      KAP4(1),
      KAP5(1),
      KAP6(1).

DATA: JUST_STARTED TYPE FLAG VALUE ' '.

DATA: BEGIN OF FIELD_TEXTS OCCURS 20,
        FIELD TYPE FIELDNAME,
        TEXT(30) TYPE C,
      END OF FIELD_TEXTS.

* Deklarationen für das Image Control
DATA: PICTURE1 TYPE REF TO C_IMAGE_CONTROL.
DATA: PICTURE2 TYPE REF TO C_IMAGE_CONTROL.

DATA URL(255) TYPE C.                  " URL-field
DATA URL2(255) TYPE C.
DATA FB_CONT_CRE(1) TYPE C VALUE 'N'. "Control for FB already created?

* Makros
DEFINE WRITE_FB.
  FB_TAB-COLOR = &1.
  FB_TAB-TEXT = &2.
  APPEND FB_TAB.
END-OF-DEFINITION.

DEFINE WRITE_FB_VAR.
  CLEAR TEXT_VAR.
  FB_TAB-COLOR = &1.
  TEXT_VAR = &2.
  CONCATENATE TEXT_VAR &3 INTO FB_TAB-TEXT SEPARATED BY ' '.
  APPEND FB_TAB.
END-OF-DEFINITION.

DEFINE WRITE_FB_TWO_VAR.
  CLEAR TEXT_VAR.
  CLEAR TEXT_VAR2.
  FB_TAB-COLOR = &1.
  TEXT_VAR = &2.
  TEXT_VAR2 = &4.
  CONCATENATE TEXT_VAR &3 TEXT_VAR2 &5 INTO FB_TAB-TEXT
    SEPARATED BY ' '.
  APPEND FB_TAB.
END-OF-DEFINITION.

DEFINE WRITE_EMPTY_LINE.
  WRITE_FB 'N' ' '.
END-OF-DEFINITION.

DEFINE WRITE_FB_EXERCISE.
  FB_TAB-COLOR = 'U'.
  CLEAR TEXT_VAR.
  TEXT_VAR = 'Übung'(001).
  CONCATENATE TEXT_VAR &1 INTO FB_TAB-TEXT SEPARATED BY ' '.
  APPEND FB_TAB.
END-OF-DEFINITION.

* Makros für das Schreiben des Feedback
DEFINE PREDEFINED_OBJ_NOT_ACTIVE.
  WRITE_FB 'E' 'Übungsumgebung nicht korrekt eingerichtet!'(010).
  WRITE_FB 'E' 'Verständigen Sie bitte den Referenten!'(011).
  WRITE_FB 'E' 'Ursache: Vorlagen nicht aktiv!!'(013).
END-OF-DEFINITION.

DEFINE UNKNOWN_ERROR.
  WRITE_FB 'E' 'Übungsumgebung nicht korrekt eingerichtet!'(010).
  WRITE_FB 'E' 'Verständigen Sie bitte den Referenten!'(011).
  WRITE_FB 'E' 'Ursache:  Kann nicht ermittelt werden!!'(014).
END-OF-DEFINITION.

DEFINE DDIC_INTERFACE_ERROR.
  WRITE_FB 'E' 'Übungsumgebung nicht korrekt eingerichtet!'(010).
  WRITE_FB 'E' 'Verständigen Sie bitte den Referenten!'(011).
  WRITE_FB 'E' 'Ursache: Problem in DD-Schnittstellen!!'(012).
END-OF-DEFINITION.

DEFINE FILL_TEXT.
  FIELD_TEXTS-FIELD = &1.
  FIELD_TEXTS-TEXT = &2.
  APPEND FIELD_TEXTS.
END-OF-DEFINITION.

* Makros zur Modifikation der Screen Attribute
DEFINE SET_SCREEN_INP_REQUIRED.
  LOOP AT SCREEN.
    IF SCREEN-NAME = &1.
      SCREEN-REQUIRED = '1'.
      SCREEN-INPUT = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
END-OF-DEFINITION.

DEFINE SET_SCREEN_INP.
  LOOP AT SCREEN.
    IF SCREEN-NAME = &1.
      SCREEN-INPUT = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
END-OF-DEFINITION.

DEFINE SET_SCREEN_NO_INP.
  LOOP AT SCREEN.
    IF SCREEN-NAME = &1.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
END-OF-DEFINITION.

* Makros zum Handling der Bilder
DEFINE LOAD_GIF_PICTURE.
  PERFORM LOAD_PIC_FROM_DB
          TABLES PIC_DATA_FB
          USING &1
          CHANGING PIC_SIZE_FB.
END-OF-DEFINITION.

***********************************************************************
* MODULE STATUS_1100                                                  *
***********************************************************************

MODULE STATUS_1100 OUTPUT.

  SET TITLEBAR 'CHECK_TITLE'.
  SET PF-STATUS 'CHECK'.
* Hole die bereits bekannten Namen für die Teilnehmerobjekte
  PERFORM GET_NAMES.
* Lese die Infos zu den bisherigen Interaktionen mit dem Report
  PERFORM GET_STATE_INFO.
  IF JUST_STARTED = ' '.
     PERFORM DETERMINE_ACTIVE_CHAPTER.
     PERFORM FILL_FIELD_TEXTS.
     JUST_STARTED = 'X'.
  ENDIF.
* Prüfe, ob die Vorlagen aktuelle Daten enthalten. Vorlagen sind die
* Tabellen SEMPLOYES, SDEPMENT, SDEPMENTT und SFLCREW.
  PERFORM CHECK_PREREQUISITES.
* Modifiziere die Screen Attribute anhand des aktiven Kapitels
  PERFORM MODIFY_SCREEN_1100.

* Baue das Einstiegsbild auf
  CREATE OBJECT PICTURE1.
  CALL METHOD PICTURE1->CREATE_CONTROL
         EXPORTING DYNNR = '1100'
                   REPID = 'BC430_CHECK'
                   STYLE = WS_BORDER
                   CONTAINER = 'PICTURE1'.
* Setze den Display Mode
  CALL METHOD PICTURE1->SET_DISPLAY_MODE
       EXPORTING DISPLAY_MODE = DISPLAY_MODE_STRETCH.
* Lade das Bild aus der R/3 Databank
  DATA PIC_DATA LIKE W3MIME OCCURS 0.
  DATA PIC_SIZE TYPE I.
* Lade das Bild aus der WebRFC Datenbank in die interne
* Tabelle pic_data.
  PERFORM LOAD_PIC_FROM_DB
          TABLES PIC_DATA
          USING 'BC430_GRAFIK'
          CHANGING PIC_SIZE.
* Hole eine URL vom Data Provider durch Export der pic_data.
  CLEAR URL.
  CALL FUNCTION 'DP_CREATE_URL'
       EXPORTING
            TYPE     = 'image'
            SUBTYPE  = CNDP_SAP_TAB_UNKNOWN
            SIZE     = PIC_SIZE
            LIFETIME = CNDP_LIFETIME_TRANSACTION
       TABLES
            DATA     = PIC_DATA
       CHANGING
            URL      = URL
       EXCEPTIONS
            OTHERS   = 1.
* Lade das Bild über die vom Data Provider generierte URL
  IF SY-SUBRC = 0.
    CALL METHOD PICTURE1->LOAD_IMAGE_FROM_URL
       EXPORTING URL = URL.
  ENDIF.

ENDMODULE.

***********************************************************************
* MODULE USER_COMMAND_1100                                            *
***********************************************************************

MODULE USER_COMMAND_1100.

  CASE TCODE.
    WHEN 'ABBR'.
      LEAVE. SET SCREEN 0. LEAVE SCREEN.
      CALL METHOD PICTURE1->DESTROY_CONTROL.
    WHEN 'BACK'.
      LEAVE. SET SCREEN 0. LEAVE SCREEN.
      CALL METHOD PICTURE1->DESTROY_CONTROL.
    WHEN 'AUSF'.
      PERFORM PUT_NAMES.
      REFRESH FB_TAB.
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
      IF KAP5 = 'X'.
        PERFORM CHECK_KAP_5.
      ENDIF.
      IF KAP6 = 'X'.
        PERFORM CHECK_KAP_6.
      ENDIF.
    WHEN 'CHAP'.
      PERFORM MODIFY_SCREEN_1100.
  ENDCASE.

ENDMODULE.

***********************************************************************
* MODULE CANCEL: Verlassen des Bildes ohne Prüfungen                  *
***********************************************************************

MODULE CANCEL INPUT.

  LEAVE PROGRAM.

ENDMODULE.


***********************************************************************
* FORM GET_NAMES                                                      *
* Liest die Namen der Objekte, die die Teilnehmer in vorhergehenden   *
* Übungen schon eingegeben haben aus der BC430_NAMES.                 *
* In der ersten Übung sind noch keine Namen vorhanden. Für die        *
* Standard-User BC430-xx werden die vorgegebenen Namen ermittelt.     *
***********************************************************************

FORM GET_NAMES.

  SELECT SINGLE * FROM BC430_NAMES INTO NAMES_WA
      WHERE COURSE_USER = SY-UNAME.

  IF SY-SUBRC NE 0.
    MOVE SY-UNAME(6) TO COURSE_NAME.
    IF COURSE_NAME = 'BC430-'.
      PERFORM GET_DEFAULT_NAMES.
    ENDIF.
  ELSE.
    NAME_EMPLOY = NAMES_WA-SEMPLOYES.
    NAME_CREW = NAMES_WA-SFLCREW.
    NAME_DEPMENT = NAMES_WA-SDEPMENT.
    NAME_DEPMENTT = NAMES_WA-SDEPMENTT.
    NAME_CHANGE = NAMES_WA-INCL_CHANGE.
    NAME_AIRP_APP = NAMES_WA-APP_AIRPORT.
    INDX_EMPNAME = NAMES_WA-NAME_INDX.
    INDX_EMPAREA = NAMES_WA-AREA_INDX.
    DOMA_AREA = NAMES_WA-DOMA_AREA.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM PUT_NAMES                                                      *
* Sichert die eingegebenen Namen in BC430_NAMES.                      *
***********************************************************************

FORM PUT_NAMES.

  NAMES_WA-COURSE_USER = SY-UNAME.
  NAMES_WA-SEMPLOYES = NAME_EMPLOY.
  NAMES_WA-SFLCREW = NAME_CREW.
  NAMES_WA-SDEPMENT = NAME_DEPMENT.
  NAMES_WA-SDEPMENTT = NAME_DEPMENTT.
  NAMES_WA-INCL_CHANGE = NAME_CHANGE.
  NAMES_WA-APP_AIRPORT = NAME_AIRP_APP.
  NAMES_WA-NAME_INDX = INDX_EMPNAME.
  NAMES_WA-AREA_INDX = INDX_EMPAREA.
  NAMES_WA-DOMA_AREA = DOMA_AREA.

  INSERT INTO BC430_NAMES VALUES NAMES_WA.
  IF SY-SUBRC NE 0.
    UPDATE BC430_NAMES FROM NAMES_WA.
  ENDIF.
  COMMIT WORK.

ENDFORM.

***********************************************************************
* FORM GET_DEFAULT_NAMES                                              *
* Falls der User ein Standard-User ist (User-Id BC430-xx) sind die    *
* Namen der anzulegenden Objekte schon bekannt. Diese Defaultnamen    *
* werden in dieser Form aus dem User ermittelt.                       *
***********************************************************************

FORM GET_DEFAULT_NAMES.

  MOVE SY-UNAME+6(2) TO COURSE_GROUP.

  MOVE 'ZEMPLOY' TO NAME_EMPLOY.
  MOVE COURSE_GROUP TO NAME_EMPLOY+7.

  MOVE 'ZDEPMENT' TO NAME_DEPMENT.
  MOVE COURSE_GROUP TO NAME_DEPMENT+8.

  MOVE 'ZDEPMENTT' TO NAME_DEPMENTT.
  MOVE COURSE_GROUP TO NAME_DEPMENTT+9.

  MOVE 'ZFLCREW' TO NAME_CREW.
  MOVE COURSE_GROUP TO NAME_CREW+7.

  MOVE 'ZCHANGE' TO NAME_CHANGE.
  MOVE COURSE_GROUP TO NAME_CHANGE+7.

ENDFORM.

***********************************************************************
* FORM GET_STATE_INFO                                                 *
* Liest Infos über Erfolg in bisherigen Übungen aus BC430_SUCCESS.    *
***********************************************************************

FORM GET_STATE_INFO.

  SELECT SINGLE * FROM BC430_SUCCESS INTO SUCCESS_WA
      WHERE COURSE_USER = SY-UNAME.

  IF SY-SUBRC NE 0.       "Set default if nothing is found
    SUCCESS_WA-COURSE_USER = SY-UNAME.
    SUCCESS_WA-CHAPTER2 = 'N'.
    SUCCESS_WA-CHAPTER3 = 'N'.
    SUCCESS_WA-CHAPTER4 = 'N'.
    SUCCESS_WA-CHAPTER5 = 'N'.
    SUCCESS_WA-CHAPTER6 = 'N'.
    SUCCESS_WA-EMPLOY_FILLED = 'N'.
    SUCCESS_WA-DEPMENT_FILLED = 'N'.
    SUCCESS_WA-DEPMENTT_FILLED = 'N'.
    SUCCESS_WA-SFLCREW_FILLED = 'N'.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM PUT_STATE_INFO                                                 *
* Schreibt Infos über Erfolg bzw. Mißerfolg in BC430_SUCCESS          *
***********************************************************************

FORM PUT_STATE_INFO.

  INSERT INTO BC430_SUCCESS VALUES SUCCESS_WA.
  IF SY-SUBRC NE 0.
    UPDATE BC430_SUCCESS FROM SUCCESS_WA.
  ENDIF.
  COMMIT WORK.

ENDFORM.

************************************************************************
* FORM DETERMINE_ACTIVE_CHAP                                           *
* Bestimmt das gerade bearbeitete Kapitel.                             *
************************************************************************

FORM DETERMINE_ACTIVE_CHAPTER.

  KAP2 = 'X'.
  KAP3 = ' '.
  KAP4 = ' '.
  KAP5 = ' '.
  KAP6 = ' '.

  IF SUCCESS_WA-CHAPTER2 = 'Y'.
    KAP2 = ' '.
    KAP3 = 'X'.
    IF SUCCESS_WA-CHAPTER3 = 'Y'.
      KAP3 = ' '.
      KAP4 = 'X'.
      IF SUCCESS_WA-CHAPTER4 = 'Y'.
        KAP4 = ' '.
        KAP5 = 'X'.
        IF SUCCESS_WA-CHAPTER5 = 'Y'.
          KAP5 = ' '.
          KAP6 = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.


ENDFORM.

************************************************************************
* FORM CHECK_PREREQUISITES                                             *
* Der Report kopiert die Daten aus SEMPLOYES, SDEPMENT, SDEPMENTT,     *
* und SFLCREW in die entsprechenden Tabellen der Teilnehmer.           *
* Damit dies korrekt funktioniert sind zwei Prüfungen erforderlich:    *
*  1) Falls eine der Tabellen leer ist, werden die Daten aufgebaut     *
*  2) Falls der Aufbau der Daten zu lange zurückliegt, kann es sein das*
*     sie nicht zu den anderen Daten im Flugmodell (SPFLI, SFLIGHT)    *
*     passen. Falls die Daten nicht an diesem oder dem Vortag aufgebaut*
*     wurden, werden sie erneut aufgebaut.                             *
************************************************************************

FORM CHECK_PREREQUISITES.

  DATA: START_FILL_REPORT(1) VALUE '0',
        NEWEST_CR_DATE TYPE SY-DATUM,
        ENTR_EMPLOYES TYPE I,
        ENTR_DEPMENT TYPE I,
        ENTR_DEPMENTT TYPE I,
        ENTR_CREW TYPE I.

* Erste Prüfung: Enthalten die Tabellen Daten
* BC430_FILL wird gestartet falls eine Tabelle leer ist.
  SELECT COUNT(*) FROM SEMPLOYES INTO ENTR_EMPLOYES UP TO 2 ROWS.
  SELECT COUNT(*) FROM SDEPMENT INTO ENTR_DEPMENT UP TO 2 ROWS.
  SELECT COUNT(*) FROM SDEPMENTT INTO ENTR_DEPMENTT UP TO 2 ROWS.
  SELECT COUNT(*) FROM SFLCREW INTO ENTR_CREW UP TO 2 ROWS.

  IF ENTR_EMPLOYES = 0 OR ENTR_DEPMENT = 0 OR
     ENTR_DEPMENTT = 0 OR ENTR_CREW = 0.
    START_FILL_REPORT = '1'.
  ENDIF.

* Zweite Prüfung: Wann wurden Daten zuletzt aufgebaut
* Info über letzten Aufbau steht in BC430_DS
  SELECT * FROM BC430_DS.
    IF BC430_DS-CR_DATE GT NEWEST_CR_DATE.
      NEWEST_CR_DATE = BC430_DS-CR_DATE.
    ENDIF.
  ENDSELECT.

* Falls BC430_DS leer ist, wird BC430_FILL gestartet
  IF SY-SUBRC > 0.
    START_FILL_REPORT = '1'.
  ENDIF.

* Falls BC430_FILL nicht an diesem oder dem vorhergehenden
* Tag lief, wird er erneut aufgerufen
  NEWEST_CR_DATE = NEWEST_CR_DATE + 1.
  IF NEWEST_CR_DATE LT SY-DATUM.
    START_FILL_REPORT = '1'.
  ENDIF.

* Starte BC430_FILL
  IF START_FILL_REPORT = '1'.
    SUBMIT BC430_FILL AND RETURN.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM MODIFY_SCREEN_1100                                             *
* Ändere die Attribute des Screens in Abhängigkeit vom Kapitel.       *
***********************************************************************

FORM MODIFY_SCREEN_1100.

  IF KAP2 = 'X'.
    SET_SCREEN_INP_REQUIRED 'NAME_EMPLOY'.
    SET_SCREEN_INP_REQUIRED 'NAME_DEPMENT'.
    SET_SCREEN_INP_REQUIRED 'NAME_CHANGE'.
    SET_SCREEN_NO_INP 'NAME_CREW'.
    SET_SCREEN_NO_INP 'NAME_DEPMENTT'.
    SET_SCREEN_NO_INP 'NAME_AIRP_APP'.
    SET_SCREEN_NO_INP 'INDX_EMPNAME'.
    SET_SCREEN_NO_INP 'INDX_EMPAREA'.
    SET_SCREEN_NO_INP 'DOMA_AREA'.
  ENDIF.
  IF KAP3 = 'X'.
    SET_SCREEN_INP_REQUIRED 'NAME_EMPLOY'.
    SET_SCREEN_INP_REQUIRED 'NAME_DEPMENT'.
    SET_SCREEN_INP_REQUIRED 'NAME_CHANGE'.
    SET_SCREEN_INP_REQUIRED 'NAME_CREW'.
    SET_SCREEN_NO_INP 'NAME_DEPMENTT'.
    SET_SCREEN_NO_INP 'NAME_AIRP_APP'.
    SET_SCREEN_INP_REQUIRED 'INDX_EMPNAME'.
    SET_SCREEN_INP 'INDX_EMPAREA'.
    SET_SCREEN_NO_INP 'DOMA_AREA'.
  ENDIF.
  IF KAP4 = 'X'.
    SET_SCREEN_INP_REQUIRED 'NAME_EMPLOY'.
    SET_SCREEN_INP_REQUIRED 'NAME_DEPMENT'.
    SET_SCREEN_NO_INP 'NAME_CHANGE'.
    SET_SCREEN_INP_REQUIRED 'NAME_CREW'.
    SET_SCREEN_INP 'NAME_DEPMENTT'.
    SET_SCREEN_NO_INP 'NAME_AIRP_APP'.
    SET_SCREEN_NO_INP 'INDX_EMPNAME'.
    SET_SCREEN_NO_INP 'INDX_EMPAREA'.
    SET_SCREEN_INP_REQUIRED 'DOMA_AREA'.
  ENDIF.
  IF KAP5 = 'X'.
    SET_SCREEN_INP_REQUIRED 'NAME_EMPLOY'.
    SET_SCREEN_NO_INP 'NAME_DEPMENT'.
    SET_SCREEN_NO_INP 'NAME_CHANGE'.
    SET_SCREEN_INP_REQUIRED 'NAME_CREW'.
    SET_SCREEN_NO_INP 'NAME_DEPMENTT'.
    SET_SCREEN_NO_INP 'NAME_AIRP_APP'.
    SET_SCREEN_NO_INP 'INDX_EMPNAME'.
    SET_SCREEN_NO_INP 'INDX_EMPAREA'.
    SET_SCREEN_NO_INP 'DOMA_AREA'.
  ENDIF.
  IF KAP6 = 'X'.
    SET_SCREEN_INP_REQUIRED 'NAME_EMPLOY'.
    SET_SCREEN_NO_INP 'NAME_DEPMENT'.
    SET_SCREEN_NO_INP 'NAME_CHANGE'.
    SET_SCREEN_INP_REQUIRED 'NAME_CREW'.
    SET_SCREEN_NO_INP 'NAME_DEPMENTT'.
    SET_SCREEN_INP_REQUIRED 'NAME_AIRP_APP'.
    SET_SCREEN_NO_INP 'INDX_EMPNAME'.
    SET_SCREEN_NO_INP 'INDX_EMPAREA'.
    SET_SCREEN_NO_INP 'DOMA_AREA'.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_2                                                    *
* Prüfe Korrektheit der Lösung für Kapitel 2.                         *
***********************************************************************

FORM CHECK_KAP_2.

* Lokale Daten Deklarationen
  DATA: SUCCESS TYPE FLAG,
        EMP_FILL TYPE FLAG VALUE 'N',
        DEP_FILL TYPE FLAG VALUE 'N',
        GLOBAL_SUCCESS TYPE FLAG VALUE 'Y',
        FILL_INFO_EMP TYPE FLAG VALUE 'Y',
        FILL_INFO_DEP TYPE FLAG VALUE 'Y'.

* Finde heraus, ob ZEMPLOYxx und ZDEPMENTxx schon gefüllt waren
  IF SUCCESS_WA-EMPLOY_FILLED = 'Y'.
    FILL_INFO_EMP = 'A'.
  ENDIF.
  IF SUCCESS_WA-DEPMENT_FILLED = 'Y'.
    FILL_INFO_DEP = 'A'.
  ENDIF.

* Prüfe Feldstruktur ZEMPLOYxx, Übung 2-1-1
  WRITE_FB_EXERCISE '2-1-1'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_EMPLOY.

  PERFORM CHECK_TABLE USING NAME_EMPLOY 'SEMPLOYES' FILL_INFO_EMP
                   CHANGING FB_TAB SUCCESS.

  EMP_FILL = SUCCESS.
  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe Feldstruktur ZDEPMENTxx, Übung 2-1-2
  WRITE_FB_EXERCISE '2-1-2'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_DEPMENT.

  PERFORM CHECK_TABLE USING NAME_DEPMENT 'SDEPMENT' FILL_INFO_DEP
                   CHANGING FB_TAB SUCCESS.

  DEP_FILL = SUCCESS.
  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe Include ZCHANGExx, Übung 2-3
  WRITE_FB_EXERCISE '2-3'.

* Prüfe Inclusion in ZEMPLOYxx
  PERFORM CHECK_INCLUDE USING NAME_CHANGE 'SCHANGED' NAME_EMPLOY
                             'INCLUDE'
                  CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* Prüfe Inclusion in ZDEPMENTxx
  PERFORM CHECK_INCLUDE USING NAME_CHANGE 'SCHANGED' NAME_DEPMENT
                              'INCLUDE'
                  CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Resultate in DB-Tabelle BC430_SUCCESS schreiben. Falls alle Übungen
* erfolgreich gelöst sind, kann diese Info nicht mehr verändert werden
  IF SUCCESS_WA-CHAPTER2 = 'N'.
    SUCCESS_WA-CHAPTER2 = GLOBAL_SUCCESS.
  ENDIF.
  SUCCESS_WA-EMPLOY_FILLED = EMP_FILL.
  SUCCESS_WA-DEPMENT_FILLED = DEP_FILL.
  PERFORM PUT_STATE_INFO.

* Feedback ausgeben
  PERFORM WRITE_FEEDBACK USING GLOBAL_SUCCESS.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_3                                                    *
* Prüfe die Korrektheit der Lösung für Kapitel 3.                     *
***********************************************************************

FORM CHECK_KAP_3.

* Lokale Datendeklarationen
  DATA: SUCCESS TYPE FLAG,
        GLOBAL_SUCCESS TYPE FLAG VALUE 'Y',
        CRE_FILL TYPE FLAG VALUE 'N',
        FILL_INFO_CRE TYPE FLAG VALUE 'Y'.

* Finde heraus, ob ZFLCREWxx vorher schon gefüllt war
  IF SUCCESS_WA-SFLCREW_FILLED = 'Y'.
    FILL_INFO_CRE = 'A'.
  ENDIF.

* Prüfe den Namensindex zu ZEMPLOYxx, Übung 3-1
  WRITE_FB_EXERCISE '3-1'.

  PERFORM CHECK_INDEX USING NAME_EMPLOY INDX_EMPNAME 'SEMPLOYES' 'NAM'
                CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe die Tabelle ZFLCREWxx, Übung 3-2
  WRITE_FB_EXERCISE '3-2'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_CREW.

  PERFORM CHECK_TABLE USING NAME_CREW 'SFLCREW' FILL_INFO_CRE
                   CHANGING FB_TAB SUCCESS.

  CRE_FILL = SUCCESS.
  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe die technischen Einst. zu ZDEPMENTxx und ZFLCREWxx, Übung 3-3
  WRITE_FB_EXERCISE '3-3'.

  PERFORM CHECK_TECHN_SETTINGS USING NAME_DEPMENT 'SDEPMENT'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* Changed on Dec. 5, 2002 by Michael Fry
* Reason: Technical settings were wrong on SFLCREW (original table)
*   SFLCREW was copied to SFLCREW_BUFF for correct buffer settings
  PERFORM CHECK_TECHN_SETTINGS USING NAME_CREW 'SFLCREW_BUFF'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe den Bereichsindex, falls Zusatzübung bearbeitet, Übung 3-4
  IF NOT INDX_EMPAREA IS INITIAL.
    WRITE_FB_EXERCISE '3-4'.

    PERFORM CHECK_INDEX USING NAME_EMPLOY INDX_EMPAREA 'SEMPLOYES' 'ARE'
                     CHANGING FB_TAB SUCCESS.

    IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

    WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

  ENDIF.

* Resultate in DB-Tabelle BC430_SUCCESS schreiben. Falls alle Übungen
* erfolgreich gelöst sind, kann diese Info nicht mehr verändert werden
  IF SUCCESS_WA-CHAPTER3 = 'N'.
    SUCCESS_WA-CHAPTER3 = GLOBAL_SUCCESS.
    SUCCESS_WA-SFLCREW_FILLED = CRE_FILL.
  ENDIF.
  PERFORM PUT_STATE_INFO.

* Feedback ausgeben
  PERFORM WRITE_FEEDBACK USING GLOBAL_SUCCESS.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_4                                                    *
* Prüfe die Korrektheit der Lösung für Kapitel 4.                     *
***********************************************************************

FORM CHECK_KAP_4.

* Lokale Daten Deklarationen
  DATA: SUCCESS TYPE FLAG,
        GLOBAL_SUCCESS TYPE FLAG VALUE 'Y',
        DPT_FILL TYPE FLAG VALUE 'N',
        FILL_INFO_DPT TYPE FLAG VALUE 'Y'.

* Finde heraus, ob ZFLCREWxx vorher schon gefüllt war
  IF SUCCESS_WA-DEPMENTT_FILLED = 'Y'.
    FILL_INFO_DPT = 'A'.
  ENDIF.

* Prüfe die Domäne, Übung 4-1
  WRITE_FB_EXERCISE '4-1'.

  PERFORM CHECK_DOMAIN USING DOMA_AREA 'S_AREA'
                 CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile

* Prüfe die Fremdschlüssel von ZEMPLOYxx, Übung 4-2
  WRITE_FB_EXERCISE '4-2'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_EMPLOY.
* 1) zu T000
  PERFORM CHECK_FOREIGN_KEY USING NAME_EMPLOY 'T000'
                                  'SEMPLOYES' 'T000'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* 2)zu SCARR
  PERFORM CHECK_FOREIGN_KEY USING NAME_EMPLOY 'SCARR'
                                  'SEMPLOYES' 'SCARR'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* 3) zu ZDEPMENTxx
  PERFORM CHECK_FOREIGN_KEY USING NAME_EMPLOY NAME_DEPMENT
                                  'SEMPLOYES' 'SDEPMENT'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* 4) zu SCURX
  PERFORM CHECK_FOREIGN_KEY USING NAME_EMPLOY 'SCURX'
                                  'SEMPLOYES' 'SCURX'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* 5) Ende der Prüfungen für ZEMPLOYxx, gebe Leerzeile aus
  WRITE_EMPTY_LINE.                    "Leerzeile

* Prüfe die Fremdschlüssel von ZDEPMENTxx, Übung 4-2
  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_DEPMENT.
* 1) zu T000
  PERFORM CHECK_FOREIGN_KEY USING NAME_DEPMENT 'T000'
                                  'SDEPMENT' 'T000'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* 2) zu SCARR
  PERFORM CHECK_FOREIGN_KEY USING NAME_DEPMENT 'SCARR'
                                  'SDEPMENT' 'SCARR'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* 3) Ende der Prüfungen von ZDEPMENTxx, gebe Leerzeile aus
  WRITE_EMPTY_LINE.                    "Leerzeile

* Prüfe, ob das neue Feld an ZEMPLOYxx angehängt ist, Übung 4-3
  WRITE_FB_EXERCISE '4-3'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_EMPLOY.

  PERFORM CHECK_TABLE USING NAME_EMPLOY 'SEMPLOYES_RB' 'N'
                   CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* Prüfe FS für neues Feld zw. ZEMPLOYxx und STRAVELAG
  PERFORM CHECK_FOREIGN_KEY USING NAME_EMPLOY 'STRAVELAG'
                                  'SEMPLOYES_RB' 'STRAVELAG'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe die Feldstruktur der Texttabelle ZDEPMENTTxx, Übung 4-4
  WRITE_FB_EXERCISE '4-4'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_DEPMENTT.

  PERFORM CHECK_TABLE USING NAME_DEPMENTT 'SDEPMENTT' FILL_INFO_DPT
                     CHANGING FB_TAB SUCCESS.

  DPT_FILL = SUCCESS.
  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* Prüfe den Fremdschlüssel zw. ZDEPMENTxx und ZDEPMENTTxx
  PERFORM CHECK_FOREIGN_KEY USING NAME_DEPMENTT NAME_DEPMENT
                                 'SDEPMENTT' 'SDEPMENT'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Resultate in DB-Tabelle BC430_SUCCESS schreiben. Falls alle Übungen
* erfolgreich gelöst sind, kann diese Info nicht mehr verändert werden
  IF SUCCESS_WA-CHAPTER4 = 'N'.
    SUCCESS_WA-CHAPTER4 = GLOBAL_SUCCESS.
    SUCCESS_WA-DEPMENT_FILLED = DPT_FILL.
  ENDIF.
  PERFORM PUT_STATE_INFO.

* Feedback ausgeben
  PERFORM WRITE_FEEDBACK USING GLOBAL_SUCCESS.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_5                                                    *
* Prüfe die Korrektheit der Lösung für Kapitel 5.                     *
***********************************************************************

FORM CHECK_KAP_5.

* Lokale Daten Deklarationen
  DATA: SUCCESS TYPE FLAG,
        GLOBAL_SUCCESS TYPE FLAG VALUE 'Y'.

* Prüfe, ob Feld für Chef an ZDEPMENTxx angehängt ist, Übung 5-1
  WRITE_FB_EXERCISE '5-1'.

  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_DEPMENT.

  PERFORM CHECK_TABLE USING NAME_DEPMENT 'SDEPMENT_CH' 'N'
                   CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

* Prüfe FS für das neue Feld
  PERFORM CHECK_FOREIGN_KEY USING NAME_DEPMENT NAME_EMPLOY
                                  'SDEPMENT_CH' 'SEMPLOYES_RB'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe, ob neues Feld in ZCHANGExx eingefügt ist, Übung 5-2
  WRITE_FB_EXERCISE '5-2'.

  WRITE_FB_VAR 'I' 'Prüfen des Include'(059) NAME_CHANGE.

  PERFORM CHECK_TABLE USING NAME_CHANGE 'SCHANGED_TI' 'N'
                   CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Resultate in DB-Tabelle BC430_SUCCESS schreiben. Falls alle Übungen
* erfolgreich gelöst sind, kann diese Info nicht mehr verändert werden
  IF SUCCESS_WA-CHAPTER5 = 'N'.
    SUCCESS_WA-CHAPTER5 = GLOBAL_SUCCESS.
  ENDIF.
  PERFORM PUT_STATE_INFO.

* Feedback ausgeben
  PERFORM WRITE_FEEDBACK USING GLOBAL_SUCCESS.

ENDFORM.

***********************************************************************
* FORM CHECK_KAP_6                                                    *
* Prüfe die Korrektheit der Lösung für Kapitel 6.                     *
***********************************************************************

FORM CHECK_KAP_6.

* Lokale Daten Deklarationen
  DATA: SUCCESS TYPE FLAG,
        GLOBAL_SUCCESS TYPE FLAG VALUE 'Y'.

* Prüfe, ob die Umsetzung durchgeführt wurde, Übung 6-1
  WRITE_FB_VAR 'I' 'Prüfen der Tabelle'(050) NAME_CREW.

  PERFORM CHECK_TABLE USING NAME_CREW 'SFLCREW_CONV' 'N'
                   CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe, ob das Append an ZEMPLOYxx angehängt ist, Übung 6-2
  WRITE_FB_VAR 'I' 'Prüfen der Append-Struktur'(060) NAME_AIRP_APP.

  PERFORM CHECK_INCLUDE USING NAME_AIRP_APP 'SFLUGHAFEN' NAME_EMPLOY
                             'APPEND'
                  CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Prüfe den FS im Append, Übung 6-3
  WRITE_FB_VAR 'I' 'Prüfen der Append-Struktur'(060) NAME_AIRP_APP.

  PERFORM CHECK_FOREIGN_KEY USING NAME_AIRP_APP 'SAIRPORT'
                                  'SFLUGHAFEN' 'SAIRPORT'
                         CHANGING FB_TAB SUCCESS.

  IF SUCCESS = 'N'. GLOBAL_SUCCESS = 'N'. ENDIF.

  WRITE_EMPTY_LINE.                    "Leerzeile ausgeben

* Resultate in DB-Tabelle BC430_SUCCESS schreiben. Falls alle Übungen
* erfolgreich gelöst sind, kann diese Info nicht mehr verändert werden
  IF SUCCESS_WA-CHAPTER6 = 'N'.
    SUCCESS_WA-CHAPTER6 = GLOBAL_SUCCESS.
  ENDIF.
  PERFORM PUT_STATE_INFO.

* Feedback ausgeben
  PERFORM WRITE_FEEDBACK USING GLOBAL_SUCCESS.

ENDFORM.

***********************************************************************
* FORM CHECK_TABLE                                                    *
* Prüft die Struktur einer Tabelle gegen eine Vorlage und kopiert     *
* (falls möglich) die Daten aus der Vorlage in die Tabelle.           *
***********************************************************************

FORM CHECK_TABLE USING PART_TABLE OUR_TABLE FILL_OPT
                 CHANGING FEEDBACK SUCCESS.

  CLEAR ERRORS.
  REFRESH ERRORS.
  SUCCESS = 'N'.

  DATA: FIELDTEXT(50) TYPE C.

* Aufruf des FUBA zum Strukturvergleich
  CALL FUNCTION 'BC430_COMP_AND_FILL'
       EXPORTING
            T_TAB               = PART_TABLE
            M_TAB               = OUR_TABLE
            FILL                = FILL_OPT
       TABLES
            ERRORS              = ERRORS
       EXCEPTIONS
            T_TAB_NOT_EXIST     = 1
            T_TAB_NOT_ACTIVE    = 2
            M_TAB_NOT_ACTIVE    = 3
            SYSTEM_INCONSISTENT = 4
            OTHERS              = 5.

  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
        WRITE_FB 'E' 'Die Tabelle ist nicht vorhanden!'(101).
      WHEN '2'.
     WRITE_FB 'E' 'Sie haben vergessen die Tabelle zu aktivieren!'(100).
      WHEN '3'.
        PREDEFINED_OBJ_NOT_ACTIVE.
      WHEN '4'.
        DDIC_INTERFACE_ERROR.
      WHEN '5'.
        UNKNOWN_ERROR.
    ENDCASE.
  ELSE.
    IF ERRORS IS INITIAL.
      SUCCESS = 'Y'.
      WRITE_FB 'S' 'Tabelle ist korrekt definiert!'(103).
      IF FILL_OPT = 'Y'.
        WRITE_FB 'S' 'Die Tabelle wird mit Beispieldaten gefüllt.'(104).
      ELSEIF FILL_OPT = 'A'.
        WRITE_FB 'S' 'Beispieldaten waren bereits aufgebaut.'(153).
      ENDIF.
    ELSE.
      WRITE_FB 'E' 'Die Tabelle ist falsch definiert!'(105).
      LOOP AT ERRORS.
        LOOP AT FIELD_TEXTS.
          IF ERRORS-FIELDNAME = FIELD_TEXTS-FIELD.
            FIELDTEXT = FIELD_TEXTS-TEXT.
          ENDIF.
        ENDLOOP.
        IF ERRORS-ERROR = 'FIELD'.
          WRITE_FB_VAR 'E' 'Feld'(058) FIELDTEXT.
          WRITE_FB 'E' 'Kein Feld mit erwartetem Typ und Keyflag
                        gefunden!'(107).
          WRITE_FB 'E'  'In Ihrer Tabelle hat das Feld einen falschen
                         Typ oder'(154).
          WRITE_FB 'E'  'Sie haben vergessen das Feld in Ihre Tabelle
                         aufzunehmen!'(155).
        ENDIF.
        IF ERRORS-ERROR = 'KEY'.
          WRITE_FB_VAR 'E' 'Feld'(058) FIELDTEXT.
          WRITE_FB 'E' 'Schlüsselkennzeichen falsch!'(106).
        ENDIF.
        IF ERRORS-ERROR = 'KEY_TOO_SMALL'.
          WRITE_FB 'E' 'Die Tabelle hat zu wenige
                        Schlüsselfelder!'(156).
        ENDIF.
        IF ERRORS-ERROR = 'KEY_TOO_BIG'.
          WRITE_FB 'E' 'Die Tabelle hat zu viele Schlüsselfelder!'(157).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_INDEX                                                    *
* Vergleicht die Struktur eines Index gegen eine Vorlage              *
***********************************************************************

FORM CHECK_INDEX USING PART_TABLE PART_INDEX OUR_TABLE OUR_INDEX
              CHANGING FEEDBACK SUCCESS.

  CLEAR ERRORS.
  REFRESH ERRORS.
  SUCCESS = 'N'.

  WRITE_FB_TWO_VAR 'I' 'Prüfe Index'(301) PART_INDEX 'zu Tabelle'(302)
                   PART_TABLE.

* Aufruf FUBA zum Strukturvergleich
  CALL FUNCTION 'BC430_INDX_COMP'
       EXPORTING
            T_TAB               = PART_TABLE
            M_TAB               = OUR_TABLE
            T_IND               = PART_INDEX
            M_IND               = OUR_INDEX
       TABLES
            ERRORS              = ERRORS
       EXCEPTIONS
            T_INDX_NOT_ACTIVE   = 1
            M_INDX_NOT_ACTIVE   = 2
            SYSTEM_INCONSISTENT = 3
            T_INDX_NOT_EXIST    = 4
            OTHERS              = 5.

  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
       WRITE_FB 'E' 'Sie haben vergessen den Index zu aktivieren!'(108).
      WHEN '2'.
        PREDEFINED_OBJ_NOT_ACTIVE.
      WHEN '3'.
        DDIC_INTERFACE_ERROR.
      WHEN '4'.
        WRITE_FB 'E' 'Der Index ist nicht vorhanden!'(109).
      WHEN '5'.
        UNKNOWN_ERROR.
    ENDCASE.
  ELSE.
    IF ERRORS IS INITIAL.
      SUCCESS = 'Y'.
      WRITE_FB 'S' 'Der Index ist korrekt definiert!'(110).
    ELSE.
      WRITE_FB 'E' 'Der Index ist nicht korrekt definiert!'(111).
      LOOP AT ERRORS.
        IF ERRORS-ERROR = 'UNIQUE_FLAG'.
          WRITE_FB 'E' 'UNIQUE-Flag nicht korrekt!'(118).
        ENDIF.
        IF ERRORS-ERROR = 'DB_STATE'.
          WRITE_FB 'E' 'Option zum Anlegen auf DB nicht korrekt!'(117).
        ENDIF.
        IF ERRORS-ERROR = 'DB_LIST'.
          WRITE_FB 'E' 'Liste der DB-Systeme nicht korrekt!'(116).
        ENDIF.
        IF ERRORS-ERROR = 'FIELD_NUMBER'.     "Feldanzahl falsch
          IF ERRORS-HINT = 'TO_MANY'.
            WRITE_FB 'E' 'Der Index hat zu viele Felder!'(113).
          ELSE.
            WRITE_FB 'E' 'Der Index hat nicht genügend Felder!'(112).
          ENDIF.
        ENDIF.
        IF ERRORS-ERROR = 'WRONG_FIELDS'.     "Feldtypen falsch
          WRITE_FB 'E' 'Der Index enthält die falschen Felder!'(114).
        ENDIF.
        IF ERRORS-ERROR = 'WRONG_ORDER'.      "Feldreihenfolge falsch
          WRITE_FB 'E' 'Die Feldreihenfolge ist fehlerhaft!'(115).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_TECHN_SETTINGS                                           *
* Vergleicht die techn. Einstellungen einer Tabelle gegen ein Vorlage *
***********************************************************************

FORM CHECK_TECHN_SETTINGS USING PART_TABLE OUR_TABLE
                       CHANGING FEEDBACK SUCCESS.

  CLEAR ERRORS.
  REFRESH ERRORS.
  SUCCESS = 'N'.

  WRITE_FB_VAR 'I' 'Prüfen der techn. Einstellungen zu'(052) PART_TABLE.

  CALL FUNCTION 'BC430_TABT_COMP'
       EXPORTING
            T_TAB               = PART_TABLE
            M_TAB               = OUR_TABLE
       TABLES
            ERRORS              = ERRORS
       EXCEPTIONS
            T_TSET_NOT_ACTIVE   = 1
            M_TSET_NOT_ACTIVE   = 2
            SYSTEM_INCONSISTENT = 3
            OTHERS              = 4.

  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
        WRITE_FB 'E' 'Die techn. Einstellungen sind nicht aktiv!'(119).
      WHEN '2'.
        PREDEFINED_OBJ_NOT_ACTIVE.
      WHEN '3'.
        DDIC_INTERFACE_ERROR.
      WHEN '4'.
        UNKNOWN_ERROR.
    ENDCASE.
  ELSE.
    IF ERRORS IS INITIAL.
      SUCCESS = 'Y'.
      WRITE_FB 'S' 'Die techn. Einstellungen sind korrekt!'(120).
    ELSE.
      WRITE_FB 'E' 'Die techn. Einstellungen sind nicht korrekt!'(121).
      LOOP AT ERRORS.
        CASE ERRORS-ERROR.
          WHEN 'SIZE_CATEGORY'.        "Größenkat. falsch
            WRITE_FB_VAR 'E' 'Größenkategorie falsch. Erwartet:'(122)
                         ERRORS-HINT.
          WHEN 'DATA_CLASS'.           "Datenart falsch
            WRITE_FB_VAR 'E' 'Datenart falsch. Erwartet:'(123)
                         ERRORS-HINT.
          WHEN 'PROTOCOL'.             "Protokollierung falsch
            WRITE_FB 'E' 'Protokollierung falsch eingestellt!'(124).
          WHEN 'BUFF_ALLOW'.           "Pufferungserlaubnis falsch
            WRITE_FB 'E' 'Pufferungserlaubnis falsch eingestellt!'(125).
          WHEN 'BUFF_TYPE'.            "Pufferungsart falsch
            WRITE_FB 'E' 'Pufferungsart falsch eingestellt!'(126).
          WHEN 'KEY_FIELDS'.           "Schl.anz gen. Puffer. falsch
            WRITE_FB 'E' 'Falscher generischer Schlüssel!'(127).
        ENDCASE.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_DOMAIN                                                   *
* Vergleicht eine Domäne mit einer Vorlage                            *
***********************************************************************

FORM CHECK_DOMAIN USING PART_DOMA OUR_DOMA
               CHANGING FEEDBACK SUCCESS.

  CLEAR ERRORS.
  REFRESH ERRORS.
  SUCCESS = 'N'.

  WRITE_FB_VAR 'I' 'Prüfen der Domäne'(053) PART_DOMA.

  CALL FUNCTION 'BC430_DOMA_COMP'
       EXPORTING
            T_DOMA              = PART_DOMA
            M_DOMA              = OUR_DOMA
       TABLES
            ERRORS              = ERRORS
       EXCEPTIONS
            T_DOMA_NOT_EXIST    = 1
            T_DOMA_NOT_ACTIVE   = 2
            M_DOMA_NOT_ACTIVE   = 3
            SYSTEM_INCONSISTENT = 4
            OTHERS              = 5.
  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
        WRITE_FB 'E' 'Die angegebene Domäne ist nicht vorhanden!'(128).
      WHEN '2'.
        WRITE_FB 'E' 'Sie haben vergessen die Domäne zu
                      aktivieren!'(129).
      WHEN '3'.
        PREDEFINED_OBJ_NOT_ACTIVE.
      WHEN '4'.
        DDIC_INTERFACE_ERROR.
      WHEN '5'.
        UNKNOWN_ERROR.
    ENDCASE.
  ELSE.
    IF ERRORS IS INITIAL.
      SUCCESS = 'Y'.
      WRITE_FB 'S' 'Die Domäne ist korrekt definiert!'(130).
    ELSE.
      WRITE_FB 'E' 'Die Domäne ist nicht korrekt definiert!'(131).
      LOOP AT ERRORS.
        IF ERRORS-ERROR = 'DATATYPE'.
          WRITE_FB 'E' 'Der Datentyp ist nicht korrekt!'(132).
        ENDIF.
        IF ERRORS-ERROR = 'LENGTH'.
          WRITE_FB 'E' 'Die Länge ist nicht korrekt!'(133).
        ENDIF.
        IF ERRORS-ERROR = 'DECIMALS'.
          WRITE_FB 'E' 'Anzahl Dezimalstellen ist nicht korrekt!'(134).
        ENDIF.
        IF ERRORS-ERROR = 'VALUE'.
          WRITE_FB 'E' 'Die Festwerte sind nicht korrekt!'(135).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_FOREIGN_KEY                                              *
* Vergleicht eine Fremdschlüsselbeziehung gegen eine Vorlage          *
***********************************************************************

FORM CHECK_FOREIGN_KEY USING PART_FT PART_PT OUR_FT OUR_PT
                    CHANGING FEEDBACK SUCCESS.

  CLEAR ERRORS.
  REFRESH ERRORS.
  SUCCESS = 'N'.

  WRITE_FB_VAR 'I' 'Fremdschlüsselprüfung gegen'(054) PART_PT.

  CALL FUNCTION 'BC430_FKEY_COMP'
       EXPORTING
            T_FS_TAB            = PART_FT
            T_PT_TAB            = PART_PT
            M_FS_TAB            = OUR_FT
            M_PT_TAB            = OUR_PT
       TABLES
            ERRORS              = ERRORS
       EXCEPTIONS
            T_TAB_NOT_ACTIVE    = 1
            M_TAB_NOT_ACTIVE    = 2
            SYSTEM_INCONSISTENT = 3
            OTHERS              = 4.

  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
     WRITE_FB 'E' 'Sie haben vergessen die Tabelle zu aktivieren!'(100).
      WHEN '2'.
        PREDEFINED_OBJ_NOT_ACTIVE.
      WHEN '3'.
        DDIC_INTERFACE_ERROR.
      WHEN '4'.
        UNKNOWN_ERROR.
    ENDCASE.
  ELSE.
    IF ERRORS IS INITIAL.
      SUCCESS = 'Y'.
      WRITE_FB 'S' 'Fremdschlüssel ist korrekt definiert!'(136).
    ELSE.
      WRITE_FB 'E' 'Fremdschlüssel ist fehlerhaft!'(137).
      LOOP AT ERRORS.
        IF ERRORS-ERROR = 'FK_NOT_EX'.
          WRITE_FB 'E' 'Fremdschlüssel ist nicht vorhanden!'(138).
        ENDIF.
        IF ERRORS-ERROR = 'FK_STR_NOT_OK'.
          WRITE_FB 'E' 'Feldzuordnung ist nicht korrekt!'(139).
        ENDIF.
        IF ERRORS-ERROR = 'MUST_BE_TEXT'.
          WRITE_FB 'E' 'Fremdschl. muß Textfremdschl. sein!'(140).
        ENDIF.
        IF ERRORS-ERROR = 'SHOULD_NOT_BE_TEXT'.
          WRITE_FB 'E' 'Fremdsch. darf kein Textfremdschl. sein!'(141).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

***********************************************************************
* FORM CHECK_INCLUDE                                                  *
* Vergleicht ein Include bzw. Append gegen eine Vorlage               *
***********************************************************************

FORM CHECK_INCLUDE USING PART_INC OUR_INC PART_TAB INC_TYPE
                CHANGING FEEDBACK SUCCESS.

  CLEAR ERRORS.
  CLEAR TEMP_ERRORS.
  REFRESH ERRORS.
  REFRESH TEMP_ERRORS.
  SUCCESS = 'N'.

  IF INC_TYPE = 'INCLUDE'.
   WRITE_FB_TWO_VAR 'I' 'Prüfe Include'(303) PART_INC 'zu Tabelle'(302)
                     PART_TAB.
  ELSE.
    WRITE_FB_TWO_VAR 'I' 'Prüfe Append'(304) PART_INC 'zu Tabelle'(302)
                     PART_TAB.
  ENDIF.

  CALL FUNCTION 'BC430_CHECK_INCLUDE'
       EXPORTING
            T_INCLUDE           = PART_INC
            M_INCLUDE           = OUR_INC
            T_TAB               = PART_TAB
            INC_TYPE            = INC_TYPE
       TABLES
            ERRORS              = ERRORS
            TEMP_ERRORS         = TEMP_ERRORS
       EXCEPTIONS
            T_INC_NOT_EXIST     = 1
            T_INC_NOT_ACTIVE    = 2
            M_INC_NOT_ACTIVE    = 3
            T_TAB_NOT_ACTIVE    = 4
            SYSTEM_INCONSISTENT = 5
            OTHERS              = 6.

  IF SY-SUBRC <> 0.
    SUBRC = SY-SUBRC.
    CASE SUBRC.
      WHEN '1'.
        WRITE_FB 'E' 'Die Struktur existiert nicht!'(142).
      WHEN '2'.
      WRITE_FB 'E' 'Sie haben vergessen die Struktur zu
                    aktivieren!'(143).
      WHEN '3'.
        PREDEFINED_OBJ_NOT_ACTIVE.
      WHEN '4'.
        WRITE_FB_VAR 'E' 'Folgende Tabelle ist nicht aktiv:'(144)
                     PART_TAB.
      WHEN OTHERS.
        UNKNOWN_ERROR.
    ENDCASE.
  ELSE.
    IF ERRORS IS INITIAL.
      SUCCESS = 'Y'.
      IF INC_TYPE = 'INCLUDE'.
        WRITE_FB 'S' 'Include ist korrekt definiert!'(145).
      ELSE.
        WRITE_FB 'S' 'Append ist korrekt definiert!'(151).
      ENDIF.
    ELSE.
      IF INC_TYPE = 'INCLUDE'.
        WRITE_FB 'E' 'Include ist fehlerhaft!'(146).
      ELSE.
        WRITE_FB 'E' 'Append ist fehlerhaft!'(152).
      ENDIF.
      LOOP AT ERRORS.
        IF ERRORS-ERROR = 'FIELD_STR'.
          WRITE_FB 'E' 'Feldstruktur fehlerhaft!'(147).
        ENDIF.
        IF ERRORS-ERROR = 'SHOULD_BE_INCLUDE'.
          WRITE_FB 'E' 'Objekt ist keine Struktur!'(148).
        ENDIF.
        IF ERRORS-ERROR = 'SHOULD_BE_APPEND'.
          WRITE_FB 'E' 'Objekt ist keine Append-Struktur!'(149).
        ENDIF.
        IF ERRORS-ERROR = 'NOT_INCLUDED'.
          IF INC_TYPE = 'INCLUDE'.
            WRITE_FB_TWO_VAR 'E' 'Die Struktur'(305) PART_INC
                             'ist nicht inkludiert in'(306) PART_TAB.
          ELSE.
            WRITE_FB_TWO_VAR 'E' 'Die Struktur'(305) PART_INC
                             'ist nicht appendiert an'(307) PART_TAB.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.

************************************************************************
* FORM WRITE_FEEDBACK                                                  *
* Diese Form erfüllt folgende Aufgaben:                                *
*   1) Ausgabe der Meldungen aus FB_TAB                                *
*   2) Sichern der Meldungen aus FB_TAB in der DB-Tabelle BC430_PROT   *
*   3) Löschen der Meldungen aus FB_TAB                                *
************************************************************************

FORM WRITE_FEEDBACK USING GLOBAL_SUCCESS.

  DATA: PROT_WA TYPE BC430_PROT,
        PROT_TAB TYPE STANDARD TABLE OF BC430_PROT.

* Abbauen eines vorhandenen Controls für Feedback
   IF FB_CONT_CRE = 'Y'.
     CALL METHOD PICTURE2->DESTROY_CONTROL.
   ENDIF.

   LEAVE TO LIST-PROCESSING.

*  1) Ausgabe der Meldungen aus FB_TAB
   FORMAT INTENSIFIED ON.
   LOOP AT FB_TAB.
     IF FB_TAB-COLOR = 'E'.
       WRITE: ICON_BREAKPOINT AS ICON.
       WRITE: FB_TAB-TEXT. NEW-LINE.
     ELSEIF FB_TAB-COLOR = 'I'.
       WRITE: FB_TAB-TEXT COLOR COL_KEY. NEW-LINE.
     ELSEIF FB_TAB-COLOR = 'S'.
       WRITE: ICON_OKAY AS ICON.
       WRITE: FB_TAB-TEXT. NEW-LINE.
     ELSEIF FB_TAB-COLOR = 'W'.
       WRITE: ICON_ALARM AS ICON.
       WRITE: FB_TAB-TEXT. NEW-LINE.
     ELSEIF FB_TAB-COLOR = 'U'.
       WRITE: FB_TAB-TEXT COLOR COL_HEADING. NEW-LINE.
     ELSEIF FB_TAB-COLOR = 'N'.
       SKIP.
     ELSE.
       WRITE: FB_TAB-TEXT COLOR COL_NORMAL. NEW-LINE.
     ENDIF.
   ENDLOOP.

* 2) Sichern der Meldungen aus FB_TAB in BC430_PROT
  PROT_WA-COURSE_USER = SY-UNAME.
  PROT_WA-PROT_DATE = SY-DATUM.
  PROT_WA-PROT_TIME = SY-UZEIT.
  PROT_WA-LINE = 0.

* Ermittle Kapitelnr.
  IF KAP2 = 'X'. PROT_WA-CHAPTER = 2. ENDIF.
  IF KAP3 = 'X'. PROT_WA-CHAPTER = 3. ENDIF.
  IF KAP4 = 'X'. PROT_WA-CHAPTER = 4. ENDIF.
  IF KAP5 = 'X'. PROT_WA-CHAPTER = 5. ENDIF.
  IF KAP6 = 'X'. PROT_WA-CHAPTER = 6. ENDIF.

  LOOP AT FB_TAB.
    ADD 1 TO PROT_WA-LINE.
    PROT_WA-COLOR = FB_TAB-COLOR.
    PROT_WA-TEXT =  FB_TAB-TEXT.
    APPEND PROT_WA TO PROT_TAB.
  ENDLOOP.

  INSERT BC430_PROT FROM TABLE PROT_TAB.

* 3) Löschen der Meldungen aus FB_TAB
  REFRESH FB_TAB.

* 4) Ausgeben des Bildes zum Feedback
* Aufbau des Image Control
  CREATE OBJECT PICTURE2.
  CALL METHOD PICTURE2->CREATE_CONTROL
         EXPORTING DYNNR = '1100'
                   REPID = 'BC430_CHECK'
                   STYLE = WS_BORDER
                   CONTAINER = 'PICTURE2'.
* Setze Anzeige Modus
  CALL METHOD PICTURE2->SET_DISPLAY_MODE
       EXPORTING DISPLAY_MODE = DISPLAY_MODE_STRETCH.
* Lade Bild aus R/3 Databank
  DATA PIC_DATA_FB LIKE W3MIME OCCURS 0.
  DATA PIC_SIZE_FB TYPE I.
* Bestimme den Namen des Bildes für das Feedback abhängig von Erfolg
* und geprüftem Kapitel
  IF GLOBAL_SUCCESS = 'Y'.
    IF KAP2 = 'X'.
      LOAD_GIF_PICTURE 'BC430_SUCCESS1'.
    ENDIF.
    IF KAP3 = 'X'.
      LOAD_GIF_PICTURE 'BC430_SUCCESS2'.
    ENDIF.
    IF KAP4 = 'X'.
      LOAD_GIF_PICTURE 'BC430_SUCCESS3'.
    ENDIF.
    IF KAP5 = 'X'.
      LOAD_GIF_PICTURE 'BC430_SUCCESS4'.
    ENDIF.
    IF KAP6 = 'X'.
      LOAD_GIF_PICTURE 'BC430_SUCCESS5'.
    ENDIF.
  ELSEIF GLOBAL_SUCCESS = 'N'.
    IF KAP2 = 'X'.
      LOAD_GIF_PICTURE 'BC430_FAILURE1'.
    ENDIF.
    IF KAP3 = 'X'.
      LOAD_GIF_PICTURE 'BC430_FAILURE2'.
    ENDIF.
    IF KAP4 = 'X'.
      LOAD_GIF_PICTURE 'BC430_FAILURE3'.
    ENDIF.
    IF KAP5 = 'X'.
      LOAD_GIF_PICTURE 'BC430_FAILURE4'.
    ENDIF.
    IF KAP6 = 'X'.
      LOAD_GIF_PICTURE 'BC430_FAILURE5'.
    ENDIF.
  ENDIF.

* Ermittle eine URL vom Data Provider durch Export der pic_data.
  CLEAR URL.
  CALL FUNCTION 'DP_CREATE_URL'
       EXPORTING
            TYPE     = 'image'
            SUBTYPE  = CNDP_SAP_TAB_UNKNOWN
            SIZE     = PIC_SIZE_FB
            LIFETIME = CNDP_LIFETIME_TRANSACTION
       TABLES
            DATA     = PIC_DATA_FB
       CHANGING
            URL      = URL2
       EXCEPTIONS
            OTHERS   = 1.
* Lade das Bild über die URL vom Data Provider.
  IF SY-SUBRC = 0.
    CALL METHOD PICTURE2->LOAD_IMAGE_FROM_URL
       EXPORTING URL = URL2.
  ENDIF.

* Setze Flag, daß Control schon aufgebaut ist
  FB_CONT_CRE = 'Y'.

ENDFORM.

************************************************************************
* FORM FILL_FIELD_TEXTS                                                *
* Ermittelt für jeden Feldnamen aus einer der Vorlagentabellen einen   *
* beschreibenden Text.                                                 *
************************************************************************

FORM FILL_FIELD_TEXTS.

FILL_TEXT 'CLIENT' 'Mandant'(401).
FILL_TEXT 'CARRIER' 'Fluggesellschaft'(402).
FILL_TEXT 'EMP_NUM' 'Personalnummer'(403).
FILL_TEXT 'FIRST_NAME' 'Vorname'(404).
FILL_TEXT 'LAST_NAME' 'Nachname'(405).
FILL_TEXT 'DEPARTMENT' 'Abteilungskürzel'(406).
FILL_TEXT 'AREA' 'Bereich'(407).
FILL_TEXT 'SALARY' 'Gehalt'(408).
FILL_TEXT 'CURRENCY' 'Währung'(409).
FILL_TEXT 'CHANGED_BY' 'Letzter Änderer'(416).
FILL_TEXT 'CH_DATE' 'Änderungsdatum'(417).
FILL_TEXT 'TELNR' 'Telefonnummer'(410).
FILL_TEXT 'FAXNR' 'Faxnummer'(411).
FILL_TEXT 'CH_TIME' 'Änderungszeit'(418).
FILL_TEXT 'CHIEF' 'Abteilungsleiter'(415).
FILL_TEXT 'LANGU' 'Sprache'(413).
FILL_TEXT 'TEXT' 'Text'(414).
FILL_TEXT 'CONNID' 'Verbindungsnummer'(419).
FILL_TEXT 'FLDATE' 'Flugdatum'(420).
FILL_TEXT 'ROLE' 'Rolle'(421).
FILL_TEXT 'FLUGHAFEN' 'Flughafenname'(422).
FILL_TEXT 'BUERONUMMER' 'Büronummer'(423).
FILL_TEXT 'TELEFONNUMMER' 'Telefonnummer'(410).
FILL_TEXT 'AGENCY' 'Reisebüro'(412).

ENDFORM.

************************************************************************
* FORM    LOAD_PIC_FROM_DB                                             *
************************************************************************

FORM LOAD_PIC_FROM_DB
     TABLES PIC_DATA
     USING PIC_NAME
     CHANGING PIC_SIZE.
  DATA QUERY_TABLE LIKE W3QUERY OCCURS 1 WITH HEADER LINE.
  DATA HTML_TABLE LIKE W3HTML OCCURS 1.
  DATA RETURN_CODE LIKE  W3PARAM-RET_CODE.
  DATA CONTENT_TYPE LIKE  W3PARAM-CONT_TYPE.
  DATA CONTENT_LENGTH LIKE  W3PARAM-CONT_LEN.

  CLEAR QUERY_TABLE.
  QUERY_TABLE-NAME = '_OBJECT_ID'.
  QUERY_TABLE-VALUE = PIC_NAME.
  APPEND QUERY_TABLE.

  CALL FUNCTION 'WWW_GET_MIME_OBJECT'
       TABLES
            QUERY_STRING        = QUERY_TABLE
            HTML                = HTML_TABLE
            MIME                = PIC_DATA
       CHANGING
            RETURN_CODE         = RETURN_CODE
            CONTENT_TYPE        = CONTENT_TYPE
            CONTENT_LENGTH      = CONTENT_LENGTH
       EXCEPTIONS
            INVALID_TABLE       = 1
            PARAMETER_NOT_FOUND = 2
            OTHERS              = 3.
  IF SY-SUBRC = 0.
    PIC_SIZE = CONTENT_LENGTH.
  ENDIF.
ENDFORM.
