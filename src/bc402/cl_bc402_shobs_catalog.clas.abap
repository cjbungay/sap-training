class CL_BC402_SHOBS_CATALOG definition
  public
  final
  create public
  shared memory enabled .

*"* public components of class CL_BC402_SHOBS_CATALOG
*"* do not include other source files here!!!
public section.

  methods FILL_CATALOG
    importing
      !IT_CATALOG type BC402_T_SDYNCONN .
  methods GET_FLIGHTS
    importing
      !IV_FROM_CITY type S_FROM_CIT
      !IV_TO_CITY type S_TO_CITY
      !IV_EARLIEST type S_DATE
      !IV_LATEST type S_DATE
    exporting
      !ET_FLIGHTS type BC402_T_SDYNCONN .
protected section.
*"* protected components of class CL_BC402_SHOBS_CATALOG
*"* do not include other source files here!!!
private section.
*"* private components of class CL_BC402_SHOBS_CATALOG
*"* do not include other source files here!!!

  data GT_CATALOG type BC402_T_SDYNCONN .
ENDCLASS.



CLASS CL_BC402_SHOBS_CATALOG IMPLEMENTATION.


METHOD fill_catalog.

  gt_catalog = it_catalog.

ENDMETHOD.


METHOD get_flights.

  FIELD-SYMBOLS:
      <fs> TYPE sdyn_conn.

  LOOP AT gt_catalog ASSIGNING <fs>
                     WHERE cityfrom = iv_from_city AND
                           cityto   = iv_to_city   AND
                           fldate   > iv_earliest  AND
                           fldate   < iv_latest.

    APPEND <fs> TO et_flights.

  ENDLOOP.

ENDMETHOD.
ENDCLASS.
