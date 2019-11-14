*"* components of interface IF_EX_BC_TAW12_CS_01
interface IF_EX_BC_TAW12_CS_01
  public .


  data MODE type FLAG .
  data CARRID type S_CARR_ID .
  data CONNID type S_CONN_ID .
  data FLDATE type S_DATE .

  methods PUT_MODUS
    importing
      !I_MODE type C .
  methods PUT_KEY_DATA
    importing
      !I_CARRID type S_CARR_ID
      !I_CONNID type S_CONN_ID
      !I_FLDATE type S_DATE .
  methods GET_KEY_DATA
    exporting
      !E_CARRID type S_CARR_ID
      !E_CONNID type S_CONN_ID
      !E_FLDATE type S_DATE .
  methods GET_TAB_NAME
    exporting
      !TABNAME type C .
  methods PROCESS_FCODE
    importing
      !FCODE type C .
  methods SAVE
    importing
      !I_BOOKID type S_BOOK_ID .
  methods GET_MODUS
    exporting
      !E_MODE type C .
endinterface.
