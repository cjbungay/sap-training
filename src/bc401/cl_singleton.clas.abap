class CL_SINGLETON definition
  public
  final
  create private

  global friends CL_AGENCY .

*"* public components of class CL_SINGLETON
*"* do not include other source files here!!!
public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_SINGLETON
    returning
      value(EX_SINGLETON) type ref to CL_SINGLETON .
protected section.
*"* protected components of class CL_SINGLETON
*"* do not include other source files here!!!
private section.
*"* private components of class CL_SINGLETON
*"* do not include other source files here!!!

  class-data R_SINGLETON type ref to CL_SINGLETON .
  class-data CONNECTION_LIST type TY_CONNECTIONS .
ENDCLASS.



CLASS CL_SINGLETON IMPLEMENTATION.


METHOD class_constructor .
  CREATE OBJECT r_singleton.
  SELECT * FROM spfli INTO TABLE connection_list.
ENDMETHOD.


METHOD get_singleton .
  ex_singleton = r_singleton.
ENDMETHOD.
ENDCLASS.
