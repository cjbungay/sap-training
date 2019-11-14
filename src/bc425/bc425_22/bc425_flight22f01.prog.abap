*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT22 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT22'
    EXPORTING
         MODE_SFLIGHT22 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT22-carrid
         CONNID         = SFLIGHT22-connid
         FLDATE         = SFLIGHT22-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT22
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT22.

update SFLIGHT22
    set
        price     = SFLIGHT22-price
        planetype = SFLIGHT22-planetype
    where
        carrid = SFLIGHT22-carrid and
        connid = SFLIGHT22-connid and
        fldate = SFLIGHT22-fldate.

endform.                    " UPDATE_SFLIGHT22
