*&---------------------------------------------------------------------*
*& Include BC406CALS_CUSTOMER_INFOTOP                                  *
*&                                                                     *
*&---------------------------------------------------------------------*

PROGRAM  sapbc406cals_customer_info    .

TABLES: scustom.

DATA: ok_code LIKE sy-ucomm,
      save_ok LIKE ok_code.
