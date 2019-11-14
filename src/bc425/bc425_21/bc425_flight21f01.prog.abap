*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT21 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT21'
    EXPORTING
         MODE_SFLIGHT21 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT21-carrid
         CONNID         = SFLIGHT21-connid
         FLDATE         = SFLIGHT21-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT21
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT21.

update SFLIGHT21
    set
        price     = SFLIGHT21-price
        planetype = SFLIGHT21-planetype
    where
        carrid = SFLIGHT21-carrid and
        connid = SFLIGHT21-connid and
        fldate = SFLIGHT21-fldate.

endform.                    " UPDATE_SFLIGHT21
