*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight15 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT15'
    EXPORTING
         MODE_sflight15 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight15-carrid
         CONNID         = sflight15-connid
         FLDATE         = sflight15-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight15
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight15.

update sflight15
    set
        price     = sflight15-price
        planetype = sflight15-planetype
    where
        carrid = sflight15-carrid and
        connid = sflight15-connid and
        fldate = sflight15-fldate.

endform.                    " UPDATE_sflight15

