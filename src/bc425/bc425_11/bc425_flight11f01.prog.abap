*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight11 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT11'
    EXPORTING
         MODE_sflight11 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight11-carrid
         CONNID         = sflight11-connid
         FLDATE         = sflight11-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight11
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight11.

update sflight11
    set
        price     = sflight11-price
        planetype = sflight11-planetype
    where
        carrid = sflight11-carrid and
        connid = sflight11-connid and
        fldate = sflight11-fldate.

endform.                    " UPDATE_sflight11

