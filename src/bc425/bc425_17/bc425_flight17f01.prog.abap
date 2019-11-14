*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT17 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT17'
    EXPORTING
         MODE_SFLIGHT17 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT17-carrid
         CONNID         = SFLIGHT17-connid
         FLDATE         = SFLIGHT17-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT17
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT17.

update SFLIGHT17
    set
        price     = SFLIGHT17-price
        planetype = SFLIGHT17-planetype
    where
        carrid = SFLIGHT17-carrid and
        connid = SFLIGHT17-connid and
        fldate = SFLIGHT17-fldate.

endform.                    " UPDATE_SFLIGHT17

