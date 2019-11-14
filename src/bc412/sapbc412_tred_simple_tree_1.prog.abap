*&---------------------------------------------------------------------*
*& Report  SAPBC412_TRED_SIMPLE_TREE_1                                 *
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
*& The node table IT_NODES is filled in FORM routine CREATE_NODE_TABLE.*
*& All nodes are transfered in a single step to the tree control (no   *
*& use of event EXPAND_NO_CHILDREN).                                   *
*&---------------------------------------------------------------------*

REPORT  sapbc412_tred_simple_tree_1 MESSAGE-ID bc412.
DATA:
    ok_code       TYPE sy-ucomm,       " command field
    copy_ok_code  LIKE ok_code,        " copy of ok_code

*   control specific: object references
    ref_container TYPE REF TO cl_gui_docking_container,
    ref_tree      TYPE REF TO cl_gui_simple_tree,

*   tree: node table
    it_nodes      TYPE TABLE OF bc412_sim_tree_node_struc.

*   start of main program
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
        parent                       = ref_container
        node_selection_mode          = ref_tree->node_sel_mode_single
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
*
*   to be implemented later
*
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
*       create node table
*------------------------------------------------------------------*
*       <--> p_it_nodes LIKE it_nodes     node table
*------------------------------------------------------------------*
FORM create_node_table CHANGING p_it_nodes LIKE it_nodes.
* local data
* constant
  CONSTANTS:
    c_last_child LIKE  cl_gui_simple_tree=>relat_last_child
                 VALUE cl_gui_simple_tree=>relat_last_child.
* workarea
  DATA:
    wa_nodes LIKE LINE OF p_it_nodes.

* create root  node -------------------------------------------------

  CLEAR wa_nodes.
  wa_nodes-node_key   = 'ROOT'.
* wa_nodes-relatkey   = .            " special case, root has no
* wa_nodes-relatship  = .            " related entry
  wa_nodes-isfolder   = 'X'.           " displayed as folder
  wa_nodes-expander   = 'X'.           " expandable without a child
  wa_nodes-text       = text-001.      " <-- carrier

  INSERT wa_nodes INTO TABLE p_it_nodes.

* create carrier nodes ----------------------------------------------

*   American Airlines
  wa_nodes-node_key   = 'AA'.
  wa_nodes-relatkey   = 'ROOT'.        " ROOT is parent
  wa_nodes-relatship  = c_last_child.  " relationship
  wa_nodes-isfolder   = 'X'.           " displayed as folder
  wa_nodes-expander   = 'X'.           " expandable without a child
  wa_nodes-text       = 'American Airlines'.                "#EC NOTEXT

  INSERT wa_nodes INTO TABLE p_it_nodes.

*   Lufthansa
  wa_nodes-node_key   = 'LH'.
  wa_nodes-relatkey   = 'ROOT'.        " ROOT is parent
  wa_nodes-relatship  = c_last_child.  " relationship
  wa_nodes-isfolder   = 'X'.           " displayed as folder
  wa_nodes-expander   = 'X'.           " expandable without a child
  wa_nodes-text       = 'Lufthansa'.                        "#EC NOTEXT

  INSERT wa_nodes INTO TABLE p_it_nodes.

* create connection node --------------------------------------------

*   LH 0400
  wa_nodes-node_key   = 'LH 0400'.
  wa_nodes-relatkey   = 'LH'.          " Lufhansa is parent
  wa_nodes-relatship  = c_last_child.  " relationship
  wa_nodes-isfolder   = ' '.           " displayed as leaf
  wa_nodes-expander   = ' '.           " <-- no meaning here
  wa_nodes-text       = '0400: FRA -> NYA'.                 "#EC NOTEXT

  INSERT wa_nodes INTO TABLE p_it_nodes.

ENDFORM.                               " CREATE_NODE_TABLE
