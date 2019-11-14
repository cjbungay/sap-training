*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT23 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT23'
    EXPORTING
         MODE_SFLIGHT23 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT23-carrid
         CONNID         = SFLIGHT23-connid
         FLDATE         = SFLIGHT23-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT23
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT23.

update SFLIGHT23
    set
        price     = SFLIGHT23-price
        planetype = SFLIGHT23-planetype
    where
        carrid = SFLIGHT23-carrid and
        connid = SFLIGHT23-connid and
        fldate = SFLIGHT23-fldate.

endform.                    " UPDATE_SFLIGHT23
