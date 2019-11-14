class CL_BC401_BOOD_ID definition
  public
  create public .

*"* public components of class CL_BC401_BOOD_ID
*"* do not include other source files here!!!
public section.

  data ID type GUID_32 .

  methods CONSTRUCTOR .
  methods DISPLAY_ATTRIBUTES .
protected section.
*"* protected components of class CL_D620AW_BOOD_ID
*"* do not include other source files here!!!
private section.
*"* private components of class CL_D620AW_BOOD_ID
*"* do not include other source files here!!!
ENDCLASS.



CLASS CL_BC401_BOOD_ID IMPLEMENTATION.


METHOD CONSTRUCTOR .

  CALL FUNCTION 'GUID_CREATE'
   IMPORTING
*     EV_GUID_16       =
*     EV_GUID_22       =
     ev_guid_32       = me->id
            .


ENDMETHOD.                    "CONSTRUCTOR


METHOD DISPLAY_ATTRIBUTES .
  DATA l_ref_descr TYPE REF TO cl_abap_objectdescr.

* RTTI to get class name:
  l_ref_descr ?= cl_abap_objectdescr=>describe_by_object_ref( me ).

* output (first parameter only for long text!):
  MESSAGE i120 WITH l_ref_descr->absolute_name me->id.

ENDMETHOD.                    "DISPLAY_ATTRIBUTES
ENDCLASS.
