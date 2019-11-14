class CL_TAW10_DISPLAY_LOG definition
  public
  create public .

*"* public components of class CL_TAW10_DISPLAY_LOG
*"* do not include other source files here!!!
public section.

  methods DISPLAY_LOG .
protected section.
*"* protected components of class CL_TAW10_DISPLAY_LOG
*"* do not include other source files here!!!

  data IT_LOG type TAW10_TYPD_CUST_LIST .
private section.
*"* private components of class CL_TAW10_DISPLAY_LOG
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_TAW10_DISPLAY_LOG IMPLEMENTATION.


method DISPLAY_LOG .
DATA n_o_lines LIKE sy-tabix.

    n_o_lines = lines( it_log ).

    IF n_o_lines > 0.
      SORT it_log BY id.
      DELETE ADJACENT DUPLICATES FROM it_log COMPARING id.
      CALL FUNCTION 'TAW10_DISPLAY_DATA'
        EXPORTING
          im_list = it_log.
    ELSE.
      MESSAGE 'Es sind keine Nachrücker vorhanden.'(003) TYPE 'I'.
    ENDIF.
endmethod.
ENDCLASS.
