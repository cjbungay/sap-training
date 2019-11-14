*"* components of interface IF_EX_BC425_27FLIGHT2
interface IF_EX_BC425_27FLIGHT2
  public .


  data WA type SFLIGHT27 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT27 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT27 .
endinterface.
