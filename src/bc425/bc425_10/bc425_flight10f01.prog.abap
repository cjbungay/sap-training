*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight10 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT10'
    EXPORTING
         MODE_sflight10 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight10-carrid
         CONNID         = sflight10-connid
         FLDATE         = sflight10-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight10
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight10.

update sflight10
    set
        price     = sflight10-price
        planetype = sflight10-planetype
    where
        carrid = sflight10-carrid and
        connid = sflight10-connid and
        fldate = sflight10-fldate.

endform.                    " UPDATE_sflight10

