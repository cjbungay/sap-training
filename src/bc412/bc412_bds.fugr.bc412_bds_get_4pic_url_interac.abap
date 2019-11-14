FUNCTION BC412_BDS_GET_4PIC_URL_INTERAC.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(TITLE_TEXT) TYPE  C OPTIONAL
*"  EXPORTING
*"     REFERENCE(URL1) TYPE  BAPIURI-URI
*"     REFERENCE(URL2) TYPE  BAPIURI-URI
*"     REFERENCE(URL3) TYPE  BAPIURI-URI
*"     REFERENCE(URL4) TYPE  BAPIURI-URI
*"  EXCEPTIONS
*"      SELECTION_CANCELED
*"----------------------------------------------------------------------
  g_title_text = title_text.

  PERFORM init_my_ts4.


  CALL SCREEN 400 STARTING AT 5 5.

  CASE copy_ok_code.
    WHEN 'OK'.
      url1 = l_url1.
      url2 = l_url2.
      url3 = l_url3.
      url4 = l_url4.
    WHEN 'CANCEL'.
      PERFORM init_global_data.
      RAISE selection_canceled.
  ENDCASE.
  CLEAR g_title_text.
  PERFORM init_global_data.

ENDFUNCTION.
