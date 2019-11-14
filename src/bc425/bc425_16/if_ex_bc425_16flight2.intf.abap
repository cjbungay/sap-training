*"* components of interface IF_EX_BC425_16FLIGHT2
interface IF_EX_BC425_16FLIGHT2
  public .


  data WA type SFLIGHT16 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT16 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT16 .
endinterface.
