FUNCTION BC402_ALV_DEMO_OUTPUT_DIA.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IT_LIST1) TYPE  BC402_T_FLIGHTS_COLOR
*"     REFERENCE(IT_LIST2) TYPE  BC402_T_FLIGHTS_COLOR OPTIONAL
*"  EXCEPTIONS
*"      CONTROL_ERROR
*"----------------------------------------------------------------------

  CREATE OBJECT ref_lists3
    EXPORTING
      repid = g_repid
      dynnr = c_screen_no3
      area  = c_area_name.

 CALL METHOD ref_lists3->display_alv_list1
    EXPORTING
      it_list               = it_list1
    EXCEPTIONS
      container_error        = 1.

  IF sy-subrc <> 0.
    raise control_error.
  endif.

  IF it_list2 IS INITIAL.
    g_status = c_status_1.
  ELSE.
    g_status = c_status_2.
    CALL METHOD ref_lists3->store_alv2_data
      EXPORTING
        it_list = it_list2.
  ENDIF.

  CALL SCREEN c_screen_no3.


ENDFUNCTION.
