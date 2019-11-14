*&---------------------------------------------------------------------*
*& Report         SAPBC400WBT_GETTING_STARTED                          *
*&---------------------------------------------------------------------*

REPORT sapbc400wbt_getting_started .

DATA        wa_scarr TYPE scarr.
PARAMETERS  pa_car TYPE s_carr_id.

TABLES sbc400_carrier.


SELECT SINGLE * FROM scarr INTO wa_scarr
                WHERE carrid = pa_car.

IF sy-subrc = 0.

  MOVE-CORRESPONDING wa_scarr TO sbc400_carrier.
  CALL SCREEN 100.

  WRITE: wa_scarr-carrid,
         wa_scarr-carrname,
         wa_scarr-currcode.
ELSE.

  WRITE: 'Carrier', pa_car, 'not found'.

ENDIF.
