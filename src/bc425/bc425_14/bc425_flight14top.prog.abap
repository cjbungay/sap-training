*&---------------------------------------------------------------------*
*& Include BC425D_EXIT_##TOP        Modulpool        SAPBC425D_EXIT_## *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc425d_exit_## MESSAGE-ID bc425.

TABLES:
    sflight14.

DATA:
    ok_code TYPE syucomm,
    save_ok TYPE syucomm,

* Table of Function codes to be excluded (and work area)
    wa_excl_tab type          syucomm,
    g_excl_tab  type table of syucomm,

    wa_flight type sflight14.

