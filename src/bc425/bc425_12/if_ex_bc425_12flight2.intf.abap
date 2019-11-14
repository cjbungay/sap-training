*"* components of interface IF_EX_BC425_12FLIGHT2
interface IF_EX_BC425_12FLIGHT2
  public .


  data WA type SFLIGHT12 .

  methods GET_DATA
    exporting
      value(E_FLIGHT) type SFLIGHT12 .
  methods PUT_DATA
    importing
      value(I_FLIGHT) type SFLIGHT12 .
endinterface.
