*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT24 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT24'
    EXPORTING
         MODE_SFLIGHT24 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT24-carrid
         CONNID         = SFLIGHT24-connid
         FLDATE         = SFLIGHT24-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT24
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT24.

update SFLIGHT24
    set
        price     = SFLIGHT24-price
        planetype = SFLIGHT24-planetype
    where
        carrid = SFLIGHT24-carrid and
        connid = SFLIGHT24-connid and
        fldate = SFLIGHT24-fldate.

endform.                    " UPDATE_SFLIGHT24
