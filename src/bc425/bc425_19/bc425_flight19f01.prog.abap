*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_SFLIGHT19 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT19'
    EXPORTING
         MODE_SFLIGHT19 = 'E'
         MANDT          = SY-MANDT
         CARRID         = SFLIGHT19-carrid
         CONNID         = SFLIGHT19-connid
         FLDATE         = SFLIGHT19-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_SFLIGHT19
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_SFLIGHT19.

update SFLIGHT19
    set
        price     = SFLIGHT19-price
        planetype = SFLIGHT19-planetype
    where
        carrid = SFLIGHT19-carrid and
        connid = SFLIGHT19-connid and
        fldate = SFLIGHT19-fldate.

endform.                    " UPDATE_SFLIGHT19
