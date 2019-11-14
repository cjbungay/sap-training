*----------------------------------------------------------------------*

*   INCLUDE BC406ILSD_D_DYNASORT_READYTOP                             *
*----------------------------------------------------------------------*


CONSTANTS : len_con TYPE i VALUE 8,
            len_cit TYPE i VALUE 20,
            len_tim TYPE i VALUE 8,
            len_dat TYPE i VALUE 10,
            len_pri TYPE i VALUE 25,
            len_sea TYPE i VALUE 10.

data  sortfield(30).

DATA mark(1).

DATA: BEGIN OF key_spfli,
        carrid TYPE spfli-carrid,
        connid TYPE spfli-connid,
      END OF key_spfli.

DATA: wa_spfli TYPE spfli,
      it_spfli LIKE TABLE OF wa_spfli.

DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight,
      it_sflight_read LIKE it_sflight.

DATA time_toggle(30).

SELECT-OPTIONS so_carr FOR wa_spfli-carrid.
