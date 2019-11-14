*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT20 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT20'
    EXPORTING
         MODE_SFLIGHT20 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT20-carrid
         CONNID         = SFLIGHT20-connid
         FLDATE         = SFLIGHT20-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT20
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT20.

update SFLIGHT20
    set
        price     = SFLIGHT20-price
        planetype = SFLIGHT20-planetype
    where
        carrid = SFLIGHT20-carrid and
        connid = SFLIGHT20-connid and
        fldate = SFLIGHT20-fldate.

endform.                    " UPDATE_SFLIGHT20
