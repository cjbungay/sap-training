FUNCTION bc412_bds_get_2pic_url_interac.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(TITLE_TEXT) TYPE  C OPTIONAL
*"  EXPORTING
*"     REFERENCE(URL1) TYPE  BAPIURI-URI
*"     REFERENCE(URL2) TYPE  BAPIURI-URI
*"  EXCEPTIONS
*"      SELECTION_CANCELED
*"----------------------------------------------------------------------
  g_title_text = title_text.

  PERFORM init_my_ts2.


  CALL SCREEN 200 STARTING AT 5 5.

  CASE copy_ok_code.
    WHEN 'OK'.
      url1 = l_url1.
      url2 = l_url2.
    WHEN 'CANCEL'.
      PERFORM init_global_data.
      RAISE selection_canceled.
  ENDCASE.
  CLEAR g_title_text.
  PERFORM init_global_data.

ENDFUNCTION.
