*"* components of interface IF_EX_BC425_02FLIGHT2
interface IF_EX_BC425_02FLIGHT2
  public .


  data WA type SFLIGHT02 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT02 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT02 .
endinterface.
