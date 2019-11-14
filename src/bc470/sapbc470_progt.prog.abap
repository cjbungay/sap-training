**************************************************************
* Template for the exercise of chapter 8 of BC470
**************************************************************

REPORT  sapbc470_progt.
DATA:
  gt_bookings  TYPE ty_bookings,                            "#EC NEEDED
  gs_booking   TYPE sbook,                                  "#EC NEEDED
  gt_customers TYPE ty_customers,                           "#EC NEEDED
  gs_customer  TYPE scustom,                                "#EC NEEDED
  ge_color     TYPE tdbtype.


* selection-screen
SELECT-OPTIONS:
  so_cust FOR gs_customer-id    DEFAULT 1    TO 3,
  so_carr FOR gs_booking-carrid DEFAULT 'AA' TO 'LH'.

* printing options
SELECTION-SCREEN SKIP 1.
PARAMETERS:
  pa_prnt  TYPE tsp01-rqdest VALUE CHECK DEFAULT 'P280'
    OBLIGATORY VISIBLE LENGTH 4.

* graphics
SELECTION-SCREEN SKIP 2.
SELECTION-SCREEN COMMENT 1(30) text-se2.
PARAMETERS:
  pa_col     RADIOBUTTON GROUP col,
  pa_mon     RADIOBUTTON GROUP col DEFAULT 'X'.



*******************************************************************
START-OF-SELECTION.

* set color for company logo
  IF pa_col = 'X'.
    ge_color = 'BCOL'.
  ELSE.
    ge_color = 'BMON'.
  ENDIF.


* select data from database for invoices
  SELECT * FROM  scustom                              "#EC CI_SGLSELECT
    INTO TABLE gt_customers
    WHERE id IN so_cust
    ORDER BY PRIMARY KEY.

  SELECT * FROM  sbook
    INTO TABLE gt_bookings
    WHERE customid IN so_cust AND
          carrid   IN so_carr
    ORDER BY PRIMARY KEY.




*********************************************************
*********************************************************
* Your Coding here:
