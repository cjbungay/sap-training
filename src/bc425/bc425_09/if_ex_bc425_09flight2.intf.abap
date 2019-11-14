*"* components of interface IF_EX_BC425_09FLIGHT2
interface IF_EX_BC425_09FLIGHT2
  public .


  data WA type SFLIGHT09 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT09 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT09 .
endinterface.
