*&---------------------------------------------------------------------*
*& Report für BC460 DRUCKVORLAGE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  SAPBC460T_PRINT_TEMPLATE.
TABLES: sbook, scustom.

DATA:
      gt_sbook   TYPE TABLE OF sbook,
      gt_scustom TYPE TABLE OF scustom.

* Selektionsbild
* Selection screen
SELECT-OPTIONS:
so_cust  FOR scustom-ID DEFAULT 1 TO 3 OBLIGATORY,
so_car   FOR sbook-carrid DEFAULT 'AA' TO 'LH'.

PARAMETERS:
pa_form TYPE thead-tdform DEFAULT 'SAPBC460_DRUCK' OBLIGATORY.

START-OF-SELECTION.
* Datenbeschaffung: Kundeninformationen
* data retrieval: customer information
SELECT *
FROM scustom
INTO TABLE gt_scustom
WHERE ID IN so_cust.

IF sy-dbcnt = 0. EXIT. ENDIF.

* Beginn des Formulardrucks
* Start of form printing
**************************************************************



* Auswerten der Tabelle der selektierten Kunden
* Evaluate table of selected customers
LOOP AT gt_scustom
INTO scustom.

* Datenbeschaffung: Buchungsinformationen für den aktuellen Kunden
* Data retrieval: booking information for current customer
  SELECT *
  FROM sbook
  INTO TABLE gt_sbook
  WHERE carrid   IN so_car AND
  customid = scustom-ID.


* Für jeden Kunden muss das Formular erneut prozessiert werden.
* Every customer gets their own form
*****************************************************************

* Ausgabe aller Textelemente
* Print text elements
*****************************************************************


* Aufbau der Liste der Buchungspositionen
* Table with bookings
  LOOP AT gt_sbook
  INTO sbook.
* Druck des passenden Textelementes für jede Position
* Print text element for every item
*****************************************************************

  ENDLOOP.


* Formular des aktuellen Kunden schließen
* Close form of current customer
*****************************************************************

ENDLOOP.


* Ende des Formulardrucks
* End of form printing
*****************************************************************
