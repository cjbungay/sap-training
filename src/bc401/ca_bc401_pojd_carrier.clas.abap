class CA_BC401_POJD_CARRIER definition
  public
  inheriting from CB_BC401_POJD_CARRIER
  final
  create private .

*"* public components of class CA_BC401_POJD_CARRIER
*"* do not include other source files here!!!
public section.

  class-data AGENT type ref to CA_BC401_POJD_CARRIER read-only .

  class-methods CLASS_CONSTRUCTOR .
protected section.
*"* protected components of class CA_BC401_POJD_CARRIER
*"* do not include other source files here!!!
private section.
*"* private components of class CA_BC401_POJD_CARRIER
*"* do not include other source files here!!!
ENDCLASS.



CLASS CA_BC401_POJD_CARRIER IMPLEMENTATION.


method CLASS_CONSTRUCTOR .
***BUILD 020501
************************************************************************
* Purpose        : Initialize the 'class'.
*
* Version        : 2.0
*
* Precondition   : -
*
* Postcondition  : Singleton is created.
*
* OO Exceptions  : -
*
* Implementation : -
*
************************************************************************
* Changelog:
* - 1999-09-20   : (OS) Initial Version
* - 2000-03-06   : (BGR) 2.0 modified REGISTER_CLASS_AGENT
************************************************************************
* GENERATED: Do not modify
************************************************************************

  create object AGENT.

  call method AGENT->REGISTER_CLASS_AGENT
    exporting
      I_CLASS_NAME          = 'CL_BC401_POJD_CARRIER'
      I_CLASS_AGENT_NAME    = 'CA_BC401_POJD_CARRIER'
      I_CLASS_GUID          = '6519583F3393F95FE10000000A114627'
      I_CLASS_AGENT_GUID    = '6719583F3393F95FE10000000A114627'
      I_AGENT               = AGENT
      I_STORAGE_LOCATION    = 'SCARR'
      I_CLASS_AGENT_VERSION = '2.0'.

           "CLASS_CONSTRUCTOR
endmethod.
ENDCLASS.
