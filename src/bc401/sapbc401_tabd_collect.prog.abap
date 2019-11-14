*&---------------------------------------------------------------------*
*& Report  SAPBC401_TABD_COLLECT                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*& collects the prices for each flight of all carriers                 *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc401_tabd_collect.

CONSTANTS c_curr TYPE sflight-currency VALUE 'USD'.

TYPES:
  BEGIN OF t_carr_info,
    carrid   TYPE sflight-carrid,
    price    TYPE sflight-price,
    currency TYPE sflight-currency,
  END OF t_carr_info.

DATA:
  it_carr_list TYPE SORTED TABLE OF t_carr_info
               WITH UNIQUE KEY carrid currency,     	

  wa TYPE t_carr_info.


START-OF-SELECTION.

  SELECT carrid price currency
         FROM sflight
         INTO wa
         WHERE currency = c_curr.
    COLLECT wa INTO it_carr_list.
  ENDSELECT.

  LOOP AT it_carr_list INTO wa.
    WRITE: / wa-carrid,
             wa-price CURRENCY wa-currency,
             wa-currency.
  ENDLOOP.
