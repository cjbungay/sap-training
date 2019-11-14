*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight12 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT12'
    EXPORTING
         MODE_sflight12 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight12-carrid
         CONNID         = sflight12-connid
         FLDATE         = sflight12-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight12
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight12.

update sflight12
    set
        price     = sflight12-price
        planetype = sflight12-planetype
    where
        carrid = sflight12-carrid and
        connid = sflight12-connid and
        fldate = sflight12-fldate.

endform.                    " UPDATE_sflight12

