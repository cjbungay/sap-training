FUNCTION BC402_ALV_DEMO_OUTPUT_EXT.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IT_LIST1) TYPE  BC402_T_FLIGHTS_COLOR
*"     REFERENCE(IT_LIST2) TYPE  BC402_T_NEST OPTIONAL
*"----------------------------------------------------------------------

  CREATE OBJECT ref_lists2
    EXPORTING
      repid = g_repid
      dynnr = c_screen_no2
      area  = c_area_name.

  CALL METHOD ref_lists2->display_alv_list1
    EXPORTING
      it_list               = it_list1
    EXCEPTIONS
      container_error        = 1.

  CASE sy-subrc.
    WHEN 1.
    WHEN 2.
  ENDCASE.

  IF it_list2 IS INITIAL.
    g_status = c_status_1.
  ELSE.
    g_status = c_status_2.
    CALL METHOD ref_lists2->store_alv2_data
      EXPORTING
        it_list = it_list2.
  ENDIF.

  CALL SCREEN c_screen_no2.


ENDFUNCTION.
