*&---------------------------------------------------------------------*
*&  Include           SAPBC401_AIRS_F                                 *
*&---------------------------------------------------------------------*
*------------------------------------------------------------------*
*       CLASS lcl_airplane DEFINITION                              *
*------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION.
    "--------------------------------
    CONSTANTS: pos_1 TYPE i VALUE 30.

    METHODS: constructor IMPORTING
                   im_name      TYPE string
                   im_planetype TYPE saplane-planetype,
             display_attributes.

    CLASS-METHODS: display_n_o_airplanes.
    CLASS-METHODS: class_constructor.


  PRIVATE SECTION.
    "----------------------------------
    CLASS-METHODS: get_technical_attributes
                 IMPORTING im_type     TYPE saplane-planetype
                 EXPORTING ex_weight   TYPE s_plan_wei
                           ex_tankcap  TYPE s_capacity
                 EXCEPTIONS wrong_planetype.

    DATA: name      TYPE string,
          planetype TYPE saplane-planetype.

    CLASS-DATA: list_of_planetypes TYPE ty_planetypes.
    CLASS-DATA: n_o_airplanes TYPE i.


ENDCLASS.                    "lcl_airplane DEFINITION

*------------------------------------------------------------------*
*       CLASS lcl_airplane IMPLEMENTATION                          *
*------------------------------------------------------------------*
CLASS lcl_airplane IMPLEMENTATION.
  METHOD class_constructor.
    SELECT * FROM saplane INTO TABLE list_of_planetypes.
  ENDMETHOD.                    "class_constructor

  METHOD constructor.
    name          = im_name.
    planetype     = im_planetype.
    n_o_airplanes = n_o_airplanes + 1.
  ENDMETHOD.                    "constructor

  METHOD display_attributes.
    DATA: weight TYPE saplane-weight,
          cap TYPE saplane-tankcap.

    get_technical_attributes( EXPORTING im_type = planetype
                              IMPORTING ex_weight = weight
                                        ex_tankcap = cap
                              EXCEPTIONS wrong_planetype = 4 ).

    WRITE: / icon_ws_plane AS ICON,
            / 'Name of airplane'(001), AT pos_1 name,
            / 'Typ of airplane:'(002), AT pos_1 planetype.
    IF sy-subrc <> 0.
      WRITE: / icon_failure AS ICON, 'WRONG_PLANETYPE'.
    ELSE  .
      WRITE: / 'weight of airplane'(003),
                  AT pos_1 weight LEFT-JUSTIFIED,
             / 'tankcapacity of airplane '(004),
                  AT pos_1 cap LEFT-JUSTIFIED.
    ENDIF.

  ENDMETHOD.                    "display_attributes

  METHOD display_n_o_airplanes.
    WRITE: /, / 'Number of airplanes: '(ca1),
           AT pos_1 n_o_airplanes LEFT-JUSTIFIED, /.
  ENDMETHOD.                    "display_n_o_airplanes

  METHOD get_technical_attributes.
    DATA: wa TYPE saplane.

    READ TABLE list_of_planetypes INTO wa
               WITH TABLE KEY planetype = im_type
                          TRANSPORTING weight tankcap.

    IF sy-subrc = 0.
      ex_weight = wa-weight.
      ex_tankcap = wa-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.

  ENDMETHOD.                    "get_technical_attributes

ENDCLASS.                    "lcl_airplane IMPLEMENTATION
