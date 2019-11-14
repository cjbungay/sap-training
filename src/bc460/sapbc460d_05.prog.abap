*&---------------------------------------------------------------------*
*& Report  RSTXEXP1                                                    *
*&---------------------------------------------------------------------*
*& Beispielprogramm für Formulardruck                                  *
*&---------------------------------------------------------------------*
REPORT  RSTXEXP1.

TABLES: SCUSTOM, SBOOK, SPFLI.

SELECT-OPTIONS: S_ID FOR SCUSTOM-ID DEFAULT 200 TO 200,
                S_FLI FOR SBOOK-CARRID DEFAULT 'LH' TO 'LH'.

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

* Get data
SELECT * FROM  SCUSTOM INTO TABLE CUSTOMERS
       WHERE ID IN S_ID
       ORDER BY PRIMARY KEY.
SELECT * FROM  SBOOK   INTO TABLE BOOKINGS
       WHERE CUSTOMID IN S_ID AND CARRID IN S_FLI
       ORDER BY PRIMARY KEY.
SELECT * FROM  SPFLI   INTO TABLE CONNECTIONS
       FOR ALL ENTRIES IN BOOKINGS
       WHERE CARRID = BOOKINGS-CARRID
       AND   CONNID = BOOKINGS-CONNID
       ORDER BY PRIMARY KEY.

* Open print job
CALL FUNCTION 'OPEN_FORM'
     EXPORTING
          DEVICE   = 'PRINTER'
          FORM     = 'S_EXAMPLE_1'
          DIALOG   = 'X'
     EXCEPTIONS
          CANCELED = 1
          DEVICE   = 2
          FORM     = 3
          OPTIONS  = 4
          UNCLOSED = 5
          OTHERS   = 6.
IF SY-SUBRC NE 0.
  WRITE 'Error in open_form'(001).
  EXIT.
ENDIF.

* Print form for all customers
LOOP AT CUSTOMERS.
* Set customer address
  SCUSTOM = CUSTOMERS.
* Open form of respective customer
  CALL FUNCTION 'START_FORM'
       EXCEPTIONS
            OTHERS = 1.
  IF SY-SUBRC NE 0.
    WRITE 'Error in start_form'(002).
    EXIT.
  ENDIF.

* Display column headings of main window
  CALL FUNCTION 'WRITE_FORM'
       EXPORTING
            ELEMENT  = 'HEADING'
            FUNCTION = 'SET'
            TYPE     = 'TOP'
            WINDOW   = 'MAIN'
       EXCEPTIONS
            OTHERS   = 1.
  IF SY-SUBRC NE 0.
    WRITE 'Error in write_form printing top element of main'(003).
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
*   Print position
    CALL FUNCTION 'WRITE_FORM'
         EXPORTING
              ELEMENT  = 'BOOKING'
              FUNCTION = 'SET'
              TYPE     = 'BODY'
              WINDOW   = 'MAIN'
         EXCEPTIONS
              OTHERS   = 1.
    IF SY-SUBRC NE 0.
      WRITE 'Error in write_form printing body of main'(004).
      EXIT.
    ENDIF.
*   Add current position to corresponding entry in table sums
    MOVE-CORRESPONDING SBOOK TO SUMS.
    COLLECT SUMS.
  ENDLOOP.                             " at bookings

* Print sum
  LOOP AT SUMS.
    MOVE-CORRESPONDING SUMS TO SBOOK.
    IF NOT SUMS IS INITIAL.
      CALL FUNCTION 'WRITE_FORM'
           EXPORTING
                ELEMENT  = 'SUM'
                FUNCTION = 'SET'
                TYPE     = 'BODY'
                WINDOW   = 'MAIN'
           EXCEPTIONS
                OTHERS   = 1.
      IF SY-SUBRC NE 0.
        WRITE 'Error in write_form printing sum of invoice'(005).
        EXIT.
      ENDIF.
    ENDIF.
  ENDLOOP.                             " at sums

* Close customer form
  CALL FUNCTION 'END_FORM'
       EXCEPTIONS
            OTHERS = 1.
  IF SY-SUBRC NE 0.
    WRITE 'Error in end_form'(006).
    EXIT.
  ENDIF.
ENDLOOP.                               " at customers

* close print job
CALL FUNCTION 'CLOSE_FORM'
     EXCEPTIONS
          OTHERS = 1.
IF SY-SUBRC NE 0.
  WRITE 'Error in close_form'(007).
  EXIT.
ENDIF.
