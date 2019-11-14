*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT28 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT28'
    EXPORTING
         MODE_SFLIGHT28 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT28-carrid
         CONNID         = SFLIGHT28-connid
         FLDATE         = SFLIGHT28-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT28
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT28.

update SFLIGHT28
    set
        price     = SFLIGHT28-price
        planetype = SFLIGHT28-planetype
    where
        carrid = SFLIGHT28-carrid and
        connid = SFLIGHT28-connid and
        fldate = SFLIGHT28-fldate.

endform.                    " UPDATE_SFLIGHT28
