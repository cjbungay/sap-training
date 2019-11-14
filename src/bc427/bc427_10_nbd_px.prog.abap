REPORT  bc427_10_nbd_px.

DATA it_spfli TYPE TABLE OF spfli.
DATA wa_spfli LIKE LINE OF it_spfli.

DATA r_exit TYPE REF TO bc427_10_px_badi.


START-OF-SELECTION.

  SELECT * FROM spfli INTO TABLE it_spfli.

  TRY.
    GET BADI r_exit.
   CATCH cx_badi_not_implemented.
  ENDTRY.

  LOOP AT it_spfli INTO wa_spfli.

    WRITE: / wa_spfli-carrid,
             wa_spfli-connid,
          14 wa_spfli-cityfrom,
             wa_spfli-cityto.

    IF r_exit IS NOT INITIAL.
      CALL BADI r_exit->write_additional_cols
        EXPORTING
          i_wa_spfli = wa_spfli.
    ENDIF.

  ENDLOOP.
