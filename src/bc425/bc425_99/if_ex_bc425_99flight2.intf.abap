*"* components of interface IF_EX_BC425_99FLIGHT2
interface IF_EX_BC425_99FLIGHT2
  public .


  data WA type SFLIGHT99 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT99 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT99 .
endinterface.
