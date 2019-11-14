*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight09 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT09'
    EXPORTING
         MODE_sflight09 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight09-carrid
         CONNID         = sflight09-connid
         FLDATE         = sflight09-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight09
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight09.

update sflight09
    set
        price     = sflight09-price
        planetype = sflight09-planetype
    where
        carrid = sflight09-carrid and
        connid = sflight09-connid and
        fldate = sflight09-fldate.

endform.                    " UPDATE_sflight09

