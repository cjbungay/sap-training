*&---------------------------------------------------------------------*
*& Include BC410DIAD_C_DYNPRO_PRETOP                                   *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT   sapbc410diad_c_dynpro_pre          .

DATA: ok_code TYPE sy-ucomm.
DATA: wa_spfli TYPE spfli.

TABLES sdyn_conn.
