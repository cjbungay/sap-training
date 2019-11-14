*&---------------------------------------------------------------------*
*& Report  SAPBC400TSD_COPY_CLEAR                                      *
*&---------------------------------------------------------------------*

REPORT  sapbc400tsd_copy_clear .

CONSTANTS c_qf TYPE s_carr_id VALUE 'QF'.

DATA: gd_carrid1 TYPE s_carr_id,
      gd_carrid2 TYPE s_carr_id VALUE 'LH',
      counter TYPE i.


MOVE c_qf TO gd_carrid1.

gd_carrid2 = gd_carrid1.

ADD 1 TO counter.

CLEAR: gd_carrid1,
       gd_carrid2,
       counter.

WRITE 'End of Demo'.
