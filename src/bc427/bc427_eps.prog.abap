REPORT  BC427_EPS.

PARAMETERS pa_carr TYPE s_carr_id.

DATA wa_scarr TYPE scarr.


START-OF-SELECTION.

  SELECT SINGLE * FROM scarr
    INTO wa_scarr
    WHERE  carrid = pa_carr.

  IF sy-subrc NE 0.
ENHANCEMENT-SECTION     BC427_ES1 SPOTS BC427_ESPOT1.
    MESSAGE 'Carrier not found !' TYPE 'I'.
    EXIT.
END-ENHANCEMENT-SECTION.
  ENDIF.

  WRITE: wa_scarr-carrid, wa_scarr-carrname.

ENHANCEMENT-POINT BC427_EP1 SPOTS BC427_ESPOT1.

  SKIP.
  WRITE 'End of carrier display ##'.
