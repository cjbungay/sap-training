class CL_AIRPLANE definition
  public
  create public .

*"* public components of class CL_AIRPLANE
*"* do not include other source files here!!!
public section.
  type-pools ICON .

  constants POS_1 type I value 30. "#EC NOTEXT

  events AIRPLANE_CREATED .

  methods CONSTRUCTOR
    importing
      !IM_NAME type STRING
      !IM_PLANETYPE type SAPLANE-PLANETYPE .
  methods DISPLAY_ATTRIBUTES .
  class-methods CLASS_CONSTRUCTOR .
  class-methods DISPLAY_N_O_AIRPLANES .
  class-methods GET_PLANETYPES
    returning
      value(RE_PLANETYPES) type TY_PLANETYPES .
protected section.
*"* protected components of class CL_AIRPLANE
*"* do not include other source files here!!!
private section.
*"* private components of class CL_AIRPLANE
*"* do not include other source files here!!!

  data NAME type STRING .
  data PLANETYPE type SAPLANE-PLANETYPE .
  class-data N_O_AIRPLANES type I .
  class-data LIST_OF_PLANETYPES type TY_PLANETYPES .

  methods GET_TECHNICAL_ATTRIBUTES
    importing
      !IM_TYPE type SAPLANE-PLANETYPE
    exporting
      !EX_TANKCAP type S_CAPACITY
      !EX_WEIGHT type S_PLAN_WEI .
ENDCLASS.



CLASS CL_AIRPLANE IMPLEMENTATION.


method CLASS_CONSTRUCTOR.

    SELECT * FROM saplane INTO TABLE list_of_planetypes.

endmethod.


method CONSTRUCTOR.

    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
    RAISE EVENT airplane_created.

endmethod.


method DISPLAY_ATTRIBUTES.

    DATA: weight TYPE saplane-weight,
          cap TYPE saplane-tankcap.
    WRITE: / icon_ws_plane AS ICON,
           / 'Name of Airplane:'(001), AT pos_1 name,
           / 'Type of airplane: '(002), AT pos_1 planetype.
    get_technical_attributes( EXPORTING im_type = planetype
                              IMPORTING ex_weight = weight
                                        ex_tankcap = cap ).
    WRITE: / 'Weight:'(003), weight,
             'Tankkap:'(004), cap.

endmethod.


method DISPLAY_N_O_AIRPLANES.

    WRITE: /, / 'Number of airplanes: '(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.

endmethod.


method GET_PLANETYPES.

    re_planetypes = list_of_planetypes.

endmethod.


method GET_TECHNICAL_ATTRIBUTES.

    DATA: wa TYPE saplane.

    READ TABLE list_of_planetypes INTO wa
               WITH TABLE KEY planetype = im_type
                          TRANSPORTING weight tankcap.
    ex_weight = wa-weight.
    ex_tankcap = wa-tankcap.

endmethod.
ENDCLASS.
