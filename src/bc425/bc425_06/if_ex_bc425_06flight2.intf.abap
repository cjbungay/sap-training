*"* components of interface IF_EX_BC425_06FLIGHT2
interface IF_EX_BC425_06FLIGHT2
  public .


  data WA type SFLIGHT06 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT06 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT06 .
endinterface.
