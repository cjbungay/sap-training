*"* components of interface IF_EX_BC425_19FLIGHT2
interface IF_EX_BC425_19FLIGHT2
  public .


  data WA type SFLIGHT19 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT19 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT19 .
endinterface.
