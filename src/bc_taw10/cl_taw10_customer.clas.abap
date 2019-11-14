class CL_TAW10_CUSTOMER definition
  public
  create public .

*"* public components of class CL_TAW10_CUSTOMER
*"* do not include other source files here!!!
public section.

  interfaces IF_TAW10_STATUS .

  data ID type S_CUSTOMER .

  methods CONSTRUCTOR
    importing
      !IM_APP_DATE type D
      !IM_CITY type CITY
      !IM_ID type S_CUSTOMER
      !IM_NAME type S_CUSTNAME
      !IM_STREET type S_STREET .
  methods GET_ATTRIBUTES
    exporting
      !EX_CUST type TAW10_TYPD_CUST .
protected section.
*"* protected components of class CL_TAW10_CUSTOMER
*"* do not include other source files here!!!
private section.
*"* private components of class CL_TAW10_CUSTOMER
*"* do not include other source files here!!!

  data CITY type CITY .
  data NAME type S_CUSTNAME .
  data STREET type S_STREET .
  data APP_DATE type D .
ENDCLASS.



CLASS CL_TAW10_CUSTOMER IMPLEMENTATION.


method CONSTRUCTOR .
id = im_id.
    name = im_name.
    street = im_street.
    city = im_city.
    app_date = im_app_date.
endmethod.


method GET_ATTRIBUTES .
ex_cust-id = id.
    ex_cust-name = name.
    ex_cust-street = street.
    ex_cust-city = city.
    ex_cust-app_date = app_date.
endmethod.


method IF_TAW10_STATUS~DISPLAY_STATUS .
DATA custtype TYPE s_custtype.
    CONSTANTS: bcust(1) TYPE c VALUE 'B',
               pcust(1) TYPE c VALUE 'P'.

    SELECT SINGLE custtype FROM scustom INTO (custtype)
      WHERE id = id.

    IF sy-subrc = 0.
      CASE custtype.
        WHEN bcust.
          MESSAGE i015(taw10) WITH id 'Geschäftskunde'(001).
*         Kunde &1 ist &2.
        WHEN pcust.
          MESSAGE i015(taw10) WITH id 'Privatkunde'(002).
*         Kunde &1 ist &2.
      ENDCASE.
    ENDIF.

endmethod.
ENDCLASS.
