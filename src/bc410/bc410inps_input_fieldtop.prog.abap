*----------------------------------------------------------------------*
*   INCLUDE BC410INPS_INPUT_FIELDTOP                                   *
*----------------------------------------------------------------------*
PROGRAM SAPBC410INPS_INPUT_FIELD.

* workarea and internal table for flights
DATA: MARK,
      WA_SFLIGHT type SFLIGHT,
      IT_SFLIGHT LIKE TABLE OF wa_SFLIGHT.

* workarea and internal tables for bookings
DATA: WA_SBOOK type SBOOK,
      IT_SBOOK_READ LIKE TABLE OF WA_SBOOK,
      IT_SBOOK LIKE TABLE OF WA_SBOOK.

* sflight key for testing changes
DATA: BEGIN OF KEY_SFLIGHT,
        CARRID LIKE wa_SFLIGHT-CARRID,
        CONNID LIKE wa_SFLIGHT-CONNID,
        FLDATE LIKE wa_SFLIGHT-FLDATE,
      END OF KEY_SFLIGHT.
* field name for GET CURSOR
DATA  FIELDNAME(50).

* fields for ok_code processing
DATA: OK_CODE LIKE SY-UCOMM,
      SAVE_OK LIKE OK_CODE.

* structures for dynpro processing
TABLES  SDYN_CONN00.

* selection screen for choosing connections
SELECTION-SCREEN BEGIN OF BLOCK CONN WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: SO_CAR FOR WA_SFLIGHT-CARRID,
                SO_CON FOR WA_SFLIGHT-CONNID.
SELECTION-SCREEN END OF BLOCK CONN.
