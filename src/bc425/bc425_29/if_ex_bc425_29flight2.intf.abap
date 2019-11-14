*"* components of interface IF_EX_BC425_29FLIGHT2
interface IF_EX_BC425_29FLIGHT2
  public .


  data WA type SFLIGHT29 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT29 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT29 .
endinterface.
