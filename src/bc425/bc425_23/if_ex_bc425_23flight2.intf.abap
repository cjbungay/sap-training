*"* components of interface IF_EX_BC425_23FLIGHT2
interface IF_EX_BC425_23FLIGHT2
  public .


  data WA type SFLIGHT23 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT23 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT23 .
endinterface.
