*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT25 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT25'
    EXPORTING
         MODE_SFLIGHT25 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT25-carrid
         CONNID         = SFLIGHT25-connid
         FLDATE         = SFLIGHT25-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT25
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT25.

update SFLIGHT25
    set
        price     = SFLIGHT25-price
        planetype = SFLIGHT25-planetype
    where
        carrid = SFLIGHT25-carrid and
        connid = SFLIGHT25-connid and
        fldate = SFLIGHT25-fldate.

endform.                    " UPDATE_SFLIGHT25
