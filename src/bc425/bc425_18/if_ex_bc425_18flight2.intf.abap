*"* components of interface IF_EX_BC425_18FLIGHT2
interface IF_EX_BC425_18FLIGHT2
  public .


  data WA type SFLIGHT18 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT18 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT18 .
endinterface.
