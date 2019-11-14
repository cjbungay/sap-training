*"* components of interface IF_EX_BC425_25FLIGHT2
interface IF_EX_BC425_25FLIGHT2
  public .


  data WA type SFLIGHT25 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT25 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT25 .
endinterface.
