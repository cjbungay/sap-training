*"* components of interface IF_EX_BC425_15FLIGHT2
interface IF_EX_BC425_15FLIGHT2
  public .


  data WA type SFLIGHT15 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT15 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT15 .
endinterface.
