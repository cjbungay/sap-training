*"* components of interface IF_EX_BC425_05FLIGHT2
interface IF_EX_BC425_05FLIGHT2
  public .


  data WA type SFLIGHT05 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT05 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT05 .
endinterface.
