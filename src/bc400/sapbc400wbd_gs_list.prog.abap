*&---------------------------------------------------------------------*
*& Report         SAPBC400WBD_GS_LIST                                  *
*&---------------------------------------------------------------------*

REPORT sapbc400wbd_gs_list .

DATA  wa_scarr TYPE scarr.

PARAMETERS  pa_car TYPE s_carr_id.


SELECT SINGLE * FROM scarr INTO wa_scarr
                  WHERE carrid = pa_car.

IF sy-subrc = 0.

  WRITE: wa_scarr-carrid,
         wa_scarr-carrname,
         wa_scarr-currcode.
ELSE.

  WRITE: 'Carrier', pa_car, 'not found'.

ENDIF.
