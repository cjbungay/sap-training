*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT30 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT30'
    EXPORTING
         MODE_SFLIGHT30 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT30-carrid
         CONNID         = SFLIGHT30-connid
         FLDATE         = SFLIGHT30-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT30
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT30.

update SFLIGHT30
    set
        price     = SFLIGHT30-price
        planetype = SFLIGHT30-planetype
    where
        carrid = SFLIGHT30-carrid and
        connid = SFLIGHT30-connid and
        fldate = SFLIGHT30-fldate.

endform.                    " UPDATE_SFLIGHT30
