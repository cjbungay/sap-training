*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight08 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT08'
    EXPORTING
         MODE_sflight08 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight08-carrid
         CONNID         = sflight08-connid
         FLDATE         = sflight08-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight08
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight08.

update sflight08
    set
        price     = sflight08-price
        planetype = sflight08-planetype
    where
        carrid = sflight08-carrid and
        connid = sflight08-connid and
        fldate = sflight08-fldate.

endform.                    " UPDATE_sflight08

