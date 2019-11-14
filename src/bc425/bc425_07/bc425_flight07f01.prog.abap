*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight07 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT07'
    EXPORTING
         MODE_sflight07 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight07-carrid
         CONNID         = sflight07-connid
         FLDATE         = sflight07-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight07
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight07.

update sflight07
    set
        price     = sflight07-price
        planetype = sflight07-planetype
    where
        carrid = sflight07-carrid and
        connid = sflight07-connid and
        fldate = sflight07-fldate.

endform.                    " UPDATE_sflight07

