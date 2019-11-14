*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT18 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT18'
    EXPORTING
         MODE_SFLIGHT18 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT18-carrid
         CONNID         = SFLIGHT18-connid
         FLDATE         = SFLIGHT18-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT18
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT18.

update SFLIGHT18
    set
        price     = SFLIGHT18-price
        planetype = SFLIGHT18-planetype
    where
        carrid = SFLIGHT18-carrid and
        connid = SFLIGHT18-connid and
        fldate = SFLIGHT18-fldate.

endform.                    " UPDATE_SFLIGHT18

