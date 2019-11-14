FUNCTION BC402_ALV_DEMO_OUTPUT.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"  IMPORTING
*"     REFERENCE(IT_LIST1) TYPE  BC402_T_FLIGHTS_COLOR
*"     REFERENCE(IT_LIST2) TYPE  BC402_T_FLIGHTS_COLOR OPTIONAL
*"----------------------------------------------------------------------

  CREATE OBJECT ref_lists1
    EXPORTING
      repid = g_repid
      dynnr = c_screen_no1
      area  = c_area_name.

  CALL METHOD ref_lists1->display_alv_lists
    EXPORTING
      it_list1               = it_list1
      it_list2               = it_list2
    EXCEPTIONS
      container_error        = 1
      container_method_error = 2.

  CASE sy-subrc.
    WHEN 1.
    WHEN 2.
  ENDCASE.

  g_status = c_status_1.

  call screen c_screen_no1.


ENDFUNCTION.
