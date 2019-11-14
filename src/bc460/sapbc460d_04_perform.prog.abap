*&---------------------------------------------------------------------*
*& Report  SAPBC460D_04_PERFORM                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Demoprogramm für einen Performaufruf aus einem Formular             *
*& Das Formular ruft das Programm QCJPERFO                             *
*&---------------------------------------------------------------------*

REPORT  SAPBC460D_04_PERFORM          .


*  Open Printjob
CALL FUNCTION 'OPEN_FORM'
     EXPORTING
*         DEVICE                      = 'PRINTER'
*         DIALOG                      = 'X'
          FORM                        = 'SAPBC460D_FM_04C'
*         LANGUAGE                    = SY-LANGU
     EXCEPTIONS
          CANCELED                    = 1
          DEVICE                      = 2
          FORM                        = 3
          OPTIONS                     = 4
          UNCLOSED                    = 5
          MAIL_OPTIONS                = 6
          OTHERS                      = 10.
IF SY-SUBRC <> 0.
   WRITE: 'Fehler in OPEN_FORM'(001).
ENDIF.

*  Output Text
CALL FUNCTION 'WRITE_FORM'
     EXPORTING
          ELEMENT                  = 'TEXT'
     EXCEPTIONS
          ELEMENT                  = 1
          FUNCTION                 = 2
          TYPE                     = 3
          UNOPENED                 = 4
          UNSTARTED                = 5
          WINDOW                   = 6
          BAD_PAGEFORMAT_FOR_PRINT = 7
          OTHERS                   = 8.
IF SY-SUBRC <> 0.
   WRITE: / 'Fehler in WRITE_FORM'(002).
ENDIF.

*  Close Printjob
CALL FUNCTION 'CLOSE_FORM'
     EXCEPTIONS
          UNOPENED                 = 1
          BAD_PAGEFORMAT_FOR_PRINT = 2
          OTHERS                   = 3.
IF SY-SUBRC <> 0.
   WRITE: / 'Fehler in CLOSE_FORM'(003).
ENDIF.
