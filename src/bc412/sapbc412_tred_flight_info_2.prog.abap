*&---------------------------------------------------------------------*
*& Report  SAPBC412_TRED_FLIGHT_INFO_2                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& BC412: Demo 2 of a flight info tree in combination with several     *
*&        subscreen windows displaying detail data of the node selected*
*&        in the tree.                                                 *
*&                                                                     *
*&        The screen consists of 2 areas:                              *
*&          - on the left side the flight info tree is displayed       *
*&          - on the right side a detail screeen is displayed          *
*&                                                                     *
*&        The flight info tree covers data from tables SCARR, SPFLI,   *
*&        SFLIGHT and SBOOK (defined and implemented in GLOBAL         *
*&        CLASS cl_bc412_flight_info_tree1).                           *
*&                                                                     *
*&        The used docking container is re-linked to the corresponding *
*&        detail screen.                                               *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_tred_flight_info_2.
* global types (type pols)
TYPE-POOLS: cntl.

TABLES: scarr, spfli, sflight, sbook, scustom, stravelag.

* Screen fields
DATA:   screen_nr                TYPE sy-dynnr VALUE '0101',
        fcode                    TYPE sy-ucomm,
        copy_fcode               LIKE fcode,
        gt005t_countryfr         TYPE t005t-landx,
        gt005t_countryto         TYPE t005t-landx,
        gsairport_name_from      LIKE sairport-name,
        gsairport_name_to        TYPE sairport-name,
        gsairport_time_zone_from TYPE sairport-time_zone,
        gsairport_time_zone_to   TYPE sairport-time_zone,
        gttzzt_descript_from     TYPE ttzzt-descript,
        gttzzt_descript_to       TYPE ttzzt-descript,
        counter_activity         LIKE screen-active,
        agency_activity          LIKE screen-active,
* object references
        my_flight_tree TYPE REF TO cl_bc412_flight_info_tree1,
        my_container   TYPE REF TO cl_gui_docking_container.
* constants
CONSTANTS: c_on  LIKE screen-active VALUE '1',
           c_off LIKE screen-active VALUE '0'.

* Screen objects: tabstrip
CONTROLS:
        spfli_tabstrip   TYPE TABSTRIP," tabstrip on screen 0103
        booking_tabstrip TYPE TABSTRIP." tabstrip on screen 0105

* local event handler class
*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_node_double_click FOR EVENT node_double_click
                           OF cl_bc412_flight_info_tree1
                IMPORTING
                  e_carrid
                  e_connid
                  e_fldate
                  e_bookid
                  e_level.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD: on_node_double_click.
    CASE e_level.
      WHEN cl_bc412_flight_info_tree1=>c_level_1. " SCARR   node

*       get scarr details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_scarr_details
          EXPORTING
            i_carrid = e_carrid
          IMPORTING
            e_scarr  = scarr
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.

*       set corresponding subscreen number
        SET SCREEN '0102'.

*       link container to new screen
        CALL METHOD my_container->link
          EXPORTING
            repid = sy-cprog
            dynnr = '0102'
          EXCEPTIONS
            OTHERS = 1.

        IF sy-subrc NE 0.
          MESSAGE a010(bc412).
        ENDIF.

      WHEN cl_bc412_flight_info_tree1=>c_level_2. " SPFLI   node

*       get spfli details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_spfli_details
          EXPORTING
            i_carrid = e_carrid
            i_connid = e_connid
          IMPORTING
            e_spfli  = spfli
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.

*       get scarr details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_scarr_details
          EXPORTING
            i_carrid = e_carrid
          IMPORTING
            e_scarr  = scarr
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.


*       set corresponding subscreen number
        SET SCREEN '0103'.

*       link container to new screen
        CALL METHOD my_container->link
          EXPORTING
            repid = sy-cprog
            dynnr = '0103'
          EXCEPTIONS
            OTHERS = 1.

        IF sy-subrc NE 0.
          MESSAGE a010(bc412).
        ENDIF.


      WHEN cl_bc412_flight_info_tree1=>c_level_3. " SFLIGHT node
*       get spfli details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_sflight_details
          EXPORTING
            i_carrid = e_carrid
            i_connid = e_connid
            i_fldate = e_fldate
          IMPORTING
            e_sflight  = sflight
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.

*       get scarr details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_scarr_details
          EXPORTING
            i_carrid = e_carrid
          IMPORTING
            e_scarr  = scarr
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.

*       set corresponding subscreen number
        SET SCREEN '0104'.

*       link container to new screen
        CALL METHOD my_container->link
          EXPORTING
            repid = sy-cprog
            dynnr = '0104'
          EXCEPTIONS
            OTHERS = 1.

        IF sy-subrc NE 0.
          MESSAGE a010(bc412).
        ENDIF.

      WHEN cl_bc412_flight_info_tree1=>c_level_4. " SBOOK   node

*       get sbook details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_sbook_details
          EXPORTING
            i_carrid = e_carrid
            i_connid = e_connid
            i_fldate = e_fldate
            i_bookid = e_bookid
          IMPORTING
            e_sbook  = sbook
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.

*       get scustom details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_scustom_details
          EXPORTING
            i_id      = sbook-customid
          IMPORTING
            e_scustom = scustom
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.

*       get scarr details (flight_info_tree cashes data)
        CALL METHOD my_flight_tree->get_scarr_details
          EXPORTING
            i_carrid = e_carrid
          IMPORTING
            e_scarr  = scarr
          EXCEPTIONS
            no_data_found = 1.

        IF sy-subrc NE 0.
*         should not occur
        ENDIF.


*       set corresponding subscreen number
        SET SCREEN '0105'.

*       link container to new screen
        CALL METHOD my_container->link
          EXPORTING
            repid = sy-cprog
            dynnr = '0105'
          EXCEPTIONS
            OTHERS = 1.

        IF sy-subrc NE 0.
          MESSAGE a010(bc412).
        ENDIF.


    ENDCASE.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

* call control parent screen
  CALL SCREEN 101.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'SCREEN_0100_NORMAL'.
  SET TITLEBAR 'SCREEN_0100_NORMAL'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' '.
*       - BACK
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE copy_fcode.
    WHEN 'BACK'.
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type 'E'.
*       - CANCEL
*       - EXIT
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE fcode.
    WHEN 'CANCEL'.                     "Abbrechen
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.                       "Beenden
      PERFORM free_control_ressources.
      LEAVE PROGRAM.
    WHEN OTHERS.

  ENDCASE.
ENDMODULE.                             " EXIT_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  DEFAULT_FCODE_PROCESSING  INPUT
*&---------------------------------------------------------------------*
*       1. filter control events --> control_dispatch
*       2. fcode --> copy_fcode
*----------------------------------------------------------------------*
MODULE default_fcode_processing INPUT.
*
* -> control_dispatch
  CALL METHOD cl_gui_cfw=>dispatch.

  copy_fcode = fcode.
  CLEAR fcode.

ENDMODULE.                             " DEFAULT_FCODE_PROCESSING  INPUT

*&---------------------------------------------------------------------*
*&      Module  START_CONTROL_HANDLING  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE start_control_handling OUTPUT.
  IF my_container IS INITIAL.
*   create container object
    CREATE OBJECT my_container
      EXPORTING
        side       = cl_gui_docking_container=>dock_at_left
        extension  = 400
      EXCEPTIONS
        others = 1.
    IF sy-subrc NE 0.
      MESSAGE a100(bc412) WITH text-010.
    ENDIF.

*   create tree_application object
    CREATE OBJECT my_flight_tree
      EXPORTING
        i_container         = my_container
        i_root_node_text    = text-004
        i_flight_node_text1 = text-007
        i_flight_node_text2 = text-008
        i_node_double_click = cl_bc412_flight_info_tree1=>c_true
        i_appl_event_ndc    = cl_bc412_flight_info_tree1=>c_true
        i_level_no          = cl_bc412_flight_info_tree1=>c_level_4
      EXCEPTIONS
        others = 1.
    IF sy-subrc NE 0.
      MESSAGE a100(bc412) WITH text-011.
    ENDIF.

*   event handling:
*   1. only ABAP object part (register event handler) required,
*   2. the CFW handling (event registration using EVENT_IDs) is
*      performed by the tree class lcl_flight_info_tree_1
    SET HANDLER lcl_event_handler=>on_node_double_click
                FOR my_flight_tree.

  ENDIF.                               " IF my_container IS INITIAL
ENDMODULE.                             " START_CONTROL_HANDLING  OUTPUT

*&---------------------------------------------------------------------*
*&      Form  FREE_CONTROL_RESSOURCES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD my_flight_tree->free.
  CALL METHOD my_container->free.
  FREE: my_flight_tree, my_container.
ENDFORM.                               " FREE_CONTROL_RESSOURCES

*&---------------------------------------------------------------------*
*&      Module  GET_TEXT_FIELD_DATA  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_text_field_data OUTPUT.
  CASE sy-dynnr.
    WHEN 1031.
      SELECT SINGLE landx FROM t005t INTO gt005t_countryfr
             WHERE  spras  = sy-langu
             AND    land1  = spfli-countryfr.
      SELECT SINGLE name time_zone FROM  sairport
             INTO (gsairport_name_from, gsairport_time_zone_from)
             WHERE  id  = spfli-airpfrom.
      SELECT SINGLE descript FROM  ttzzt INTO gttzzt_descript_from
             WHERE  langu  = sy-langu
             AND    tzone  = gsairport_time_zone_from.
    WHEN 1032.
      SELECT SINGLE landx FROM t005t INTO gt005t_countryto
             WHERE  spras  = sy-langu
             AND    land1  = spfli-countryto.
      SELECT SINGLE name time_zone FROM  sairport
             INTO (gsairport_name_to, gsairport_time_zone_to)
             WHERE  id  = spfli-airpto.
      SELECT SINGLE descript FROM  ttzzt INTO gttzzt_descript_to
             WHERE  langu  = sy-langu
             AND    tzone  = gsairport_time_zone_to.
  ENDCASE.
ENDMODULE.                             " GET_TEXT_FIELD_DATA  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  GET_STRAVELAGINFO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_stravelaginfo OUTPUT.
  CLEAR: stravelag.
  SELECT SINGLE name FROM  stravelag INTO stravelag-name
         WHERE  agencynum  = sbook-agencynum.
ENDMODULE.                             " GET_STRAVELAGINFO  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  MODIFY_SCREEN  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE modify_screen OUTPUT.
  IF sbook-counter IS INITIAL.
    counter_activity = c_off.
    agency_activity  = c_on.
  ELSE.
    counter_activity = c_on.
    agency_activity  = c_off.
  ENDIF.

  LOOP AT SCREEN.
    IF screen-group1 = 'COU'.
      screen-active = counter_activity.
      MODIFY SCREEN.
    ENDIF.
    IF screen-group1 = 'AGC'.
      screen-active = agency_activity.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


ENDMODULE.                             " MODIFY_SCREEN  OUTPUT
