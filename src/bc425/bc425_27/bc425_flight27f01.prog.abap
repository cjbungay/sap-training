*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT27 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT27'
    EXPORTING
         MODE_SFLIGHT27 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT27-carrid
         CONNID         = SFLIGHT27-connid
         FLDATE         = SFLIGHT27-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT27
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT27.

update SFLIGHT27
    set
        price     = SFLIGHT27-price
        planetype = SFLIGHT27-planetype
    where
        carrid = SFLIGHT27-carrid and
        connid = SFLIGHT27-connid and
        fldate = SFLIGHT27-fldate.

endform.                    " UPDATE_SFLIGHT27
