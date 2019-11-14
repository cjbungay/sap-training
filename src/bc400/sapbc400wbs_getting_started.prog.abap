*&---------------------------------------------------------------------*
*& Report         SAPBC400WBS_GETTING_STARTED                          *
*&---------------------------------------------------------------------*

REPORT  sapbc400wbs_getting_started .

DATA        wa_scarr TYPE scarr.
PARAMETERS  pa_car   TYPE s_carr_id.

TABLES sbc400_carrier.


SELECT SINGLE * FROM scarr INTO wa_scarr
                WHERE carrid = pa_car.

IF sy-subrc = 0.

  MOVE-CORRESPONDING wa_scarr TO sbc400_carrier.
  CALL SCREEN 100.

  WRITE:  sbc400_carrier-carrid,
          sbc400_carrier-carrname,
          sbc400_carrier-currcode,
        / sbc400_carrier-uname,
          sbc400_carrier-uzeit,
          sbc400_carrier-datum.
ELSE.

  WRITE: 'Carrier', pa_car, 'not found'.

ENDIF.
