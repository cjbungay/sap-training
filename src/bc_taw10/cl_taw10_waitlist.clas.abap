class CL_TAW10_WAITLIST definition
  public
  create public .

*"* public components of class CL_TAW10_WAITLIST
*"* do not include other source files here!!!
public section.

  interfaces IF_TAW10_STATUS .

  data CARRID type SFLIGHT-CARRID .
  data CONNID type SFLIGHT-CONNID .
  data FLDATE type SFLIGHT-FLDATE .

  events FIRST_GOT
    exporting
      value(EX_CUST) type ref to CL_TAW10_CUSTOMER .

  methods CONSTRUCTOR
    importing
      !IM_CARRID type SFLIGHT-CARRID
      !IM_CONNID type SFLIGHT-CONNID
      !IM_FLDATE type SFLIGHT-FLDATE .
  methods DELETE
    importing
      !IM_CUSTOMER type ref to CL_TAW10_CUSTOMER
    raising
      CX_TAW10_CUST_NOT_IN_LIST .
  methods GET_FIRST
    raising
      CX_TAW10_EMPTY_LIST .
  methods GET_POS
    importing
      !IM_CUSTOMER type ref to CL_TAW10_CUSTOMER
    exporting
      !EX_POS like SY-TABIX
    raising
      CX_TAW10_CUST_NOT_IN_LIST .
  methods GET_WAIT_LIST
    exporting
      !EX_WAIT_LIST type TAW10_TYPD_WAIT_LIST .
  methods ADD
    importing
      !IM_CUSTOMER type ref to CL_TAW10_CUSTOMER
    raising
      CX_TAW10_CUST_IN_LIST .
PROTECTED SECTION.
*"* protected components of class CL_TAW10_WAITLIST
*"* do not include other source files here!!!
private section.
*"* private components of class CL_TAW10_WAITLIST
*"* do not include other source files here!!!

  data WAIT_LIST type TAW10_TYPD_WAIT_LIST .
ENDCLASS.



CLASS CL_TAW10_WAITLIST IMPLEMENTATION.


method ADD .
READ TABLE wait_list  WITH KEY
        table_line->id = im_customer->id TRANSPORTING NO FIELDS.

    IF sy-subrc <> 0.
      INSERT im_customer INTO TABLE wait_list.
    ELSE.

      RAISE EXCEPTION TYPE cx_taw10_cust_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.
endmethod.


method CONSTRUCTOR .
carrid = im_carrid.
    connid = im_connid.
    fldate = im_fldate.
endmethod.


method DELETE .
DELETE wait_list
        WHERE table_line->id = im_customer->id.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_taw10_cust_not_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.
endmethod.


method GET_FIRST .
DATA r_cust TYPE REF TO cl_taw10_customer.

    READ TABLE wait_list INTO r_cust INDEX 1.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_taw10_empty_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          carrid = carrid
          connid = connid
          fldate = fldate.

    ELSE.
      DELETE wait_list INDEX 1.
      RAISE EVENT first_got EXPORTING ex_cust = r_cust.
    ENDIF.
endmethod.


method GET_POS .
READ TABLE wait_list
          WITH KEY table_line->id = im_customer->id
          TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      ex_pos = sy-tabix.
    ELSE.

      RAISE EXCEPTION TYPE cx_taw10_cust_not_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.

endmethod.


method GET_WAIT_LIST .
ex_wait_list = wait_list.
endmethod.


method IF_TAW10_STATUS~DISPLAY_STATUS .
DATA n_o_lines LIKE sy-tabix.
    n_o_lines = lines( wait_list ).

    MESSAGE i014(taw10) WITH carrid connid fldate n_o_lines.
*   Die Warteliste zum Flug &1 &2 &3 enthält &4 Einträge.
endmethod.
ENDCLASS.
