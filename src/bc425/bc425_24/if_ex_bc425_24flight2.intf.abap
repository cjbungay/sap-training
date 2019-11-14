*"* components of interface IF_EX_BC425_24FLIGHT2
interface IF_EX_BC425_24FLIGHT2
  public .


  data WA type SFLIGHT24 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT24 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT24 .
endinterface.
