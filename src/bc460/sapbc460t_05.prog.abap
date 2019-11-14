REPORT SAPBC460T_5.
*&---------------------------------------------------------------------*
*& Report  sapbc460t_5.                                                *
*&---------------------------------------------------------------------*
*& Example print program for training course BC460, chapter 5          *
*&---------------------------------------------------------------------*
TABLES: SCUSTOM, SBOOK, SPFLI.

SELECT-OPTIONS: S_ID  FOR SCUSTOM-ID DEFAULT 200 TO 200,
                S_FLI FOR SBOOK-CARRID DEFAULT 'LH' TO 'LH'.
PARAMETERS: FORM      LIKE THEAD-TDFORM DEFAULT 'SAPBC460D_FM_05'.

DATA CUSTOMERS LIKE SCUSTOM OCCURS 100
     WITH HEADER LINE.
DATA BOOKINGS  LIKE SBOOK   OCCURS 1000
     WITH HEADER LINE.
DATA CONNECTIONS LIKE SPFLI OCCURS 1000
     WITH HEADER LINE.
DATA: BEGIN OF SUMS OCCURS 10,
        FORCURAM  LIKE SBOOK-FORCURAM,
        FORCURKEY LIKE SBOOK-FORCURKEY,
      END OF SUMS.
DATA BEGIN OF OPTIONS.
  INCLUDE STRUCTURE ITCPO.
DATA END   OF OPTIONS.
DATA BEGIN OF RESULT.
  INCLUDE STRUCTURE ITCPP.
DATA END   OF RESULT.

* Get data
SELECT * FROM  SCUSTOM INTO TABLE CUSTOMERS
       WHERE ID IN S_ID
       ORDER BY PRIMARY KEY.
SELECT * FROM  SBOOK   INTO TABLE BOOKINGS
       WHERE CUSTOMID IN S_ID AND CARRID IN S_FLI
         AND FORCURKEY NE SPACE
       ORDER BY PRIMARY KEY.
SELECT * FROM  SPFLI   INTO TABLE CONNECTIONS
       FOR ALL ENTRIES IN BOOKINGS
       WHERE CARRID = BOOKINGS-CARRID
       AND   CONNID = BOOKINGS-CONNID
       ORDER BY PRIMARY KEY.

* Open print job
OPTIONS-TDDEST = '*'.
OPTIONS-TDIMMED = '*'.
OPTIONS-TDDELETE = '*'.
OPTIONS-TDNEWID = 'X'.
*CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*  Note, since using the start function below,
*  the form is not needed in the open.
*
*  Please notice that the internal table OPTIONS
*  should be used in the OPEN_FORM function.
***********************************
IF SY-SUBRC NE 0.
  WRITE 'Fehler in Funktion X'(001).
  EXIT.
ENDIF.

* Print form for all customers
LOOP AT CUSTOMERS.
* Set customer address
  SCUSTOM = CUSTOMERS.
* Open (start) form of respective customer
* CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X'(001).
    EXIT.
  ENDIF.

* Output introduction text
* CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X, Element INTRODUCTION'(002).
    EXIT.
  ENDIF.
* Output column headings of main window
*CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X, Element ITEM_HEADER'(003).
    EXIT.
  ENDIF.
* Set column headings into TOP area of main window for subsequent pages
*CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X, TOP Element ITEM_HEADER'(004).
    EXIT.
  ENDIF.
* Customer bookings
  CLEAR SUMS. REFRESH SUMS.
  LOOP AT BOOKINGS
       WHERE CUSTOMID = CUSTOMERS-ID.
    SBOOK = BOOKINGS.
*   Get departure time
    READ TABLE CONNECTIONS WITH KEY CARRID = BOOKINGS-CARRID
                                    CONNID = BOOKINGS-CONNID.
    IF SY-SUBRC = 0.
      SPFLI = CONNECTIONS.
    ELSE.
      CLEAR SPFLI.
    ENDIF.
*   Print item
*  CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
    IF SY-SUBRC NE 0.
      WRITE 'Fehler in Funktion X, Element ITEM_LINE'(005).
      EXIT.
    ENDIF.
*   Add current position to corresponding entry in table sums
    MOVE-CORRESPONDING SBOOK TO SUMS.
    COLLECT SUMS.
  ENDLOOP.          " at bookings

* Delete column headings from TOP area of main window
* CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X, Löschen Element ITEM_HEADER'(006).
    EXIT.
  ENDIF.

* Print final remark
* CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X, Element CLOSING_REMARK'(007).
    EXIT.
  ENDIF.
* Print sum
  LOOP AT SUMS.
    MOVE-CORRESPONDING SUMS TO SBOOK.
*   CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
    IF SY-SUBRC NE 0.
      WRITE 'Fehler in Funktion X, Element SUM'(008).
      EXIT.
    ENDIF.
  ENDLOOP.         " at sums

* Close customer form
* CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
  IF SY-SUBRC NE 0.
    WRITE 'Fehler in Funktion X'(001).
    EXIT.
  ENDIF.
ENDLOOP.          " at customers

* close print job
*CALL FUNCTION ...
***********************************
*
*  fill in missing statements
*
***********************************
IF SY-SUBRC NE 0.
  WRITE 'Fehler in Funktion X'(001).
  EXIT.
ENDIF.
