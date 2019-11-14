*&---------------------------------------------------------------------*
*& Report  SAPBC412_TRED_SIMPLE_TREE_2                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& BC412 demo program. Demonstrates node table handling                *
*& with static entries displayed in a simple tree control:             *
*&                                                                     *
*&    Airline Carrier                                                  *
*&       |- American Airlines                                          *
*&       |- Lufthansa                                                  *
*&            |- 0400: FRA -> NYA                                      *
*&                                                                     *
*& The node table IT_NODES is filled with the ROOT node in FORM        *
*& routine CREATE_NODE_TABLE. In the initial state of the tree control *
*& the ROOT node is transfered only.                                   *
*&                                                                     *
*& The rest of the nodes are transfered to the tree control if the user*
*& expands a node (event handler for event EXPAND_NO_CHILDREN).        *
*&---------------------------------------------------------------------*

REPORT  sapbc412_tred_simple_tree_2 MESSAGE-ID bc412.
TYPE-POOLS: cntl.

DATA:
    ok_code       TYPE sy-ucomm,       " command field
    copy_ok_code  LIKE ok_code,        " copy of ok_code

*   control specific: object references
    ref_container TYPE REF TO cl_gui_docking_container,
    ref_tree      TYPE REF TO cl_gui_simple_tree,

*   tree: node table
    it_nodes      TYPE TABLE OF bc412_sim_tree_node_struc,

*   event table (cfw)
    it_events     TYPE cntl_simple_events,
    wa_events     LIKE LINE OF it_events.

* constant    <-- moved here from FORM create_node_table
CONSTANTS:
    c_last_child LIKE  cl_gui_simple_tree=>relat_last_child
                 VALUE cl_gui_simple_tree=>relat_last_child.


********************************************************************
*                                 H E R E                          *
*   L O C A L    C L A S S E S:   D E F I N I T I O N              *
*                                 O N L Y                          *
********************************************************************

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_expand_no_children FOR EVENT expand_no_children
                            OF cl_gui_simple_tree
                            IMPORTING node_key.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION  <-- look at file end
*---------------------------------------------------------------------*

********************************************************************
*                                                                  *
*   S T A R T    O F    M A I N    P R O G R A M                   *
*                                                                  *
********************************************************************
START-OF-SELECTION.

*   call carrier screen
  CALL SCREEN 100.

********************************************************************
*                                                                  *
*   E N D    O F    M A I N   P R O G R A M                        *
*                                                                  *
********************************************************************

********************************************************************
*                                                                  *
*   S C R E E N   M O D U L E S                                    *
*                                                                  *
********************************************************************

*&-----------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&-----------------------------------------------------------------*
*       control related processings
*------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_container IS INITIAL.
*   create container
    CREATE OBJECT ref_container
       EXPORTING
*        SIDE                        = DOCK_AT_LEFT
         extension                   = 300
       EXCEPTIONS
         others                      = 1.

    IF sy-subrc <> 0.
      MESSAGE a010(bc412).
    ENDIF.

*   create tree control
    CREATE OBJECT ref_tree
      EXPORTING
        parent                      = ref_container
        node_selection_mode         = ref_tree->node_sel_mode_single
      EXCEPTIONS
        others                      = 1.

    IF sy-subrc <> 0.
      MESSAGE a042(bc412).
    ENDIF.

*   fill node table it_nodes
    PERFORM create_node_table CHANGING it_nodes.

*   send node table to tree control
    CALL METHOD ref_tree->add_nodes
      EXPORTING
        table_structure_name           = 'BC412_SIM_TREE_NODE_STRUC'
        node_table                     = it_nodes
       EXCEPTIONS
         OTHERS                         = 1.

    IF sy-subrc <> 0.
      MESSAGE a012(bc412).
    ENDIF.

*   event registration
*     CFW registration
    wa_events-eventid    = ref_tree->eventid_expand_no_children.
    wa_events-appl_event = ' '.        " treat as SYSTEM EVENT
    INSERT wa_events INTO TABLE it_events.

    CALL METHOD ref_tree->set_registered_events
      EXPORTING
        events                    = it_events
       EXCEPTIONS
         OTHERS                    = 4
            .
    IF sy-subrc <> 0.
      MESSAGE a012(bc412).
    ENDIF.

*     ABAP Objects: SET HANDLER
    SET HANDLER lcl_event_handler=>on_expand_no_children FOR ref_tree.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&-----------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&-----------------------------------------------------------------*
*       GUI settings
*------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'SCREEN_0100'.
  SET TITLEBAR 'SCREEN_0100'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&-----------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&-----------------------------------------------------------------*
*       implementation of function codes
*------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  copy_ok_code = ok_code.
  CLEAR ok_code.

  CASE copy_ok_code.
    WHEN 'BACK' OR 'CANCEL' OR 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT

********************************************************************
*                                                                  *
*   F O R M   R O U T I N E S                                      *
*                                                                  *
********************************************************************

*&-----------------------------------------------------------------*
*&      Form  CREATE_NODE_TABLE
*&-----------------------------------------------------------------*
*       create node table: ONLY ROOT node here !!!
*------------------------------------------------------------------*
*       <--> p_it_nodes LIKE it_nodes      node table
*------------------------------------------------------------------*
FORM create_node_table CHANGING p_it_nodes LIKE it_nodes.
* local data
** constant    <-- SHIFTED TO GLOBAL PROGRAM DATA -- NEEDED TWICE !!
** -----------------------------------------------------------------
*  CONSTANTS:
*     c_last_child LIKE  cl_gui_simple_tree=>relat_last_child
*                  VALUE cl_gui_simple_tree=>relat_last_child.

* workarea
  DATA:
    wa_nodes LIKE LINE OF p_it_nodes.

* create root  node     <-- only ROOT node here !!!

  CLEAR wa_nodes.
  wa_nodes-node_key   = 'ROOT'.
* wa_nodes-relatkey   = .              " special case, root has no
* wa_nodes-relatship  = .              " related entry
  wa_nodes-isfolder   = 'X'.           " displayed as folder
  wa_nodes-expander   = 'X'.           " expandable without a child
  wa_nodes-text       = text-001.      " <-- carrier

  INSERT wa_nodes INTO TABLE p_it_nodes.

ENDFORM.                               " CREATE_NODE_TABLE

***********************************************************************
*                                                                     *
*  L O C A L    C L A S S E S:  I M P L E M E N T A T I O N           *
*                                                                     *
***********************************************************************

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_expand_no_children.
*--------------------------------------------------------*
*&  IMPORTING                                            *
*&    node_key    <-- typisation done by event raiser    *
*--------------------------------------------------------*
*   local data
    DATA:
      l_it_nodes TYPE TABLE OF bc412_sim_tree_node_struc,
      l_wa_nodes LIKE LINE OF l_it_nodes.

    CASE node_key.
      WHEN 'ROOT'.                     " ROOT node to be expanded
*       create carrier nodes ------------------------------------------

*         American Airlines
        l_wa_nodes-node_key   = 'AA'.
        l_wa_nodes-relatkey   = 'ROOT'.        " ROOT is parent
        l_wa_nodes-relatship  = c_last_child.  " relat_last_child
        l_wa_nodes-isfolder   = 'X'.           " displayed as folder
        l_wa_nodes-expander   = 'X'.           " expandable w/o ...
        l_wa_nodes-text       = 'American Airlines'.        "#EC NOTEXT

        INSERT l_wa_nodes INTO TABLE l_it_nodes.

*         Lufthansa
        l_wa_nodes-node_key   = 'LH'.
        l_wa_nodes-relatkey   = 'ROOT'.        " ROOT is parent
        l_wa_nodes-relatship  = c_last_child.  " relat_last_child
        l_wa_nodes-isfolder   = 'X'.           " displayed as folder
        l_wa_nodes-expander   = 'X'.           " expandable w/o ...
        l_wa_nodes-text       = 'Lufthansa'.                "#EC NOTEXT

        INSERT l_wa_nodes INTO TABLE l_it_nodes.

      WHEN 'LH'.                       " Lufthansa node to be expanded
*       create connection node ----------------------------------------

*         LH 0400
        l_wa_nodes-node_key   = 'LH 0400'.
        l_wa_nodes-relatkey   = 'LH'.          " Lufhansa is parent
        l_wa_nodes-relatship  = c_last_child.  " relat_last_child
        l_wa_nodes-isfolder   = ' '.           " displayed as leaf
        l_wa_nodes-expander   = ' '.           " <-- no meaning here
        l_wa_nodes-text       = '0400: FRA -> NYA'.         "#EC NOTEXT

        INSERT l_wa_nodes INTO TABLE l_it_nodes.

    ENDCASE.

*   send additional node(s) to the frontend control
    CALL METHOD ref_tree->add_nodes
      EXPORTING
        table_structure_name           = 'BC412_SIM_TREE_NODE_STRUC'
        node_table                     = l_it_nodes
       EXCEPTIONS
         OTHERS                         = 1.

    IF sy-subrc <> 0.
      MESSAGE i012(bc412).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
