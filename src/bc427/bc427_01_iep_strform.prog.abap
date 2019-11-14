REPORT  bc427_01_iep_strform.

PARAMETERS p_carr TYPE s_carr_id.

DATA: BEGIN OF wa_conn,
        carrid    TYPE spfli-carrid,
        connid    TYPE spfli-connid,
        cityfrom  TYPE spfli-cityfrom,
        cityto    TYPE spfli-cityto,
      END OF wa_conn.


START-OF-SELECTION.

  SELECT * FROM spfli
    INTO CORRESPONDING FIELDS OF wa_conn
    WHERE  carrid = p_carr.

    PERFORM display_conn  USING wa_conn.

  ENDSELECT.

  IF sy-subrc NE 0.
    MESSAGE 'No connections found !' TYPE 'I'.
  ENDIF.


*----------------------------------------------------------------------*

FORM display_conn  USING f_conn LIKE wa_conn.

  WRITE: / f_conn-carrid, f_conn-connid, f_conn-cityfrom, f_conn-cityto.

ENDFORM.
