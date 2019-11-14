*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_SELECTION_SCREEN_1                              *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_selection_screen_1.

PARAMETERS: pa_car  TYPE s_carr_id,
            pa_con  TYPE s_conn_id,
            pa_date TYPE s_date.


START-OF-SELECTION.
  WRITE: / pa_car,
           pa_con,
           pa_date.
