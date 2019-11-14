*"* components of interface IF_EX_BC425_20FLIGHT2
interface IF_EX_BC425_20FLIGHT2
  public .


  data WA type SFLIGHT20 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT20 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT20 .
endinterface.
