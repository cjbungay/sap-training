*&---------------------------------------------------------------------*
*&  Include           BC401_EXCT_HANDLE_EXCEP_C01                      *
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       CLASS lcl_plane DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_plane DEFINITION.

  PUBLIC SECTION.
    DATA:
      name TYPE string            READ-ONLY,
      type TYPE saplane-planetype READ-ONLY.


    METHODS constructor
            IMPORTING
              im_name TYPE string DEFAULT 'no_name_yet'
              im_type TYPE saplane-planetype.

    METHODS get_name
            RETURNING value(re_name) TYPE string.

    METHODS get_attributes
            EXPORTING
              ex_name     TYPE string
              ex_wa_plane TYPE saplane.

ENDCLASS.                    "lcl_plane DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_plane IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_plane IMPLEMENTATION.

  METHOD constructor.
    me->name = im_name.
    me->type = im_type.
  ENDMETHOD.                    "lcl_plane

  METHOD get_name.
    re_name = me->name.
  ENDMETHOD.                    "get_name

  METHOD get_attributes.

    SELECT SINGLE * FROM saplane
                    INTO ex_wa_plane
                    WHERE planetype = me->type.

  ENDMETHOD.                    "lcl_plane

ENDCLASS.                    "lcl_plane IMPLEMENTATION



*---------------------------------------------------------------------*
*       CLASS lcl_carrier DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_carrier DEFINITION.

  PUBLIC SECTION.
    METHODS constructor
            IMPORTING
              im_name TYPE string DEFAULT 'no_name_yet'.

    METHODS add_airplane
            IMPORTING
              im_ref_plane TYPE REF TO lcl_plane.

    METHODS display_attributes.

  PRIVATE SECTION.
    TYPE-POOLS icon.

    DATA:
      name TYPE string,
      it_ref_planes TYPE SORTED TABLE OF REF TO lcl_plane
                    WITH UNIQUE KEY table_line.

ENDCLASS.                    "lcl_carrier DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_carrier IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_carrier IMPLEMENTATION.

  METHOD constructor.
    me->name = im_name.
  ENDMETHOD.                    "constructor

  METHOD add_airplane.
    DATA:
      l_ref_plane TYPE REF TO lcl_plane,
      l_flag_name_used.

*   check whether an airplane with such a name has already been added:
    LOOP AT me->it_ref_planes TRANSPORTING NO FIELDS
        WHERE table_line->name = im_ref_plane->get_name( ).
    ENDLOOP.
    IF sy-subrc = 0.
      l_flag_name_used = 'X'.
    ENDIF.

*   add airplane to list:
    IF l_flag_name_used = space.
      INSERT im_ref_plane INTO TABLE it_ref_planes.
    ENDIF.

  ENDMETHOD.                    "add_airplane

  METHOD display_attributes.
    DATA:
      l_ref_plane TYPE REF TO lcl_plane,
      l_name TYPE string,
      l_wa_plane TYPE saplane.

    WRITE: / 'Attributes of carrier'(car) COLOR COL_HEADING,
              me->name COLOR COL_GROUP.
    SKIP.
    WRITE: / 'Attributes of our airplanes:'(air).
    ULINE.

    LOOP AT it_ref_planes INTO l_ref_plane.

      WRITE / icon_ws_plane AS ICON.

      l_name = l_ref_plane->get_name( ).
      WRITE l_name.

      CLEAR l_wa_plane.
      CALL METHOD l_ref_plane->get_attributes
        IMPORTING
          ex_wa_plane = l_wa_plane.
      WRITE: 15 l_wa_plane-planetype,
                l_wa_plane-producer,
                l_wa_plane-seatsmax_b.

    ENDLOOP.

  ENDMETHOD.                    "display_attributes

ENDCLASS.                    "lcl_carrier IMPLEMENTATION
