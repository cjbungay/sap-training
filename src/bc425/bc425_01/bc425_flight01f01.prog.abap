*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight01 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT01'
    EXPORTING
         MODE_sflight01 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight01-carrid
         CONNID         = sflight01-connid
         FLDATE         = sflight01-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight01
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight01.

update sflight01
    set
        price     = sflight01-price
        planetype = sflight01-planetype
    where
        carrid = sflight01-carrid and
        connid = sflight01-connid and
        fldate = sflight01-fldate.

endform.                    " UPDATE_sflight01

