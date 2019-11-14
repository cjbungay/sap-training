*&---------------------------------------------------------------------*
*& Report         SAPBC400WBT_GS_LIST                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*


REPORT sapbc400wbt_gs_list    .

DATA: wa_scarr TYPE scarr.
PARAMETERS: pa_car TYPE s_carr_id.


START-OF-SELECTION.
  SELECT SINGLE * FROM scarr INTO CORRESPONDING FIELDS OF wa_scarr
                  WHERE carrid = pa_car.
  IF sy-subrc = 0.


    WRITE:  wa_scarr-carrid,
            wa_scarr-carrname,
            wa_scarr-currcode.
  ENDIF.
