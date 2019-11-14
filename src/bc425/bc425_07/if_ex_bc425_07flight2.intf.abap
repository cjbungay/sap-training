*"* components of interface IF_EX_BC425_07FLIGHT2
interface IF_EX_BC425_07FLIGHT2
  public .


  data WA type SFLIGHT07 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT07 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT07 .
endinterface.
