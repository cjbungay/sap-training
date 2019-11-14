*----------------------------------------------------------------------*
***INCLUDE BC410INPS_HELP_FOR_INPUTF01
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  READ_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READ_FLIGHTS.
  SELECT * INTO TABLE IT_SFLIGHT FROM SFLIGHT
   WHERE CARRID IN SO_CAR
     AND CONNID IN SO_CON.
  SORT IT_SFLIGHT BY CARRID CONNID FLDATE.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_FLIGHTS.
  LOOP AT IT_SFLIGHT INTO WA_SFLIGHT.

    WRITE: / MARK AS CHECKBOX,
             WA_SFLIGHT-CARRID,
             WA_SFLIGHT-CONNID,
             WA_SFLIGHT-FLDATE,
             WA_SFLIGHT-PRICE CURRENCY WA_SFLIGHT-CURRENCY,
             WA_SFLIGHT-CURRENCY,
             WA_SFLIGHT-SEATSMAX,
             WA_SFLIGHT-SEATSOCC.
    HIDE: WA_SFLIGHT.
  ENDLOOP.
ENDFORM.                    " DISPLAY_FLIGHTS
*&---------------------------------------------------------------------*
*&      Form  READ_BOOKINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA_SFLIGHT_CARRID  text
*      -->P_WA_SFLIGHT_CONNID  text
*      -->P_WA_SFLIGHT_FLDATE  text
*      -->P_0032   text
*----------------------------------------------------------------------*
FORM READ_BOOKINGS USING    P_CARRID LIKE WA_SBOOK-CARRID
                            P_CONNID LIKE WA_SBOOK-CONNID
                            P_FLDATE LIKE WA_SBOOK-FLDATE
                            P_CANCELLED LIKE WA_SBOOK-CANCELLED.

SELECT * INTO TABLE IT_SBOOK_READ FROM SBOOK
  WHERE CARRID = P_CARRID
    AND CONNID = P_CONNID
    AND FLDATE = P_FLDATE
    AND CANCELLED = P_CANCELLED.

ENDFORM.                    " READ_BOOKINGS
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_BOOKINGS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_BOOKINGS.

  LOOP AT IT_SBOOK INTO WA_SBOOK.

    IF KEY_SFLIGHT-CARRID NE WA_SBOOK-CARRID
        OR  KEY_SFLIGHT-CONNID NE WA_SBOOK-CONNID
        OR  KEY_SFLIGHT-FLDATE NE WA_SBOOK-FLDATE.
      MOVE-CORRESPONDING WA_SBOOK TO KEY_SFLIGHT.
      NEW-PAGE.
    ENDIF.

    WRITE: / WA_SBOOK-BOOKID,
             WA_SBOOK-CUSTOMID,
             WA_SBOOK-CUSTTYPE,
             WA_SBOOK-LUGGWEIGHT UNIT WA_SBOOK-WUNIT,
             WA_SBOOK-WUNIT,
             WA_SBOOK-CLASS,
             WA_SBOOK-ORDER_DATE,
             WA_SBOOK-CANCELLED.
    HIDE WA_SBOOK-BOOKID.
  ENDLOOP.

ENDFORM.                    " DISPLAY_BOOKINGS
