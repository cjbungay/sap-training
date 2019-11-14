*"* components of interface IF_EX_BC427_SCREEN_EXIT_BADI
interface IF_EX_BC427_SCREEN_EXIT_BADI
  public .


  interfaces IF_BADI_INTERFACE .

  methods PUT_DATA
    importing
      !IM_WA_SCARR type SCARR .
endinterface.
