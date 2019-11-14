*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT26 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT26'
    EXPORTING
         MODE_SFLIGHT26 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT26-carrid
         CONNID         = SFLIGHT26-connid
         FLDATE         = SFLIGHT26-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT26
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT26.

update SFLIGHT26
    set
        price     = SFLIGHT26-price
        planetype = SFLIGHT26-planetype
    where
        carrid = SFLIGHT26-carrid and
        connid = SFLIGHT26-connid and
        fldate = SFLIGHT26-fldate.

endform.                    " UPDATE_SFLIGHT26
