*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight13 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT13'
    EXPORTING
         MODE_sflight13 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight13-carrid
         CONNID         = sflight13-connid
         FLDATE         = sflight13-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight13
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight13.

update sflight13
    set
        price     = sflight13-price
        planetype = sflight13-planetype
    where
        carrid = sflight13-carrid and
        connid = sflight13-connid and
        fldate = sflight13-fldate.

endform.                    " UPDATE_sflight13

