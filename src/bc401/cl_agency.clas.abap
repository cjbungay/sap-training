class CL_AGENCY definition
  public
  create public .

*"* public components of class CL_AGENCY
*"* do not include other source files here!!!
public section.

  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING .
  methods GET_CONNECTION
    importing
      !IM_CARRID type S_CARR_ID default 'LH'
      !IM_CONNID type S_CONN_ID default '0400'
    exporting
      !EX_CONNECTION type SPFLI .
protected section.
*"* protected components of class CL_FLIGHT_FACTORY
*"* do not include other source files here!!!
private section.
*"* private components of class CL_FLIGHT_FACTORY
*"* do not include other source files here!!!

  data NAME type STRING .
ENDCLASS.



CLASS CL_AGENCY IMPLEMENTATION.


METHOD constructor .
  name = im_name.
ENDMETHOD.


METHOD get_connection .

  READ TABLE cl_singleton=>connection_list
           INTO ex_connection WITH KEY
                             mandt = sy-mandt
                             carrid = im_carrid
                             connid = im_connid.

  IF sy-subrc = 0.
    WRITE: 'Connection exists'(001).
  ELSE.
    WRITE: 'Connection did not exist'(002).
  ENDIF.

ENDMETHOD.                    "GET_FLIGHT
ENDCLASS.
