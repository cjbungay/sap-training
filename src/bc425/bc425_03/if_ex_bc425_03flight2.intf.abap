*"* components of interface IF_EX_BC425_03FLIGHT2
interface IF_EX_BC425_03FLIGHT2
  public .


  data WA type SFLIGHT03 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT03 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT03 .
endinterface.
