*&---------------------------------------------------------------------*
*& Report  SAPBC460S_05B                                               *
*&---------------------------------------------------------------------*
*& Example print program for training course BC460, chapter 5          *
*&---------------------------------------------------------------------*
REPORT SAPBC460S_05B.

TABLES: SCUSTOM, SBOOK, SPFLI.

SELECT-OPTIONS: S_ID FOR SCUSTOM-ID DEFAULT 200 TO 200,
                S_FLI FOR SBOOK-CARRID DEFAULT 'LH' TO 'LH'.
PARAMETERS: FORM LIKE THEAD-TDFORM DEFAULT 'SAPBC460D_FM_05'.

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
CALL FUNCTION 'OPEN_FORM'
     EXPORTING
          DEVICE             = 'PRINTER'
          DIALOG             = 'X'
          OPTIONS            = OPTIONS
     EXCEPTIONS
          CANCELED           = 1
          DEVICE             = 2
          FORM               = 3
          OPTIONS            = 4
          UNCLOSED           = 5
          OTHERS             = 6.
IF SY-SUBRC <> 0.
  WRITE 'Error in OPEN_FORM'(001).
  EXIT.
ENDIF.

* Print form for all customers
LOOP AT CUSTOMERS.
* Set customer address
  SCUSTOM = CUSTOMERS.
* Open form of respective customer
  CALL FUNCTION 'START_FORM'
    EXPORTING
          FORM          = FORM
    EXCEPTIONS
          OTHERS        = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in START_FORM'(002).
    EXIT.
  ENDIF.

* Output introduction text
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
            ELEMENT       = 'INTRODUCTION'
    EXCEPTIONS
            OTHERS        = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in WRITE_FORM, element INTRODUCTION'(003).
    EXIT.
  ENDIF.
* Output column headings of main window
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
            ELEMENT       = 'ITEM_HEADER'
    EXCEPTIONS
            OTHERS        = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in WRITE_FORM, element ITEM_HEADER'(004).
    EXIT.
  ENDIF.
* Set column headings into TOP area of main window for subsequent pages
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
            ELEMENT       = 'ITEM_HEADER'
            FUNCTION      = 'SET'
            TYPE          = 'TOP'
    EXCEPTIONS
            OTHERS        = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in WRITE_FORM, top element ITREM_HEADER'(005).
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
    CALL FUNCTION 'WRITE_FORM'
         EXPORTING
              ELEMENT       = 'ITEM_LINE'
         EXCEPTIONS
              OTHERS        = 1.
    IF SY-SUBRC <> 0.
      WRITE 'Error in WRITE_FORM, element ITEM_LINE'(006).
      EXIT.
    ENDIF.
*   Add current position to corresponding entry in table sums
    MOVE-CORRESPONDING SBOOK TO SUMS.
    COLLECT SUMS.
  ENDLOOP.          " at bookings

* Delete column headings from TOP area of main window
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
            ELEMENT       = 'ITEM_HEADER'
            FUNCTION      = 'DELETE'
            TYPE          = 'TOP'
    EXCEPTIONS
            OTHERS        = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in WRITE_FORM, delete element ITEM_HEADER'(007).
    EXIT.
  ENDIF.

* Print final remark
  CALL FUNCTION 'WRITE_FORM'
       EXPORTING
            ELEMENT       = 'CLOSING_REMARK'
       EXCEPTIONS
            OTHERS        = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in WRITE_FORM, element CLOSING_REMARK'(008).
    EXIT.
  ENDIF.
* Print sum
  LOOP AT SUMS.
    MOVE-CORRESPONDING SUMS TO SBOOK.
    CALL FUNCTION 'WRITE_FORM'
         EXPORTING
              ELEMENT       = 'SUM'
         EXCEPTIONS
              OTHERS        = 1.
    IF SY-SUBRC <> 0.
      WRITE 'Error in WRITE_FORM, element SUM'(009).
      EXIT.
    ENDIF.
  ENDLOOP.         " at sums

* Close customer form
  CALL FUNCTION 'END_FORM'
       EXCEPTIONS
            OTHERS   = 1.
  IF SY-SUBRC <> 0.
    WRITE 'Error in END_FORM'(010).
    EXIT.
  ENDIF.
ENDLOOP.          " at customers

* close print job
CALL FUNCTION 'CLOSE_FORM'
     IMPORTING
          RESULT             = RESULT
     EXCEPTIONS
          OTHERS   = 1.
IF SY-SUBRC <> 0.
  WRITE 'Error in CLOSE_FORM'(011).
  EXIT.
ENDIF.
