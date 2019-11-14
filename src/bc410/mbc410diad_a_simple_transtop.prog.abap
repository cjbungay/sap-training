*&---------------------------------------------------------------------*
*& Include MBC410DIAD_SIMPLE_TRANSTOP                                  *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapmbc410diad_simple_trans    .


* ABAP Arbeitsbereich
* ABAP workarea
DATA wa_spfli TYPE spfli.

* Arbeitsbereich für automatischen Datentransport vom und zum Dynpro
* Workarea for automatic data transport from and to the dynpros
TABLES sdyn_conn.


*** INCLUDE MBC410DIAD_A_SIMPLE_TRANSTOP

