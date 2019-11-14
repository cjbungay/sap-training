class CL_TAW10_LOG definition
  public
  inheriting from CL_TAW10_DISPLAY_LOG
  create public .

*"* public components of class CL_TAW10_LOG
*"* do not include other source files here!!!
public section.

  interfaces IF_TAW10_STATUS .

  methods GET_CUST
    for event FIRST_GOT of CL_TAW10_WAITLIST
    importing
      !EX_CUST .
protected section.
*"* protected components of class CL_TAW10_LOG
*"* do not include other source files here!!!
private section.
*"* private components of class CL_TAW10_LOG
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_TAW10_LOG IMPLEMENTATION.


method GET_CUST .
DATA wa_cust TYPE taw10_typd_cust.

    ex_cust->get_attributes( IMPORTING ex_cust = wa_cust ).
    INSERT wa_cust INTO TABLE it_log.
endmethod.


method IF_TAW10_STATUS~DISPLAY_STATUS .
DATA: n_o_lines LIKE sy-tabix,
          c_n_o_lines TYPE string,
          text TYPE string.

    SORT it_log BY id.
    DELETE ADJACENT DUPLICATES FROM it_log COMPARING id.

    n_o_lines = lines( it_log ).
    c_n_o_lines = n_o_lines.
    CONCATENATE 'Anzahl der Nachrücker:'(004)
                 c_n_o_lines INTO text SEPARATED BY space.

    MESSAGE  text TYPE 'I'.

endmethod.
ENDCLASS.
