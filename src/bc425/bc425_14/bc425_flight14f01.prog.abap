*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight14 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT14'
    EXPORTING
         MODE_sflight14 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight14-carrid
         CONNID         = sflight14-connid
         FLDATE         = sflight14-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight14
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight14.

update sflight14
    set
        price     = sflight14-price
        planetype = sflight14-planetype
    where
        carrid = sflight14-carrid and
        connid = sflight14-connid and
        fldate = sflight14-fldate.

endform.                    " UPDATE_sflight14

