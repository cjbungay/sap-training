*"* components of interface IF_EX_BC425_01FLIGHT2
interface IF_EX_BC425_01FLIGHT2
  public .


  data WA type SFLIGHT01 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT01 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT01 .
endinterface.
