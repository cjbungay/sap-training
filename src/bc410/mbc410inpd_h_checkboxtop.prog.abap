*&---------------------------------------------------------------------*
*& Include MBC410DIAD_MODIFY_SCREENTOP                                 *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmbc410diad_modify_screen   .

DATA wa_spfli TYPE spfli.
TABLES sdyn_conn.

DATA: check_departure, check_arrival.

DATA: ok_code LIKE sy-ucomm.
