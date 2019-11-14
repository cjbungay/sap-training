FUNCTION BC412_BDS_GET_PIC_URL_INTERACT.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(TITLE_TEXT) TYPE  C OPTIONAL
*"  EXPORTING
*"     REFERENCE(URL) TYPE  BAPIURI-URI
*"  EXCEPTIONS
*"      SELECTION_CANCELED
*"----------------------------------------------------------------------
  g_title_text = title_text.

  CALL SCREEN 100 STARTING AT 5 5.

  CASE copy_ok_code.
    WHEN 'OK'.
      url = l_url.
    WHEN 'CANCEL'.
      PERFORM init_global_data.
      RAISE selection_canceled.
  ENDCASE.
  clear g_title_text.
  PERFORM init_global_data.

ENDFUNCTION.
