REPORT SAPBC460D_04_ADDRESS .
TABLES: SCUSTOM.
SELECT-OPTIONS S_CUSTID FOR SCUSTOM-ID.

INITIALIZATION.
  S_CUSTID = 'IBT0000002100000030'.
  APPEND S_CUSTID.
START-OF-SELECTION.

  CALL FUNCTION 'OPEN_FORM'
       EXPORTING
*           device             = 'PRINTER'
          DIALOG             = 'X'
          LANGUAGE           = SY-LANGU
     EXCEPTIONS
          CANCELED           = 1
          DEVICE             = 2
          FORM               = 3
          OPTIONS            = 4
          UNCLOSED           = 5
          OTHERS             = 6.
IF SY-SUBRC NE 0.
   WRITE: / 'Fehler in OPEN_FORM'(001).
ENDIF.

SELECT * FROM SCUSTOM WHERE ID IN S_CUSTID.


CALL FUNCTION 'START_FORM'
     EXPORTING
         FORM          = 'SAPBC460D_FM_04A'
         LANGUAGE      = SY-LANGU
    EXCEPTIONS
         FORM          = 1
         FORMAT        = 2
         UNENDED       = 3
         UNOPENED      = 4
         UNUSED        = 5
         OTHERS        = 6.
IF SY-SUBRC NE 0.
    WRITE: / 'Fehler in START_FORM'(002).
ENDIF.

CALL FUNCTION 'WRITE_FORM'
     EXPORTING
          ELEMENT       = 'ITEM_LINE'
     EXCEPTIONS
          ELEMENT       = 1
          FUNCTION      = 2
          TYPE          = 3
          UNOPENED      = 4
          UNSTARTED     = 5
          WINDOW        = 6
          OTHERS        = 7.
IF SY-SUBRC NE 0.
   WRITE: / 'Fehler in WRITE_FORM'(003).
ENDIF.



CALL FUNCTION 'END_FORM'
     EXCEPTIONS
          UNOPENED = 1
          OTHERS   = 2.
IF SY-SUBRC NE 0.
   WRITE: / 'Fehler in END_FORM'(004).
ENDIF.
ENDSELECT.


CALL FUNCTION 'CLOSE_FORM'
     EXCEPTIONS
          UNOPENED = 1
          OTHERS   = 2.
IF SY-SUBRC NE 0.
   WRITE: / 'Fehler in CLOSE_FORM'(005).
ENDIF.
