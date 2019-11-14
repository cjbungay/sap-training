*"* components of interface IF_EX_BC425_08FLIGHT2
interface IF_EX_BC425_08FLIGHT2
  public .


  data WA type SFLIGHT08 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT08 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT08 .
endinterface.
