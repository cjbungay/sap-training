*"* components of interface IF_EX_BADI_BC417_EXPORT
interface IF_EX_BADI_BC417_EXPORT
  public .


  methods EXPORT_DATA
    importing
      value(COUNTRY) type BAPI0417_1-LAND1 optional
    exporting
      !EXTENSION_OUT type BAPIPAREX_BC417_TAB .
endinterface.
