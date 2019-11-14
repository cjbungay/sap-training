*"* components of interface IF_EX_BC425_10FLIGHT2
interface IF_EX_BC425_10FLIGHT2
  public .


  data WA type SFLIGHT10 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT10 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT10 .
endinterface.
