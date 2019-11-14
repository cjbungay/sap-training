*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight05 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT05'
    EXPORTING
         MODE_sflight05 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight05-carrid
         CONNID         = sflight05-connid
         FLDATE         = sflight05-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight05
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight05.

update sflight05
    set
        price     = sflight05-price
        planetype = sflight05-planetype
    where
        carrid = sflight05-carrid and
        connid = sflight05-connid and
        fldate = sflight05-fldate.

endform.                    " UPDATE_sflight05

