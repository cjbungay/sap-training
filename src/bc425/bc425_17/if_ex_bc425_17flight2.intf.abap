*"* components of interface IF_EX_BC425_17FLIGHT2
interface IF_EX_BC425_17FLIGHT2
  public .


  data WA type SFLIGHT17 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT17 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT17 .
endinterface.
