*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight00 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT00'
    EXPORTING
         MODE_SFLIGHT00 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight00-carrid
         CONNID         = sflight00-connid
         FLDATE         = sflight00-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT00
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight00.

update sflight00
    set
        price     = sflight00-price
        planetype = sflight00-planetype
    where
        carrid = sflight00-carrid and
        connid = sflight00-connid and
        fldate = sflight00-fldate.

endform.                    " UPDATE_SFLIGHT00

