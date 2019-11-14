class CL_BC402_SHM_CATALOG definition
  public
  final
  create public
  shared memory enabled .

*"* public components of class CL_BC402_SHM_CATALOG
*"* do not include other source files here!!!
public section.

  methods FILL_CATALOG
    importing
      !IT_CATALOG type BC402_T_SPFLI .
  methods GET_CONNECTIONS
    importing
      value(IV_CARRID) type S_CARR_ID
    exporting
      !ET_CONNECTIONS type BC402_T_SPFLI .
protected section.
*"* protected components of class CL_BC402_SHM_CATALOG
*"* do not include other source files here!!!
private section.
*"* private components of class CL_BC402_SHM_CATALOG
*"* do not include other source files here!!!

  data GT_CATALOG type BC402_T_SPFLI .
ENDCLASS.



CLASS CL_BC402_SHM_CATALOG IMPLEMENTATION.


METHOD fill_catalog.

  gt_catalog = it_catalog.

ENDMETHOD.


METHOD get_connections.

  FIELD-SYMBOLS:
      <fs> TYPE spfli.

  LOOP AT gt_catalog ASSIGNING <fs>
                     WHERE carrid = iv_carrid.
    APPEND <fs> TO et_connections.
  ENDLOOP.

ENDMETHOD.
ENDCLASS.
