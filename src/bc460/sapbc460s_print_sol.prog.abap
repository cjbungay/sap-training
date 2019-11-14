*&---------------------------------------------------------------------*
*& Report für BC460 DRUCKPROGRAMM LOESUNG
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  SAPBC460S_PRINT_SOL.
TABLES: sbook, scustom.

DATA:
      gt_sbook   TYPE TABLE OF sbook,
      gt_scustom TYPE TABLE OF scustom,
      gs_options TYPE itcpo,
      ge_lines   TYPE sy-dbcnt.

* Selektionsbild
* Selection screen
SELECT-OPTIONS:
so_cust  FOR scustom-ID DEFAULT 1 TO 3 OBLIGATORY,
so_car   FOR sbook-carrid DEFAULT 'AA' TO 'LH'.

PARAMETERS:
pa_form TYPE thead-tdform DEFAULT 'SAPBC460_PRINT' OBLIGATORY.

START-OF-SELECTION.
* Datenbeschaffung: Kundeninformationen
* data retrieval: customer information
SELECT *
FROM scustom
INTO TABLE gt_scustom
WHERE ID IN so_cust.

IF sy-dbcnt = 0. EXIT. ENDIF.

* Vorbelegung Druckparameter
* Set print parameters
gs_options-tddest = 'P280'.

* Beginn des Formulardrucks
* Start of form printing
**************************************************************
CALL FUNCTION 'OPEN_FORM'
EXPORTING
  OPTIONS  = gs_options
EXCEPTIONS
  canceled = 1
  OTHERS   = 2.

CASE sy-subrc.
WHEN 0.
WHEN 1.
  MESSAGE 'Form printing was cancelled'(e00)
  TYPE 'I' DISPLAY LIKE 'E'.
  EXIT.
WHEN OTHERS.
  MESSAGE 'OPEN_FORM failed'(e01) TYPE 'E'.
ENDCASE.

* Auswerten der Tabelle der selektierten Kunden
* Evaluate table of selected customers
LOOP AT gt_scustom
INTO scustom.

*   Datenbeschaffung: Buchungsinformationen für den aktuellen Kunden
*   Data retrieval: booking information for current customer
  SELECT *
  FROM sbook
  INTO TABLE gt_sbook
  WHERE carrid   IN so_car AND
  customid = scustom-ID.
  ge_lines = sy-dbcnt.

*   Für jeden Kunden muss das Formular erneut prozessiert werden.
*   Every customer gets their own form
  CALL FUNCTION 'START_FORM'
  EXPORTING
    FORM   = pa_form
  EXCEPTIONS
    OTHERS = 7.
  IF sy-subrc <> 0.
    MESSAGE 'START_FORM failed'(e02) TYPE 'I' DISPLAY LIKE 'E'.
    CONTINUE.
  ENDIF.

*   Ausgabe aller Textelemente
*   Print text elements
  CALL FUNCTION 'WRITE_FORM'
  EXPORTING
    element = 'INTRODUCTION'
  EXCEPTIONS
    OTHERS  = 9.

*   Setzen der Überschrift auf aktueller Seite
*   Set header on current page
  CALL FUNCTION 'WRITE_FORM'
  EXPORTING
    element = 'ITEM_HEADER'
  EXCEPTIONS
    OTHERS  = 9.

*   Setzen der Überschrift für Folgeseiten
*   Set header for subsequent pages
  CALL FUNCTION 'WRITE_FORM'
  EXPORTING
    element = 'ITEM_HEADER'
    TYPE    = 'TOP'
  EXCEPTIONS
    OTHERS  = 9.

*   Aufbau der Liste der Buchungspositionen:
  LOOP AT gt_sbook
  INTO sbook.
*     dynamischer Schutz vor Seitenumbruch
*     dynamic page protection
    IF ge_lines <= 2.
      CALL FUNCTION 'CONTROL_FORM'
      EXPORTING
        command = 'PROTECT'
      EXCEPTIONS
        OTHERS  = 3.
    ENDIF.

*     Aufruf des passenden Textelementes für jede Position
*     Table with bookings
    CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'ITEM_LINE'
    EXCEPTIONS
      OTHERS  = 9.

    ge_lines = ge_lines - 1.
  ENDLOOP.

  CALL FUNCTION 'WRITE_FORM'
  EXPORTING
    element = 'CLOSING_REMARK'
  EXCEPTIONS
    OTHERS  = 9.

  CALL FUNCTION 'CONTROL_FORM'
  EXPORTING
    command = 'ENDPROTECT'
  EXCEPTIONS
    OTHERS  = 3.

*   Löschen der Überschrift für Folgeseiten
*   Delete header for subsequent pages
  CALL FUNCTION 'WRITE_FORM'
  EXPORTING
    element  = 'ITEM_HEADER'
    FUNCTION = 'DELETE'
    TYPE     = 'TOP'
  EXCEPTIONS
    OTHERS   = 9.

*   Formular des aktuellen Kunden schließen
*   Close form of current customer
  CALL FUNCTION 'END_FORM'
  EXCEPTIONS
    OTHERS = 4.
  IF sy-subrc <> 0.
    MESSAGE 'END_FORM failed'(e03) TYPE 'E'.
  ENDIF.
ENDLOOP.

* Ende des Formulardrucks
* End of form printing
CALL FUNCTION 'CLOSE_FORM'
EXCEPTIONS
  OTHERS = 5.

IF sy-subrc <> 0.
  MESSAGE 'CLOSE_FORM failed'(e04) TYPE 'E'.
ENDIF.
