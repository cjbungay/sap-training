*&---------------------------------------------------------------------*
*& Report         SAPBC400WBD_GS_DYNPRO                                *
*&---------------------------------------------------------------------*

REPORT sapbc400wbd_gs_dynpro .

TABLES sbc400_carrier.
DATA  wa_scarr TYPE scarr.
PARAMETERS pa_car TYPE s_carr_id.


SELECT SINGLE * FROM scarr
                INTO wa_scarr
                WHERE carrid = pa_car.
IF sy-subrc = 0.
  MOVE-CORRESPONDING wa_scarr TO sbc400_carrier.
  CALL SCREEN 100.
  MOVE-CORRESPONDING sbc400_carrier TO wa_scarr.

  WRITE:  wa_scarr-carrid,
          wa_scarr-carrname,
          wa_scarr-currcode.
ENDIF.
