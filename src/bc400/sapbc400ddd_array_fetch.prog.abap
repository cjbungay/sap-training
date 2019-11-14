*&---------------------------------------------------------------------*
*& Report  SAPBC400DDD_ARRAY_FETCH                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Reading one database table via Array Fetch (SELECT ... INTO TABLE)  *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc400ddd_array_fetch.

DATA: itab_spfli TYPE sbc400_t_spfli,
      wa_spfli LIKE LINE OF itab_spfli.


SELECT carrid connid
       airpfrom cityfrom countryfr
       airpto cityto countryto
       deptime
       FROM spfli
       INTO CORRESPONDING FIELDS OF TABLE itab_spfli.


LOOP AT itab_spfli INTO wa_spfli.

  WRITE: / wa_spfli-carrid,
           wa_spfli-connid,
           wa_spfli-airpfrom,
           wa_spfli-cityfrom,
           wa_spfli-countryfr,
           wa_spfli-airpto,
           wa_spfli-cityto,
           wa_spfli-countryto,
           wa_spfli-deptime.
ENDLOOP.
