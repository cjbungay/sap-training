*&---------------------------------------------------------------------*
*& Report  SAPBC412_TRED_DATA_MANAGE_2A                                *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&  Demo program 3 for data management strategies for SAP tree control *
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
*&  The mapping is achieved with the help of internal table            *
*&  encapsulated in a service object described by global class         *
*&  CL_BC412_MAPPING_4_2_TREE. Communication with the service object is*
*&  performed via interfaces of methods:                               *
*&      - get_business_key                                             *
*&      - insert_business_key                                          *
*&                                                                     *
*&  For simplicity the database tables are buffered in internal tables *
*&  via array fetch before the tree control investigation starts.      *
*&  Any improved version of this program should implement              *
*&  an incemental buffering of the application data: the data should   *
*&  be buffered only when the user request it the first time during    *
*&  program execution (during event handling of event                  *
*&  EXPAND_NO_CHILDREN).                                               *
*&                                                                     *
*&  IMPROVEMENTS: - partial (sequential) buffering of application data.*
*&---------------------------------------------------------------------*

REPORT  sapbc412_tred_data_manage_2a MESSAGE-ID bc412.
* global types (type pools)
TYPE-POOLS: cntl.

DATA:
    ok_code       TYPE sy-ucomm,       " command field
    copy_ok_code  LIKE ok_code,        " copy of ok_code

*   control specific: object references
    ref_container TYPE REF TO cl_gui_docking_container,
    ref_tree      TYPE REF TO cl_gui_simple_tree,
*   -------- NEW NEW NEW ---------------------------------------------
    ref_mapping   TYPE REF TO cl_bc412_mapping_4_2_TREE,
*   ------------------------------------------------------------------

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

**   mapping work area
*    BEGIN OF wa_mapping,
*      carrid   ...
*      NOT NEEDED ANY MORE  --> service object REF_MAPPING

*   event table
    it_events     TYPE cntl_simple_events,
    wa_events     LIKE LINE OF it_events,

*   auxiliaries (needed for the SELECT OPTION)
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
      l_it_nodes       TYPE TABLE OF bc412_sim_tree_node_struc,
*     work areas for internal tables buffering application data
      l_wa_nodes       LIKE LINE OF l_it_nodes,
      l_wa_scarr       TYPE scarr,
      l_wa_spfli       TYPE spfli,
      l_wa_sflight     TYPE sflight,
      l_wa_sbook       TYPE sbook,
*     auxiliaries for the mapping (interface)
      l_table_name(30) TYPE c,
      l_carrid         TYPE s_carr_id,
      l_connid         TYPE s_conn_id,
      l_fldate         TYPE s_date,
      l_bookid         TYPE s_book_id.

*   find out which node to expand:
*   a) node_key --> it_mapping
    CALL METHOD ref_mapping->get_business_key
      EXPORTING
        i_tkey         = node_key
      IMPORTING
        E_BKEY1        = l_carrid
        E_BKEY2        = l_connid
        E_BKEY3        = l_fldate
        E_BKEY4        = l_bookid
      EXCEPTIONS
        INVALID_TECKEY = 1
        others         = 2
            .
    IF sy-subrc <> 0.
      MESSAGE A012(bc412).
     ENDIF.


*   b) determine type of node (--> table name)
    IF     l_carrid IS INITIAL.     " --> ROOT    node
      l_table_name = 'ROOT'.
    ELSEIF l_connid IS INITIAL.     " --> SCARR   node
      l_table_name = 'SCARR'.
    ELSEIF l_fldate IS INITIAL.     " --> SPFLI   node
      l_table_name = 'SPFLI'.
    ELSEIF l_bookid IS INITIAL.     " --> SFLIGHT node
      l_table_name = 'SFLIGHT'.
    ENDIF.

    CASE l_table_name.
      WHEN 'ROOT'.
*     create scarr nodes
        LOOP AT it_scarr INTO l_wa_scarr.

** ---------- mapping table -----------------------------------------*
*          CLEAR l_wa_...                                           "*
*          SUBSTITUTED BY METHOD CALL OF SERVICE OBJECT ref_mapping."*
                                                                    "*
          CALL METHOD ref_mapping->insert_business_key
            EXPORTING
              i_bkey1         = l_wa_scarr-carrid
              i_bkey2         = l_connid
              i_bkey3         = l_fldate
              i_bkey4         = l_bookid
            IMPORTING
              E_TKEY          = l_wa_nodes-node_key
            EXCEPTIONS
              INTERNAL_ERROR  = 1
              TECKEY_OVERFLOW = 2
              INVALID_BUSKEY  = 3
              others          = 4
                  .
          IF sy-subrc <> 0.
            MESSAGE A012(bc412).
          ENDIF.

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
             WHERE carrid = l_carrid.
*         ------------------------------------------------------------
          CALL METHOD ref_mapping->insert_business_key
            EXPORTING
              i_bkey1         = l_wa_spfli-carrid
              i_bkey2         = l_wa_spfli-connid
              i_bkey3         = l_fldate
              i_bkey4         = l_bookid
            IMPORTING
              E_TKEY          = l_wa_nodes-node_key
            EXCEPTIONS
              INTERNAL_ERROR  = 1
              TECKEY_OVERFLOW = 2
              INVALID_BUSKEY  = 3
              others          = 4
                  .
          IF sy-subrc <> 0.
            MESSAGE A012(bc412).
          ENDIF.
*         ------------------------------------------------------------
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
               WHERE carrid = l_carrid
               AND   connid = l_connid.
*         ------------------------------------------------------------
          CALL METHOD ref_mapping->insert_business_key
            EXPORTING
              i_bkey1         = l_wa_sflight-carrid
              i_bkey2         = l_wa_sflight-connid
              i_bkey3         = l_wa_sflight-fldate
              i_bkey4         = l_bookid
            IMPORTING
              E_TKEY          = l_wa_nodes-node_key
            EXCEPTIONS
              INTERNAL_ERROR  = 1
              TECKEY_OVERFLOW = 2
              INVALID_BUSKEY  = 3
              others          = 4
                  .
          IF sy-subrc <> 0.
            MESSAGE A012(bc412).
          ENDIF.
*         ------------------------------------------------------------
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
               WHERE carrid = l_carrid
               AND   connid = l_connid
               AND   fldate = l_fldate.
*         ------------------------------------------------------------
          CALL METHOD ref_mapping->insert_business_key
            EXPORTING
              i_bkey1         = l_wa_sbook-carrid
              i_bkey2         = l_wa_sbook-connid
              i_bkey3         = l_wa_sbook-fldate
              i_bkey4         = l_wa_sbook-bookid
            IMPORTING
              E_TKEY          = l_wa_nodes-node_key
            EXCEPTIONS
              INTERNAL_ERROR  = 1
              TECKEY_OVERFLOW = 2
              INVALID_BUSKEY  = 3
              others          = 4
                  .
          IF sy-subrc <> 0.
            MESSAGE A012(bc412).
          ENDIF.
*         ------------------------------------------------------------
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

*   database tables SCARR, SPFLI, SFLIGHT, SBOOK are buffered
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
    MESSAGE s063(bc412).
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

* ---- NEW NEW NEW ---------------------------------------------------
*   create mapping object: application table key --> node key
    CREATE OBJECT ref_mapping.
* --------------------------------------------------------------------

*   fill node table it_nodes  <-- ROOT node only
    PERFORM create_root_node
         CHANGING
            it_nodes.                   " node table
*            NOT NEEDED ANY LONGER
*            it_mapping    " mapping table appl. key <--> node key
*            counter.                   " global (node) counter

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
*------------------------------------------------------------------*
FORM create_root_node CHANGING p_it_nodes   LIKE it_nodes.
*   NOT NEEDED -->             p_it_mapping LIKE it_mapping
*   NOT NEEDED -->             p_counter    LIKE counter.
* local data
  DATA:
    l_wa_nodes   LIKE LINE OF p_it_nodes,
*   auxiliaries
    l_carrid     TYPE s_carr_id,      " ROOT: needed with initial value
    l_connid     TYPE s_conn_id,      " ROOT: needed with initial value
    l_fldate     TYPE s_date,         " ROOT: needed with initial value
    l_bookid     TYPE s_book_id.      " ROOT: needed with initial value

* create root  node

  CALL METHOD ref_mapping->insert_business_key
    EXPORTING
      i_bkey1         = l_carrid
      i_bkey2         = l_connid
      i_bkey3         = l_fldate
      i_bkey4         = l_bookid
    IMPORTING
      E_TKEY          = l_wa_nodes-node_key
    EXCEPTIONS
      others          = 4
          .
  IF sy-subrc <> 0.
    MESSAGE A012(BC412).
  ENDIF.

* l_wa_nodes-relatkey   = .            " special case, root has no
* l_wa_nodes-relatship  = .            " related entry
  l_wa_nodes-isfolder   = 'X'.
  l_wa_nodes-expander   = 'X'.
  l_wa_nodes-text       = text-001.    " <-- Carrier
*

  INSERT l_wa_nodes INTO TABLE p_it_nodes.

* rest is taken out here -> event handler
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
