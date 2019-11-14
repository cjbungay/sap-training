class CL_HOTEL definition
  public
  inheriting from CL_HOUSE
  create public .

*"* public components of class CL_HOTEL
*"* do not include other source files here!!!
public section.

  interfaces IF_PARTNERS .

  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING
      !IM_BEDS type I .
  class-methods DISPLAY_N_O_HOTELS .

  methods DISPLAY_ATTRIBUTES
    redefinition .
protected section.
*"* protected components of class CL_HOTEL
*"* do not include other source files here!!!
private section.
*"* private components of class CL_HOTEL
*"* do not include other source files here!!!

  data MAX_BEDS type I .
  class-data N_O_HOTELS type I .
ENDCLASS.



CLASS CL_HOTEL IMPLEMENTATION.


METHOD constructor .
  super->constructor( im_name ).
  max_beds = im_beds.
  ADD 1 TO n_o_hotels.
  RAISE EVENT if_partners~partner_created.
ENDMETHOD.


METHOD display_attributes .
  SKIP 2.
  WRITE: / icon_hotel AS ICON, name,
         / 'We have'(hav), max_beds,
           'beds available.'(avb).

ENDMETHOD.


METHOD display_n_o_hotels .
  WRITE: / n_o_hotels, ' Zahl der Hotels '.
ENDMETHOD.


METHOD if_partners~display_partner .
  display_attributes( ).
ENDMETHOD.
ENDCLASS.
