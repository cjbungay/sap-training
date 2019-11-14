*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_SELECTION_SCREEN_3                              *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_selection_screen_3.

PARAMETERS: pa_car  TYPE sbc400focc2-carrid,
            pa_con  TYPE sbc400focc2-connid,
            pa_date TYPE sbc400focc2-fldate.


START-OF-SELECTION.
  WRITE: / pa_car,
           pa_con,
           pa_date.
