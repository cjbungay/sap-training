*&---------------------------------------------------------------------*
*& Report  SAPBC400UDD_SELECTION_SCREEN_2                              *
*&---------------------------------------------------------------------*

REPORT  sapbc400udd_selection_screen_2.

PARAMETERS: pa_car  TYPE sbc400focc-carrid,
            pa_con  TYPE sbc400focc-connid,
            pa_date TYPE sbc400focc-fldate.


START-OF-SELECTION.
  WRITE: / pa_car,
           pa_con,
           pa_date.
