*"* components of interface IF_EX_BC425_21FLIGHT2
interface IF_EX_BC425_21FLIGHT2
  public .


  data WA type SFLIGHT21 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT21 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT21 .
endinterface.
