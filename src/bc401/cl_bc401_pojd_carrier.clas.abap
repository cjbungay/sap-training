class CL_BC401_POJD_CARRIER definition
  public
  final
  create protected

  global friends CB_BC401_POJD_CARRIER .

*"* public components of class CL_BC401_POJD_CARRIER
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  interfaces IF_OS_STATE .

  methods GET_CURRCODE
    returning
      value(RESULT) type S_CURRCODE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CARRNAME
    importing
      !I_CARRNAME type S_CARRNAME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_URL
    importing
      !I_URL type S_CARRURL
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CARRNAME
    returning
      value(RESULT) type S_CARRNAME
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_URL
    returning
      value(RESULT) type S_CARRURL
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods SET_CURRCODE
    importing
      !I_CURRCODE type S_CURRCODE
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods GET_CARRID
    returning
      value(RESULT) type S_CARR_ID
    raising
      CX_OS_OBJECT_NOT_FOUND .
  methods DISPLAY_ATTRIBUTES .
  class CL_OS_SYSTEM definition load .
protected section.
*"* protected components of class CL_BC401_POJD_CARRIER
*"* do not include other source files here!!!

  data CARRID type S_CARR_ID .
  data CURRCODE type S_CURRCODE .
  data CARRNAME type S_CARRNAME .
  data URL type S_CARRURL .
private section.
*"* private components of class CL_BC401_POJD_CARRIER
*"* do not include other source files here!!!
  class CL_OS_SYSTEM definition load .
ENDCLASS.



CLASS CL_BC401_POJD_CARRIER IMPLEMENTATION.


METHOD display_attributes .

  WRITE: /
    'Daten der Fluggesellschaft'(doa),
    me->carrid,
    icon_ws_plane AS ICON,
    me->carrname,
    me->currcode,
    me->url.

ENDMETHOD.


method GET_CARRID .
***BUILD 020501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CARRID
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CARRID.

           " GET_CARRID
endmethod.


method GET_CARRNAME .
***BUILD 020501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CARRNAME
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CARRNAME.

           " GET_CARRNAME
endmethod.


method GET_CURRCODE .
***BUILD 020501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute CURRCODE
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = CURRCODE.

           " GET_CURRCODE
endmethod.


method GET_URL .
***BUILD 020501
     " returning RESULT
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Get Attribute URL
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, result is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
************************************************************************

* * Inform class agent and handle exceptions
  state_read_access.

  result = URL.

           " GET_URL
endmethod.


method IF_OS_STATE~GET .
***BUILD 020501
     " returning result type ref to object
************************************************************************
* Purpose        : Get state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  create object STATE_OBJECT.
  call method STATE_OBJECT->SET_STATE_FROM_OBJECT( ME ).
  result = STATE_OBJECT.

endmethod.


method IF_OS_STATE~HANDLE_EXCEPTION .
***BUILD 020501
     " importing I_EXCEPTION type ref to IF_OS_EXCEPTION_INFO optional
     " importing I_EX_OS type ref to CX_OS_OBJECT_NOT_FOUND optional
************************************************************************
* Purpose        : Handles exceptions during attribute access.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : If an exception is raised during attribut access,
*                  this method is called and the exception is passed
*                  as a paramater. The default is to raise the exception
*                  again, so that the caller can handle the exception.
*                  But it is also possible to handle the exception
*                  here in the callee.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
* - 2000-08-02   : (SB)  OO Exceptions
************************************************************************
* Modify if you like
************************************************************************

  if i_ex_os is not initial.
    raise exception i_ex_os.
  endif.

endmethod.


method IF_OS_STATE~INIT .
***BUILD 020501
************************************************************************
* Purpose        : Initialisation of the transient state partition.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Transient state is initial.
*
* OO Exceptions  : -
*
* Implementation : Caution!: Avoid Throwing ACCESS Events.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

endmethod.


method IF_OS_STATE~INVALIDATE .
***BUILD 020501
************************************************************************
* Purpose        : Do something before all persistent attributes are
*                  cleared.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : Whatever you like to do.
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* Modify if you like
************************************************************************

endmethod.


method IF_OS_STATE~SET .
***BUILD 020501
     " importing I_STATE type ref to object
************************************************************************
* Purpose        : Set state.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : -
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-07   : (BGR) Initial Version 2.0
************************************************************************
* GENERATED: Do not modify
************************************************************************

  data: STATE_OBJECT type ref to CL_OS_STATE.

  STATE_OBJECT ?= I_STATE.
  call method STATE_OBJECT->SET_OBJECT_FROM_STATE( ME ).

endmethod.


method SET_CARRNAME .
***BUILD 020501
     " importing I_CARRNAME
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CARRNAME
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CARRNAME <> CARRNAME ).

    CARRNAME = I_CARRNAME.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CARRNAME <> CARRNAME )

           " GET_CARRNAME
endmethod.


method SET_CURRCODE .
***BUILD 020501
     " importing I_CURRCODE
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute CURRCODE
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_CURRCODE <> CURRCODE ).

    CURRCODE = I_CURRCODE.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_CURRCODE <> CURRCODE )

           " GET_CURRCODE
endmethod.


method SET_URL .
***BUILD 020501
     " importing I_URL
     " raising CX_OS_OBJECT_NOT_FOUND
************************************************************************
* Purpose        : Set attribute URL
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : The object state is loaded, attribute is set
*
* OO Exceptions  : CX_OS_OBJECT_NOT_FOUND
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 2000-03-14   : (BGR) Version 2.0
* - 2000-07-28   : (SB)  OO Exceptions
* - 2000-10-04   : (SB)  Namespaces
************************************************************************

* * Inform class agent and handle exceptions
  state_write_access.

  if ( I_URL <> URL ).

    URL = I_URL.

*   * Inform class agent and handle exceptions
    state_changed.

  endif. "( I_URL <> URL )

           " GET_URL
endmethod.
ENDCLASS.
