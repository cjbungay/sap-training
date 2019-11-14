*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight04 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT04'
    EXPORTING
         MODE_sflight04 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight04-carrid
         CONNID         = sflight04-connid
         FLDATE         = sflight04-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight04
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight04.

update sflight04
    set
        price     = sflight04-price
        planetype = sflight04-planetype
    where
        carrid = sflight04-carrid and
        connid = sflight04-connid and
        fldate = sflight04-fldate.

endform.                    " UPDATE_sflight04

