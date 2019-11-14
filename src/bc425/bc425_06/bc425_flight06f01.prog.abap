*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight06 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT06'
    EXPORTING
         MODE_sflight06 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight06-carrid
         CONNID         = sflight06-connid
         FLDATE         = sflight06-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight06
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight06.

update sflight06
    set
        price     = sflight06-price
        planetype = sflight06-planetype
    where
        carrid = sflight06-carrid and
        connid = sflight06-connid and
        fldate = sflight06-fldate.

endform.                    " UPDATE_sflight06

