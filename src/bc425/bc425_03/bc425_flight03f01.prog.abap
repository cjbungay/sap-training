*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight03 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT03'
    EXPORTING
         MODE_sflight03 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight03-carrid
         CONNID         = sflight03-connid
         FLDATE         = sflight03-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight03
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight03.

update sflight03
    set
        price     = sflight03-price
        planetype = sflight03-planetype
    where
        carrid = sflight03-carrid and
        connid = sflight03-connid and
        fldate = sflight03-fldate.

endform.                    " UPDATE_sflight03

