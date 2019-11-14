*&---------------------------------------------------------------------*
*& Report  SAPBC412_TRED_DATA_MANAGE_2                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  Demo program 2 for data management strategies for SAP tree control *
*&  handling (Unit "SAP Tree Control" of classroom training "BC412").  *
*&                                                                     *
*&  The program displays data of database tables SCARR, SPFLI, SFLIGHT,*
*&  SBOOK in hierarchical order in a Simple Tree Control.              *
*&                                                                     *
*&  Since the application keys of database tables SFLIGHT and SBOOK are*
*&  in total longer than the field NODEKEY (character of length 12)    *
*&                                                                     *
*&    SCARR   SPFLI   SFLIGHT  SBOOK    type/length    total key       *
*&                                                     length          *
*&    ----------------------------------------------------------       *
*&    carrid  carrid  carrid   carrid   char/3            3       < 12 *
*&            connid  connid   connid   char/4            7       < 12 *
*&                    fldate   fldate   date  -> char/8  15       > 12 *
*&                             sbook    int/8 -> char/8  23       > 12 *
*&                                                                     *
*&  the application table keys have to be mapped to field node_key.    *
*&                                                                     *
*&  This demo programs uses strategy B (explained in BC412):           *
*&  The mapping is achieved with the help of internal table IT_MAPPING.*
*&  As node keys simple numbers are taken: Whenever a new node is      *
*&  inserted into the tree, variable COUNTER is increased and taken as *
*&  new node key. Both, the node key and the corresponding set of      *
*&  application keys (carrid, connid, fldate, bookid) are stored in    *
*&  internal table IT_MAPPING.                                         *
*&                                                                     *
*&  For simplicity the database tables are buffered in internal tables *
*&  via array fetch before the tree control investigation starts.      *
*&  Any improved version of this program should implement              *
*&  an incemental buffering of the application data: the data should   *
*&  be buffered only when the user request it the first time during    *
*&  program execution (during event handling of event                  *
*&  EXPAND_NO_CHILDREN).                                               *
*&                                                                     *
*&  IMPROVEMENTS: - partial (sequential) buffering of application data *
*&                - encapsulate the mapping table in a "service object"*
*&                  that implements the mapping table as two hashed    *
*&                  tables (table one has the application key as table *
*&                  key, table 2 has the node key as table key)        *
*&                  this allows O(1) access time for both keys         *
*&---------------------------------------------------------------------*

REPORT  sapbc412_tred_data_manage_2 MESSAGE-ID bc412.
* global types (type pools)
TYPE-POOLS: cntl.

DATA:
    ok_code       TYPE sy-ucomm,       " command field
    copy_ok_code  LIKE ok_code,        " copy of ok_code

*   control specific: object references
    ref_container TYPE REF TO cl_gui_docking_container,
    ref_tree      TYPE REF TO cl_gui_simple_tree,

*   internal tables
    it_scarr      TYPE SORTED TABLE OF scarr
                       WITH UNIQUE KEY carrid,
    it_spfli      TYPE SORTED TABLE OF spfli
                       WITH UNIQUE KEY carrid connid,
    it_sflight    TYPE SORTED TABLE OF sflight
                       WITH UNIQUE KEY carrid connid fldate,
    it_sbook      TYPE SORTED TABLE OF sbook
                       WITH UNIQUE KEY carrid connid fldate bookid,

*   tree: node table and work area
    it_nodes      TYPE TABLE OF bc412_sim_tree_node_struc,

*--------- key mapping: application table keys --> node keys ----------
*   mapping work area
    BEGIN OF wa_mapping,               " application data --> node key
      carrid   TYPE s_carr_id,         " carrier id    (1)
      connid   TYPE s_conn_id,         " connection id (2)
      fldate   TYPE s_date,            " flight date   (3)
      bookid   type s_book_id,         " booking number(4)
      node_key TYPE tv_nodekey,        "                      node key
    END OF wa_mapping,

*   mapping internal table
    it_mapping LIKE HASHED TABLE OF wa_mapping
               WITH UNIQUE KEY node_key,

*   auxiliary
    counter TYPE i,
* ---------end of key mapping -----------------------------------------

*   event table
    it_events     TYPE cntl_simple_events,
    wa_events     LIKE LINE OF it_events,

*   auxiliaries (needed for SELECT OPTIONS)
    carrid TYPE s_carr_id,
    connid TYPE s_conn_id,
    fldate TYPE s_date.

***********************************************************************
*                                                                     *
*  S E L E C T I O N    S C R E E N                                   *
*                                                                     *
***********************************************************************
* restrict amount of data buffered for table SBOOK
SELECTION-SCREEN BEGIN OF BLOCK book WITH FRAME TITLE text-002.
* text-002    " <-- data selection for table SBOOK
SELECT-OPTIONS:
  so_carr FOR carrid MEMORY ID car,
  so_conn FOR connid MEMORY ID con,
  so_date FOR fldate MEMORY ID day.
SELECTION-SCREEN END OF BLOCK book.
***********************************************************************
*                                                                     *
*  L O C A L    C L A S S E S                                         *
*                                                                     *
***********************************************************************

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       local class containing static event handler method            *
*       - for event EXPAND_NO_CHILDERN of Simple Tree Control         *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_expand_no_children FOR EVENT expand_no_children OF
            cl_gui_simple_tree IMPORTING node_key.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       corresponding method implementation                           *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_expand_no_children.
*&--------------------------------------------------------------------*
*&  node_key TYPE TV_NODEKEY      node key of node to be expanded
*&--------------------------------------------------------------------*
*   local data objects
    DATA:
*     node table handling
      l_it_nodes       TYPE TABLE OF bc412_sim_tree_node_struc,
      l_wa_nodes       LIKE LINE OF l_it_nodes,
*     auxiliaries for mapping
      l_wa_map_analyze LIKE LINE OF it_mapping,
      l_wa_map_insert  LIKE LINE OF it_mapping,
      l_table_name(30) TYPE c,
*     work areas for internal tables buffering application data
      l_wa_scarr       TYPE scarr,      " airline carrier
      l_wa_spfli       TYPE spfli,      " connection
      l_wa_sflight     TYPE sflight,    " flight
      l_wa_sbook       TYPE sbook.      " booking

*   find out which node to expand:------------------------------------

*   a) node_key --> it_mapping
    READ TABLE it_mapping INTO l_wa_map_analyze
         WITH TABLE KEY node_key = node_key.
    IF sy-subrc NE 0.
*     error in algorithm, should not occur, :-))
    ENDIF.

*   b) determine type of node (--> table name)
    IF     l_wa_map_analyze-carrid IS INITIAL.     " --> ROOT    node
      l_table_name = 'ROOT'.
    ELSEIF l_wa_map_analyze-connid IS INITIAL.     " --> SCARR   node
      l_table_name = 'SCARR'.
    ELSEIF l_wa_map_analyze-fldate IS INITIAL.     " --> SPFLI   node
      l_table_name = 'SPFLI'.
    ELSEIF l_wa_map_analyze-bookid IS INITIAL.     " --> SFLIGHT node
      l_table_name = 'SFLIGHT'.
    ENDIF. " ---------------------------------------------------------

    CASE l_table_name.
      WHEN 'ROOT'.
*     create scarr nodes
        LOOP AT it_scarr INTO l_wa_scarr.

* ---------- maintain mapping table ----------------------------*
          CLEAR l_wa_map_insert.                               "*
          MOVE-CORRESPONDING l_wa_scarr TO l_wa_map_insert.    "*
          ADD 1 TO counter.                                    "*
          l_wa_map_insert-node_key = counter.                  "*
          INSERT l_wa_map_insert INTO TABLE it_mapping.        "*
* --------------------------------------------------------------*

          l_wa_nodes-node_key   = l_wa_map_insert-node_key.
          l_wa_nodes-relatkey   = node_key.
          l_wa_nodes-relatship  = cl_gui_simple_tree=>relat_last_child.
          l_wa_nodes-isfolder   = 'X'.
          l_wa_nodes-expander   = 'X'.
          l_wa_nodes-text       = l_wa_scarr-carrname.

          INSERT l_wa_nodes INTO TABLE l_it_nodes.

        ENDLOOP.

      WHEN 'SCARR'.
*     create spfli nodes
        LOOP AT it_spfli INTO l_wa_spfli
             WHERE carrid = l_wa_map_analyze-carrid.

* ---------- maintain mapping table ----------------------------*
          CLEAR l_wa_map_insert.                               "*
          MOVE-CORRESPONDING l_wa_spfli TO l_wa_map_insert.    "*
          ADD 1 TO counter.                                    "*
          l_wa_map_insert-node_key = counter.                  "*
          INSERT l_wa_map_insert INTO TABLE it_mapping.        "*
* --------------------------------------------------------------*

          l_wa_nodes-node_key   = l_wa_map_insert-node_key.
          l_wa_nodes-relatkey   = node_key.
          l_wa_nodes-relatship  = cl_gui_simple_tree=>relat_last_child.
          l_wa_nodes-isfolder   = 'X'.
          l_wa_nodes-expander   = 'X'.
          CONCATENATE l_wa_spfli-connid l_wa_spfli-cityfrom '->'
                      l_wa_spfli-cityto INTO l_wa_nodes-text
                      SEPARATED BY ' '.

          INSERT l_wa_nodes INTO TABLE l_it_nodes.

        ENDLOOP.

      WHEN 'SPFLI'.
*     create sflight nodes
        LOOP AT it_sflight INTO l_wa_sflight
               WHERE carrid = l_wa_map_analyze-carrid
               AND   connid = l_wa_map_analyze-connid.

* ---------- maintain mapping table ----------------------------*
          CLEAR l_wa_map_insert.                               "*
          MOVE-CORRESPONDING l_wa_sflight TO l_wa_map_insert.  "*
          ADD 1 TO counter.                                    "*
          l_wa_map_insert-node_key = counter.                  "*
          INSERT l_wa_map_insert INTO TABLE it_mapping.        "*
* --------------------------------------------------------------*

          l_wa_nodes-node_key   = l_wa_map_insert-node_key.
          l_wa_nodes-relatkey   = node_key.
          l_wa_nodes-relatship  = cl_gui_simple_tree=>relat_last_child.
          l_wa_nodes-isfolder   = 'X'.
          l_wa_nodes-expander   = 'X'.
          WRITE l_wa_sflight-fldate TO l_wa_nodes-text.

          INSERT l_wa_nodes INTO TABLE l_it_nodes.

        ENDLOOP.

      WHEN 'SFLIGHT'.
*     create sbook nodes
        LOOP AT it_sbook INTO l_wa_sbook
               WHERE carrid = l_wa_map_analyze-carrid
               AND   connid = l_wa_map_analyze-connid
               AND   fldate = l_wa_map_analyze-fldate.

* ---------- maintain mapping table ----------------------------*
          CLEAR l_wa_map_insert.                               "*
          MOVE-CORRESPONDING l_wa_sbook TO l_wa_map_insert.    "*
          ADD 1 TO counter.                                    "*
          l_wa_map_insert-node_key = counter.                  "*
          INSERT l_wa_map_insert INTO TABLE it_mapping.        "*
* --------------------------------------------------------------*

          l_wa_nodes-node_key   = l_wa_map_insert-node_key.
          l_wa_nodes-relatkey   = node_key.
          l_wa_nodes-relatship  = cl_gui_simple_tree=>relat_last_child.
          l_wa_nodes-isfolder   = ' '.
          l_wa_nodes-expander   = ' '.
          l_wa_nodes-text       = l_wa_sbook-bookid.

          INSERT l_wa_nodes INTO TABLE l_it_nodes.

        ENDLOOP.

    ENDCASE.

*   send additional nodes to tree control

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

********************************************************************
*                                                                  *
*   S T A R T   O F   M A I N   P R O G R A M                      *
*                                                                  *
********************************************************************
START-OF-SELECTION.

*   database tables are buffered
*   read data
  SELECT * FROM  scarr INTO TABLE it_scarr.
  IF sy-subrc NE 0.
    MESSAGE a060(bc412).
  ENDIF.

  SELECT * FROM  spfli INTO TABLE it_spfli.
  IF sy-subrc NE 0.
    MESSAGE a061(bc412).
  ENDIF.

  SELECT * FROM  sflight INTO TABLE it_sflight.
  IF sy-subrc NE 0.
    MESSAGE a062(bc412).
  ENDIF.

* amount of sbook data can be restricted by select options
  SELECT * FROM  sbook INTO TABLE it_sbook
     WHERE carrid IN so_carr
     AND   connid IN so_conn
     AND   fldate IN so_date.
  IF sy-subrc NE 0.
    MESSAGE a063(bc412).
  ENDIF.

*   call carrier screen
  CALL SCREEN 100.

********************************************************************
*                                                                  *
*   E N D   O F   M A I N   P R O G R A M                          *
*                                                                  *
********************************************************************

********************************************************************
*                                                                  *
*   S C R E E N    M O D U L E S                                   *
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
         extension                   = 400
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

*   fill node table it_nodes  <-- ROOT node only
    PERFORM create_root_node
         CHANGING
            it_nodes      " node table
            it_mapping    " mapping table appl. key <--> node key
            counter.      " global (node) counter

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
*   1. cfw
    wa_events-eventid = ref_tree->eventid_expand_no_children.
    wa_events-appl_event = ' '.

    INSERT wa_events INTO TABLE it_events.

    CALL METHOD ref_tree->set_registered_events
      EXPORTING
        events                    = it_events
       EXCEPTIONS
         OTHERS                    = 1.

    IF sy-subrc <> 0.
      MESSAGE a012(bc412).
    ENDIF.

*   2. ABAP objects
    SET HANDLER lcl_event_handler=>on_expand_no_children FOR
        ref_tree.

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
*   F O R M    R O U T I N E S                                     *
*                                                                  *
********************************************************************

*&-----------------------------------------------------------------*
*&      Form  CREATE_ROOT_NODE
*&-----------------------------------------------------------------*
*       create node table: ROOT node only
*------------------------------------------------------------------*
*       <--> p_it_nodes
*       <--> p_it_mapping
*       <--> p_counter
*------------------------------------------------------------------*
FORM create_root_node CHANGING p_it_nodes   LIKE it_nodes
                               p_it_mapping LIKE it_mapping
                               p_counter    LIKE counter.
* local data
  DATA:
    l_wa_nodes   LIKE LINE OF p_it_nodes,
    l_wa_mapping LIKE LINE OF p_it_mapping.

* create root  node

* ---------- maintain mapping table ----------------------------*
  p_counter             = 1.                                   "*
                                                               "*
  CLEAR: l_wa_mapping-carrid,                                  "*
         l_wa_mapping-connid,                                  "*
         l_wa_mapping-fldate,                                  "*
         l_wa_mapping-bookid.                                  "*
                                                               "*
  l_wa_mapping-node_key = p_counter.                           "*
                                                               "*
  INSERT l_wa_mapping INTO TABLE p_it_mapping.                 "*
* --------------------------------------------------------------*

  l_wa_nodes-node_key   = l_wa_mapping-node_key.
* l_wa_nodes-relatkey   = .            " special case, root has no
* l_wa_nodes-relatship  = .            " related entry
  l_wa_nodes-isfolder   = 'X'.
  l_wa_nodes-expander   = 'X'.
  l_wa_nodes-text       = text-001.    " <-- Carrier
*

  INSERT l_wa_nodes INTO TABLE p_it_nodes.

ENDFORM.                               " CREATE_ROOT_NODE


************************************************************************
*                                                                      *
*    A D D I T I O N A L    P R O G R A M    E V E N T   B L O C K S   *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&   Event LOAD-OF-PROGRAM
*&---------------------------------------------------------------------*
*&   Used to check whether user specific default values for the select *
*&   options (SBOOK buffer) are available, if not, set default values  *
*&   carrier id    = 'LH '                                             *
*&   connection id = '0400'                                            *
*&---------------------------------------------------------------------*
LOAD-OF-PROGRAM.

  GET PARAMETER ID 'CAR' FIELD carrid.
  GET PARAMETER ID 'CON' FIELD connid.
  GET PARAMETER ID 'DAY' FIELD fldate.

  IF    (     ( NOT carrid IS INITIAL )
          AND ( NOT connid IS INITIAL )
          AND ( NOT fldate IS INITIAL ) )
*
     OR (     ( NOT carrid IS INITIAL )
          AND ( NOT connid IS INITIAL )
          AND (     fldate IS INITIAL ) )
*
     OR (     ( NOT carrid IS INITIAL )
          AND (     connid IS INITIAL )
          AND (     fldate IS INITIAL ) ).
*    do nothing, keep user values
  ELSE.
*    in all other cases --> set definite default values
    so_carr-low = 'LH    '. APPEND so_carr.
    so_conn-low = '0400'.   APPEND so_conn.
  ENDIF.
