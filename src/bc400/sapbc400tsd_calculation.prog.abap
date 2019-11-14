*&---------------------------------------------------------------------*
*& Report  SAPBC400TSD_CALCULATION                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400tsd_calculation.

PARAMETERS: pa_occ TYPE sbc400focc-seatsocc,
            pa_max TYPE sbc400focc-seatsmax.

DATA gd_percentage TYPE sbc400focc-percentage.


START-OF-SELECTION.

  COMPUTE gd_percentage  =  pa_occ * 100 / pa_max .

* gd_percentage  =  pa_occ * 100 / pa_max .

  WRITE: / pa_occ,
           pa_max,
        30 gd_percentage, '%'.
  ULINE .
