*"* components of interface IF_BC401_BOOD_EMPTY
interface IF_BC401_BOOD_EMPTY
  public .


  methods SEND_MESSAGE
    importing
      !IM_STRING type STRING default 'some characters ...' .
endinterface.
