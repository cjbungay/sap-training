*"* components of interface IF_EX_BC425_00FLIGHT2
interface IF_EX_BC425_00FLIGHT2
  public .


  data WA type SFLIGHT00 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT00 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT00 .
endinterface.
