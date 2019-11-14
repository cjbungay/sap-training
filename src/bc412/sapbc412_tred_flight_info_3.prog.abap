*&---------------------------------------------------------------------*
*& Report  SAPBC412_TRED_FLIGHT_INFO_3                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& BC412: Demo 3 of a flight info tree in combination with alv grid    *
*&        control.                                                     *
*&        The flight info tree displays data of tables SCARR,          *
*&        SPFLI and SFLIGHT. You can select a node in the tree. All    *
*&        corresponding booking data is displayed in the alv grid      *
*&        control on the right side of the window.                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_tred_flight_info_3.
* global types (type pools)
TYPE-POOLS: cntl.

* Screen fields
DATA:   fcode      TYPE sy-ucomm,
        copy_fcode LIKE fcode,

* object references
        my_tree_container TYPE REF TO cl_gui_docking_container,
        my_flight_tree    TYPE REF TO cl_bc412_flight_info_tree1,

        my_alv_container  TYPE REF TO cl_gui_custom_container,
        my_alv            TYPE REF TO cl_gui_alv_grid.

* local class containing event handler method
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
        IMPORTING e_carrid e_connid e_fldate e_bookid e_level.

  PRIVATE SECTION.
    TYPES: BEGIN OF node_selected_type," line type
             carrid    TYPE s_carr_id,
             connid    TYPE s_conn_id,
             fldate    TYPE s_date,
           END OF node_selected_type.

* private constants
    CONSTANTS: c_empty VALUE ' '.

* private data
*   - it_node_selected: stores keys of nodes that have been selected
*                       before --> corresponding data already stored
*                                  in it_bookings
*   - it_bookings:      stores bookings (local program cash)
*                       reduced number of data base access
   CLASS-DATA: it_node_selected TYPE HASHED TABLE OF node_selected_type
                      WITH UNIQUE KEY carrid connid fldate,

                it_bookings TYPE SORTED TABLE OF sbook
                      WITH NON-UNIQUE KEY carrid connid fldate,

                it_alv_data      TYPE STANDARD TABLE OF sbook,
* auxiliary
                first_time VALUE 'X'.
ENDCLASS.


*---------------------------------------------------------------------*
*       CLASS lcl_event_handler  IMLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_node_double_click.
* interface-------
* --> e_carrid
* --> e_connid
* --> e_fldate
* --> e_bookid
* --> e_customid

* local data
    DATA: l_connid         TYPE s_conn_id,
          l_fldate         TYPE s_date,
          wa_alv_data      LIKE LINE OF it_alv_data,
          wa_node_selected LIKE LINE OF it_node_selected,
          wa_bookings      LIKE LINE OF it_bookings.
* clear alv data table
    CLEAR it_alv_data.

* 1. find out whether data needed for selected node has been stored
*    before. use entries in it_node_selected to find out
*    note: it is not sufficent to test the current key
*          all keys relating to nodes of hierarchy levels above the
*          level of the current key have to be tested too!
*          (example: current key LH 0400 20000101 and node with
*           key LH 0400 has been selected before)

* check for carrid only
    READ TABLE it_node_selected TRANSPORTING NO FIELDS
       WITH TABLE KEY carrid = e_carrid
                      connid = l_connid
                      fldate = l_fldate.

    IF sy-subrc NE 0. " carrier node not selected before
*   find out if selected node was a carrier node or not
      IF e_connid IS INITIAL. " current selected node is carrier node
*     store node key in it_node_selected
*     read data from data base table --> store in it_bookings and
*                                        send data to alv
        wa_node_selected-carrid = e_carrid.
        wa_node_selected-connid = e_connid.
        wa_node_selected-fldate = e_fldate.
        INSERT wa_node_selected INTO TABLE it_node_selected.

        SELECT * FROM sbook INTO TABLE it_alv_data
          WHERE carrid = e_carrid.

        LOOP AT it_alv_data INTO wa_alv_data.
          wa_bookings = wa_alv_data.
          INSERT wa_bookings INTO TABLE it_bookings.
        ENDLOOP.

      ELSE.                   " current selected node is connection
                                       " or sflight
*     check for connection: carrid connid only
        READ TABLE it_node_selected TRANSPORTING NO FIELDS
          WITH TABLE KEY carrid = e_carrid
                         connid = e_connid
                         fldate = l_fldate.

        IF sy-subrc NE 0. " connection node not selected before
*       find out if selected node was a connection or not
          IF e_fldate IS INITIAL.      " selected node was a connection
*         store node key in it_node_selected
*         read data from data base table --> store in it_bookings
*                                            + send data to alv
            wa_node_selected-carrid = e_carrid.
            wa_node_selected-connid = e_connid.
            wa_node_selected-fldate = e_fldate.
            INSERT wa_node_selected INTO TABLE it_node_selected.

            SELECT * FROM sbook INTO TABLE it_alv_data
              WHERE carrid = e_carrid
              AND   connid = e_connid.

            LOOP AT it_alv_data INTO wa_alv_data.
              wa_bookings = wa_alv_data.
              INSERT wa_bookings INTO TABLE it_bookings.
            ENDLOOP.

          ELSE.                        " selected node was a flight
*         check for flight: full key
            READ TABLE it_node_selected TRANSPORTING NO FIELDS
              WITH TABLE KEY carrid = e_carrid
                             connid = e_connid
                             fldate = e_fldate.

          IF sy-subrc NE 0.            " flight node not selected before
*             store node key in it_node_selected
*             read data from data base table --> store in it_bookings
*                                                + send data to alv

              wa_node_selected-carrid = e_carrid.
              wa_node_selected-connid = e_connid.
              wa_node_selected-fldate = e_fldate.
              INSERT wa_node_selected INTO TABLE it_node_selected.

              SELECT * FROM sbook INTO TABLE it_alv_data
                WHERE carrid = e_carrid
                AND   connid = e_connid
                AND   fldate = e_fldate.

              LOOP AT it_alv_data INTO wa_alv_data.
                wa_bookings = wa_alv_data.
                INSERT wa_bookings INTO TABLE it_bookings.
              ENDLOOP.

            ELSE.                      " flight node selected before
*             read in it_bookings with current key
*             --> transfer target data to alv
              LOOP AT it_bookings INTO wa_bookings
                WHERE carrid = e_carrid
                AND   connid = e_connid
                AND   fldate = e_fldate.

                wa_alv_data = wa_bookings.
                INSERT wa_alv_data INTO TABLE it_alv_data.

              ENDLOOP.
            ENDIF.

          ENDIF.
        ELSE.             " connection node previously selected
*       read in it_bookings with current key
*       --> transfer target data to alv
          IF e_fldate IS INITIAL.    " data for connection node required
            LOOP AT it_bookings INTO wa_bookings
              WHERE carrid = e_carrid
              AND   connid = e_connid.

              wa_alv_data = wa_bookings.
              INSERT wa_alv_data INTO TABLE it_alv_data.

            ENDLOOP.
          ELSE.                        " data for flight node required

            LOOP AT it_bookings INTO wa_bookings
              WHERE carrid = e_carrid
              AND   connid = e_connid
              AND   fldate = e_fldate.

              wa_alv_data = wa_bookings.
              INSERT wa_alv_data INTO TABLE it_alv_data.

            ENDLOOP.
          ENDIF.
        ENDIF.
*   end of: check connid
      ENDIF.
    ELSE.             " carrier node previously selected
*   read in it_bookings with current key
*   --> transfer target data to alv
      IF e_connid IS INITIAL.          " data for carrier node required
        LOOP AT it_bookings INTO wa_bookings
          WHERE carrid = e_carrid.

          wa_alv_data = wa_bookings.
          INSERT wa_alv_data INTO TABLE it_alv_data.

        ENDLOOP.
      ELSE.                            " connection or flight node
        IF e_fldate IS INITIAL. " data for connection node required
          LOOP AT it_bookings INTO wa_bookings
            WHERE carrid = e_carrid
            AND   connid = e_connid.

            wa_alv_data = wa_bookings.
            INSERT wa_alv_data INTO TABLE it_alv_data.

          ENDLOOP.

        ELSE.                          " data for flight node required

          LOOP AT it_bookings INTO wa_bookings
            WHERE carrid = e_carrid
            AND   connid = e_connid
            AND   fldate = e_fldate.

            wa_alv_data = wa_bookings.
            INSERT wa_alv_data INTO TABLE it_alv_data.

          ENDLOOP.

        ENDIF.
      ENDIF.
    ENDIF.

    IF NOT first_time IS INITIAL.      " first time!

      CLEAR first_time.
*     send collected data to alv grid object
      CALL METHOD my_alv->set_table_for_first_display
        EXPORTING
          i_structure_name = 'SBOOK'
        CHANGING
          it_outtab        = it_alv_data
        EXCEPTIONS
          OTHERS           = 1.

      IF sy-subrc NE 0.
*      ???
      ENDIF.
    ELSE.                              " NOT first time
*     refresh alv display
      CALL METHOD my_alv->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
************************************************************************
*                                                                      *
*      M A I N   P R O G R A M                                         *
*                                                                      *
************************************************************************

START-OF-SELECTION.

* call control parent screen
  CALL SCREEN 100.

************************************************************************
*                                                                      *
*     E N D    O F    M A I N    P R O G R A M                         *
*                                                                      *
************************************************************************

************************************************************************
*                                                                      *
*     S C R E E N    M O D U L E S                                     *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_CPROCESSIN  OUTPUT
*&---------------------------------------------------------------------*
*       transfer initial data to local application object
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF my_tree_container IS INITIAL.

*   create container object for flight_info_tree
    CREATE OBJECT my_tree_container
      EXPORTING
        side      = cl_gui_docking_container=>dock_at_left
        extension = 400
      EXCEPTIONS
        others    = 1.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create flight_info_tree
    CREATE OBJECT my_flight_tree
      EXPORTING
        i_container         = my_tree_container
        i_root_node_text    = text-004
        i_flight_node_text1 = text-007
        i_flight_node_text2 = text-008
        i_node_double_click = cl_bc412_flight_info_tree1=>c_true
        i_appl_event_ndc    = cl_bc412_flight_info_tree1=>c_true
        i_level_no          = cl_bc412_flight_info_tree1=>c_level_3
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create container object for alv
    CREATE OBJECT my_alv_container
      EXPORTING
        container_name = 'CONTAINER_AREA1'
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create alv object
    CREATE OBJECT my_alv
      EXPORTING
        i_parent = my_alv_container
      EXCEPTIONS
        others = 1.

    IF sy-subrc NE 0.
      MESSAGE a010(bc412).
    ENDIF.

    SET HANDLER lcl_event_handler=>on_node_double_click
        FOR my_flight_tree.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT


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

************************************************************************
*                                                                      *
*    S U B R O U T I N E S                                             *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&      Form  FREE_CONTROL_RESSOURCES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD: my_flight_tree->free,
               my_tree_container->free,
               my_alv->free,
               my_alv_container->free.
  FREE: my_flight_tree,
        my_tree_container,
        my_alv,
        my_alv_container.
ENDFORM.                               " FREE_CONTROL_RESSOURCES
