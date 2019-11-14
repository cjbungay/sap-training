*&---------------------------------------------------------------------*
*& Report  SAPBC400DDD_SELECT_SINGLE                                   *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  reading single entry from database : SELECT SINGLE                 *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400ddd_select_single .

PARAMETERS pa_car TYPE s_carr_id.

DATA wa_scarr TYPE scarr.


SELECT SINGLE * FROM scarr
                INTO CORRESPONDING FIELDS OF wa_scarr
                WHERE carrid = pa_car.

IF sy-subrc = 0.
  WRITE: / wa_scarr-carrid,
           wa_scarr-carrname,
           wa_scarr-currcode.
else .
  write: / text-001 color col_negative.
ENDIF.
