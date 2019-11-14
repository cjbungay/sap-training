*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight16 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT16'
    EXPORTING
         MODE_sflight16 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight16-carrid
         CONNID         = sflight16-connid
         FLDATE         = sflight16-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight16
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight16.

update sflight16
    set
        price     = sflight16-price
        planetype = sflight16-planetype
    where
        carrid = sflight16-carrid and
        connid = sflight16-connid and
        fldate = sflight16-fldate.

endform.                    " UPDATE_sflight16

