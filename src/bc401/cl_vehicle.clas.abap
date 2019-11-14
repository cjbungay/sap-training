class CL_VEHICLE definition
  public
  create public .

*"* public components of class CL_VEHICLE
*"* do not include other source files here!!!
public section.

  events VEHICLE_CREATED .

  methods CONSTRUCTOR
    importing
      !IM_MAKE type STRING .
  methods DISPLAY_ATTRIBUTES .
  methods GET_AVERAGE_FUEL
    importing
      !IM_DISTANCE type S_DISTANCE
      !IM_FUEL type S_CAPACITY
    returning
      value(RE_AVGFUEL) type S_CONSUM .
  class-methods GET_COUNT
    exporting
      !RE_COUNT type I .
  methods GET_MAKE
    exporting
      !EX_MAKE type STRING .
  methods SET_MAKE
    importing
      !IM_MAKE type STRING .
protected section.
*"* protected components of class CL_VEHICLE
*"* do not include other source files here!!!
private section.
*"* private components of class CL_VEHICLE
*"* do not include other source files here!!!

  data MAKE type STRING .
  class-data N_O_VEHICLES type I .

  methods INIT_MAKE .
ENDCLASS.



CLASS CL_VEHICLE IMPLEMENTATION.


method CONSTRUCTOR.

    make = im_make.
    ADD 1 TO n_o_vehicles.
    RAISE EVENT vehicle_created.

endmethod.


method DISPLAY_ATTRIBUTES.

    WRITE: make.

endmethod.


method GET_AVERAGE_FUEL.

    re_avgfuel = im_distance / im_fuel.

endmethod.


method GET_COUNT.

    re_count = n_o_vehicles.

endmethod.


method GET_MAKE.

    ex_make = make.

endmethod.


method INIT_MAKE.

    make = 'default make'.

endmethod.


method SET_MAKE.

    IF im_make IS INITIAL.
      init_make( ).   " me->init_make( ). also possible
    ELSE.
      make = im_make.
    ENDIF.

endmethod.
ENDCLASS.
