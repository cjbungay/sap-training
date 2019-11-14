*"* components of interface IF_EX_BC425_11FLIGHT2
interface IF_EX_BC425_11FLIGHT2
  public .


  data WA type SFLIGHT11 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT11 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT11 .
endinterface.
