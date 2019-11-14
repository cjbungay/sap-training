*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT29 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT29'
    EXPORTING
         MODE_SFLIGHT29 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT29-carrid
         CONNID         = SFLIGHT29-connid
         FLDATE         = SFLIGHT29-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT29
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT29.

update SFLIGHT29
    set
        price     = SFLIGHT29-price
        planetype = SFLIGHT29-planetype
    where
        carrid = SFLIGHT29-carrid and
        connid = SFLIGHT29-connid and
        fldate = SFLIGHT29-fldate.

endform.                    " UPDATE_SFLIGHT29
