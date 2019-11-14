*----------------------------------------------------------------------*
***INCLUDE BC425_FLIGHT_00F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SAVE_FLIGHTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form save_flights.

perform update_sflight02 on commit.

commit work.

CALL FUNCTION 'DEQUEUE_ESFLIGHT02'
    EXPORTING
         MODE_sflight02 = 'E'
         MANDT          = SY-MANDT
         CARRID         = sflight02-carrid
         CONNID         = sflight02-connid
         FLDATE         = sflight02-fldate
          .

endform.                    " SAVE_FLIGHTS

*&---------------------------------------------------------------------*
*&      Form  UPDATE_sflight02
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form update_sflight02.

update sflight02
    set
        price     = sflight02-price
        planetype = sflight02-planetype
    where
        carrid = sflight02-carrid and
        connid = sflight02-connid and
        fldate = sflight02-fldate.

endform.                    " UPDATE_sflight02

