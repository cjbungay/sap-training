*&---------------------------------------------------------------------*
*& Report         SAPBC400TSS_ITAB_LOOP                                *
*&---------------------------------------------------------------------*

REPORT  sapbc400tss_itab_loop .

DATA  it_spfli TYPE sbc400_t_spfli.
DATA  wa_spfli LIKE LINE OF it_spfli.


SELECT * FROM spfli INTO TABLE it_spfli.


IF sy-subrc = 0.

  LOOP AT it_spfli INTO wa_spfli.
    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
             wa_spfli-cityfrom,
             wa_spfli-cityto,
             wa_spfli-deptime,
             wa_spfli-arrtime.
  ENDLOOP.

ELSE.

  WRITE 'No connection found'.

ENDIF.
