*"* components of interface IF_EX_BC425_04FLIGHT2
interface IF_EX_BC425_04FLIGHT2
  public .


  data WA type SFLIGHT04 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT04 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT04 .
endinterface.
