*&---------------------------------------------------------------------*
*& Report  SAPBC460S_05A                                               *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Example print program for training course BC460, chapter 5          *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  SAPBC460S_05A                 .

PARAMETERS: STPAGE(10) DEFAULT 'FIRST'.

*----------------------------------------------------------------------*

* Formulardruck öffnen
CALL FUNCTION 'OPEN_FORM'
     EXPORTING
          FORM                        = 'SAPBC460D_FM_03'
     EXCEPTIONS
          OTHERS                      = 1.
IF SY-SUBRC <> 0.
    WRITE: 'Fehler in OPEN_FORM'(001).
ENDIF.

* Wahl der Startseite
CALL FUNCTION 'START_FORM'
     EXPORTING
          STARTPAGE        = STPAGE
     EXCEPTIONS
          OTHERS           = 1.
IF SY-SUBRC <> 0.
    WRITE: / 'Fehler in START_FORM'(002).
ENDIF.

* Textelement INTRODUCTION ausgeben
CALL FUNCTION 'WRITE_FORM'
     EXPORTING
          ELEMENT                  = 'INTRODUCTION '
     EXCEPTIONS
          OTHERS                   = 1.
IF SY-SUBRC <> 0.
    WRITE: / 'Fehler in WRITE_FORM, element INTRODUCTION'(003).
ENDIF.

* Textelement ITEMS ausgeben
CALL FUNCTION 'WRITE_FORM'
     EXPORTING
         ELEMENT                  = 'ITEMS'
     EXCEPTIONS
          OTHERS                   = 1.
IF SY-SUBRC <> 0.
    WRITE: / 'Fehler in WRITE_FORM, element ITEMS'(004).
ENDIF.

* Textelement CLOSING_REMARK ausgeben
CALL FUNCTION 'WRITE_FORM'
     EXPORTING
          ELEMENT                  = 'CLOSING_REMARK'
     EXCEPTIONS
          OTHERS                   = 1.
IF SY-SUBRC <> 0.
    WRITE: / 'Fehler in WRITE_FORM, element CLOSING_REMARK'(005).
ENDIF.

* Formularausgabe beenden
CALL FUNCTION 'END_FORM'
     EXCEPTIONS
          UNOPENED                 = 1
          BAD_PAGEFORMAT_FOR_PRINT = 2
          OTHERS                   = 3.
IF SY-SUBRC <> 0.
    WRITE: / 'Fehler in END_FORM'(006).
ENDIF.

* Formulardruck schließen
CALL FUNCTION 'CLOSE_FORM'
     EXCEPTIONS
          UNOPENED                 = 1
          BAD_PAGEFORMAT_FOR_PRINT = 2
          OTHERS                   = 3.
IF SY-SUBRC <> 0.
    WRITE: / 'Fehler in CLOSE_FORM'(007).
ENDIF.
