*----------------------------------------------------------------------*
*   INCLUDE BC410GUID_A_GUI_PRETOP                                     *
*----------------------------------------------------------------------*

CONSTANTS : len_con TYPE i VALUE 8,
            len_cit TYPE i VALUE 20,
            len_tim TYPE i VALUE 8,
            len_dat TYPE i VALUE 10,
            len_pri TYPE i VALUE 25,
            len_sea TYPE i VALUE 10.

DATA: wa_spfli TYPE spfli,
      it_spfli LIKE TABLE OF wa_spfli.

DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight.


SELECT-OPTIONS so_carr FOR wa_spfli-carrid.


