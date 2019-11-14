*----------------------------------------------------------------------*
*   INCLUDE BC412_FLIGHT_INFO_TREE_1LCL
*----------------------------------------------------------------------*
* NOTE: The calling program has to define the two text elements
*       text-TR1 = ' free'
*       text-TR2 = 'no seats free'
*
*---------------------------------------------------------------------*
* auxiliary class definitions
INCLUDE bc412_mapping_521_1lcl.        " mapping: tree handling

*---------------------------------------------------------------------*
*       CLASS lcl_flight_info_tree_1 DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_flight_info_tree_1 DEFINITION.
  PUBLIC SECTION.
* class internal types
    TYPES:
      t_key1    TYPE s_carr_id,
      t_key2    TYPE s_conn_id,
      t_key3    TYPE s_date,
      t_key4    TYPE s_book_id,
      t_key5    TYPE s_customer,
      t_level   TYPE i,
* internal auxiliary
      t_text(36) TYPE c.

* constant definitions
    CONSTANTS:
      c_true    TYPE c       VALUE 'X',
      c_false   TYPE c       VALUE ' ',
      c_text1   TYPE t_text  VALUE 'seats free',
      c_text2   TYPE t_text  VALUE 'no seats free',
      c_level_0 TYPE t_level VALUE 0, " root    node level
      c_level_1 TYPE t_level VALUE 1, " SCARR   node level
      c_level_2 TYPE t_level VALUE 2, " SPFLI   node level
      c_level_3 TYPE t_level VALUE 3, " SFLIGHT node level
      c_level_4 TYPE t_level VALUE 4. " SBOOK   node level

* event definitions
    EVENTS:
      node_double_click
        EXPORTING
          value(e_carrid)   TYPE t_key1
          value(e_connid)   TYPE t_key2
          value(e_fldate)   TYPE t_key3
          value(e_bookid)   TYPE t_key4
          value(e_level)    type t_level.


* method definitions
    METHODS:
      constructor
        IMPORTING
          i_container         TYPE REF TO cl_gui_container
          i_root_node_text    TYPE bc412_sim_tree_node_struc-text
          i_flight_node_text1 TYPE t_text DEFAULT c_text1
          i_flight_node_text2 TYPE t_text DEFAULT c_text2
          i_node_double_click TYPE c DEFAULT c_true " ndc
          i_appl_event_ndc    TYPE c DEFAULT c_true
          i_level_no          TYPE i DEFAULT c_level_4
        EXCEPTIONS
          tree_create_error
          root_create_error,

      free,

      get_scarr_details
        IMPORTING
          value(i_carrid) TYPE t_key1
        EXPORTING
          value(e_scarr)  TYPE scarr
        EXCEPTIONS
          no_data_found,

      get_spfli_details
        IMPORTING
          value(i_carrid) TYPE t_key1
          value(i_connid) TYPE t_key2
        EXPORTING
          value(e_spfli)  TYPE spfli
        EXCEPTIONS
          no_data_found,

      get_sflight_details
        IMPORTING
          value(i_carrid)   TYPE t_key1
          value(i_connid)   TYPE t_key2
          value(i_fldate)   TYPE t_key3
        EXPORTING
          value(e_sflight)  TYPE sflight
        EXCEPTIONS
          no_data_found,

      get_sbook_details
        IMPORTING
          value(i_carrid)   TYPE t_key1
          value(i_connid)   TYPE t_key2
          value(i_fldate)   TYPE t_key3
          value(i_bookid)   TYPE t_key4
        EXPORTING
          value(e_sbook)    TYPE sbook
        EXCEPTIONS
          no_data_found,

      get_scustom_details
        IMPORTING
          value(i_id)       TYPE t_key5
        EXPORTING
          value(e_scustom)  TYPE scustom
        EXCEPTIONS
          no_data_found,

      get_sbook_scustom_details
        IMPORTING
          value(i_carrid)   TYPE t_key1
          value(i_connid)   TYPE t_key2
          value(i_fldate)   TYPE t_key3
          value(i_bookid)   TYPE t_key4
          value(i_id)       TYPE t_key5
        EXPORTING
          value(e_sbook)    TYPE sbook
          value(e_scustom)  TYPE scustom
        EXCEPTIONS
          no_sbook_data_found
          no_scustom_data_found.

  PRIVATE SECTION.
* type definitions
    TYPES: node_table_type TYPE STANDARD TABLE OF
                           bc412_sim_tree_node_struc,
           BEGIN OF mapping_type,
             carrid   TYPE t_key1,
             connid   TYPE t_key2,
             fldate   TYPE t_key3,
             bookid   TYPE t_key4,
           END OF mapping_type,
           BEGIN OF booking_node_type.
            INCLUDE STRUCTURE sbook.
    TYPES:   name TYPE scustom-name,
           END OF booking_node_type,
           it_booking_type TYPE SORTED TABLE OF booking_node_type
             WITH UNIQUE KEY carrid connid fldate bookid.


* internal data tables
    DATA: it_scarr   TYPE SORTED TABLE OF scarr
                     WITH UNIQUE KEY carrid,
          it_spfli   TYPE SORTED TABLE OF spfli
                     WITH UNIQUE KEY carrid connid,
          it_sflight TYPE SORTED TABLE OF sflight
                     WITH UNIQUE KEY carrid connid fldate,
          it_sbook   TYPE SORTED TABLE OF sbook
                     WITH UNIQUE KEY carrid connid fldate bookid,
          it_scustom TYPE SORTED TABLE OF scustom
                     WITH UNIQUE KEY id,
* work areas
          wa_scarr   LIKE LINE OF it_scarr,
          wa_spfli   LIKE LINE OF it_spfli,
          wa_sflight LIKE LINE OF it_sflight,
          wa_sbook   LIKE LINE OF it_sbook,
          wa_scustom LIKE LINE OF it_scustom,
* object reference variables
          o_simple_tree TYPE REF TO cl_gui_simple_tree,
          o_mapping     TYPE REF TO lcl_mapping_4to_tree_1,
* node texts
          sflight_node_text1 TYPE t_text,
          sflight_node_text2 TYPE t_text,
* number of level
          level_no   TYPE i.

    METHODS: create_root_node
               IMPORTING
                 i_root_node_text TYPE bc412_sim_tree_node_struc-text
               EXCEPTIONS
                 root_create_error,

             on_expand_no_children FOR EVENT expand_no_children
                                          OF cl_gui_simple_tree
               IMPORTING
                 node_key,

             on_node_double_click  FOR EVENT node_double_click
                                          OF cl_gui_simple_tree
               IMPORTING
                 node_key,

             fill_scarr_node
               IMPORTING
                 value(i_node_key) TYPE tv_nodekey
               EXCEPTIONS
                 mapping_insert_error
                 node_add_error,

             fill_spfli_node
               IMPORTING
                 value(i_node_key) TYPE tv_nodekey
                 value(i_key1)     TYPE t_key1
               EXCEPTIONS
                 mapping_insert_error
                 node_add_error,

             fill_sflight_node
               IMPORTING
                 value(i_node_key) TYPE tv_nodekey
                 value(i_key1)     TYPE t_key1
                 value(i_key2)     TYPE t_key2
               EXCEPTIONS
                 mapping_insert_error
                 node_add_error,

             fill_sbook_node
               IMPORTING
                 value(i_node_key) TYPE tv_nodekey
                 value(i_key1)     TYPE t_key1
                 value(i_key2)     TYPE t_key2
                 value(i_key3)     TYPE t_key3
               EXCEPTIONS
                 mapping_insert_error
                 node_add_error,

             get_customer_names
               CHANGING
                 i_booking_info    TYPE it_booking_type
               EXCEPTIONS
                 data_error.

ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_flight_info_tree IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_flight_info_tree_1 IMPLEMENTATION.
  METHOD constructor.
* local data: internal table with registered eventids
    DATA events TYPE cntl_simple_events.
    DATA wa_events TYPE cntl_simple_event.

* 1. set current number of levels
    level_no = i_level_no.

* 2. create instances for tree control and mapping class
* 2.a. create tree control
    CREATE OBJECT o_simple_tree
      EXPORTING
*        lifetime            = cl_gui_simple_tree=>lifetime_imode
         parent              = i_container
*        shellstyle          = shellstyle
         node_selection_mode = cl_gui_simple_tree=>node_sel_mode_single
*        hide_selection      = ' '
      EXCEPTIONS
           lifetime_error              = 1
           cntl_system_error           = 2
           create_error                = 3
           illegal_node_selection_mode = 4
           failed                      = 5.
    IF sy-subrc NE 0.
      RAISE tree_create_error.
    ENDIF.

* 2.b. create mapping object
    CREATE OBJECT o_mapping.

* 3. create ROOT node
    CALL METHOD me->create_root_node
            EXPORTING
              i_root_node_text = i_root_node_text
            EXCEPTIONS
              root_create_error = 1.
    IF sy-subrc NE 0.
      RAISE root_create_error.
    ENDIF.

* 4. register events
* fill workarea for event registration

*   event: node_double_click
    IF i_node_double_click = c_true.
      wa_events-eventid = cl_gui_simple_tree=>eventid_node_double_click.
      wa_events-appl_event = i_appl_event_ndc.

      APPEND wa_events TO events.
    ENDIF.

*   event: expand_no_children
    wa_events-eventid = cl_gui_simple_tree=>eventid_expand_no_children.
    wa_events-appl_event = c_false.

    APPEND wa_events TO events.

* register events
    CALL METHOD o_simple_tree->set_registered_events
        EXPORTING events = events.

    IF i_node_double_click = c_true.
      SET HANDLER me->on_node_double_click  FOR o_simple_tree.
    ENDIF.
    SET HANDLER me->on_expand_no_children FOR o_simple_tree.

* 5. store node texts for sflight nodes in instance data
    sflight_node_text1 =  i_flight_node_text1.
    sflight_node_text2 =  i_flight_node_text2.

  ENDMETHOD.
*-----------------------------------------------------------------------
  method free.
    call method o_simple_tree->free.
    free: o_simple_tree, o_mapping.
  endmethod.
*-----------------------------------------------------------------------
  METHOD get_scarr_details.
    READ TABLE it_scarr INTO e_scarr WITH TABLE KEY
      carrid = i_carrid.
    IF sy-subrc NE 0.
      RAISE no_data_found.
    ENDIF.
  ENDMETHOD.
*-----------------------------------------------------------------------
  METHOD get_spfli_details.
    READ TABLE it_spfli INTO e_spfli WITH TABLE KEY
      carrid = i_carrid
      connid = i_connid.
    IF sy-subrc NE 0.
      RAISE no_data_found.
    ENDIF.
  ENDMETHOD.
*-----------------------------------------------------------------------
  METHOD get_sflight_details.
    READ TABLE it_sflight INTO e_sflight WITH TABLE KEY
      carrid = i_carrid
      connid = i_connid
      fldate = i_fldate.
    IF sy-subrc NE 0.
      RAISE no_data_found.
    ENDIF.
  ENDMETHOD.
*-----------------------------------------------------------------------
  METHOD get_sbook_details.
    READ TABLE it_sbook INTO e_sbook WITH TABLE KEY
      carrid   = i_carrid
      connid   = i_connid
      fldate   = i_fldate
      bookid   = i_bookid.
    IF sy-subrc NE 0.
      RAISE no_data_found.
    ENDIF.
  ENDMETHOD.
*-----------------------------------------------------------------------
  METHOD get_scustom_details.
    READ TABLE it_scustom INTO e_scustom WITH TABLE KEY
      id = i_id.
    IF sy-subrc NE 0.
      RAISE no_data_found.
    ENDIF.
  ENDMETHOD.
*----------------------------------------------------------------------
  METHOD get_sbook_scustom_details.
    CALL METHOD get_sbook_details
      EXPORTING
        i_carrid = i_carrid
        i_connid = i_connid
        i_fldate = i_fldate
        i_bookid = i_bookid
      IMPORTING
        e_sbook  = e_sbook
      EXCEPTIONS
        no_data_found = 1.
    IF sy-subrc NE 0.
      RAISE no_sbook_data_found.
    ENDIF.

    CALL METHOD get_scustom_details
      EXPORTING
        i_id      = i_id
      IMPORTING
        e_scustom = e_scustom
      EXCEPTIONS
        no_data_found = 1.
    IF sy-subrc NE 0.
      raise no_scustom_data_found.
    endif.
    ENDMETHOD.

*-----------------------------------------------------------------------
    METHOD create_root_node.
* local node table
      DATA: node_table TYPE node_table_type,
            wa_node    LIKE LINE OF node_table.

* create root node entry
      CLEAR wa_node.
      wa_node-node_key   = 'ROOT'.
*   wa_node-relatkey   = .            " special case, root has no
*   wa_node-relatship  = .            " related entry
     wa_node-hidden     = ' '.         " ' ' = visible, 'X' = invisible
      wa_node-disabled   = 'X'.        " node is not selectable
      wa_node-isfolder   = 'X'.
    wa_node-n_image    = ' '.         " use default icon (closed folder)
    wa_node-exp_image  = ' '.         " use default icon (expand folder)
      wa_node-style      = cl_gui_simple_tree=>style_default.
*   wa_node-last_hitem = .
*   wa_node-no_branch  = .

      IF level_no = c_level_0.
        wa_node-expander   = ' '.
      ELSE.
        wa_node-expander   = 'X'.
      ENDIF.

*   wa_node-dragdropid = .
      wa_node-text       = i_root_node_text.
      INSERT wa_node INTO TABLE node_table.

      CALL METHOD o_simple_tree->add_nodes
         EXPORTING
           table_structure_name = 'BC412_SIM_TREE_NODE_STRUC'
           node_table           = node_table
         EXCEPTIONS
           error_in_node_table            = 1
           failed                         = 2
           dp_error                       = 3
           table_structure_name_not_found = 4.

      IF sy-subrc NE 0.
        RAISE root_create_error.
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD on_node_double_click.
*   local data
      DATA:
        l_carrid   TYPE t_key1,
        l_connid   TYPE t_key2,
        l_fldate   TYPE t_key3,
        l_bookid   TYPE t_key4,
        l_level    type t_level.
*   transform technical key of note (tree control) into business keys
*   of the flight model
      CALL METHOD o_mapping->get_business_key
             EXPORTING
               i_tkey  = node_key
             IMPORTING
               e_bkey1 = l_carrid
               e_bkey2 = l_connid
               e_bkey3 = l_fldate
               e_bkey4 = l_bookid
             EXCEPTIONS
               invalid_teckey = 1.
      IF sy-subrc NE 0.
*     should not happen
      ENDIF.

*   determine node level
      IF l_connid IS INITIAL.            " carrier node selected
        l_level = c_level_1.
      ELSEIF l_fldate IS INITIAL.        " connection node selected
        l_level = c_level_2.
      ELSEIF l_bookid IS INITIAL.        " flight node selected
        l_level = c_level_3.
      ELSE.                              " booking node selected
        l_level = c_level_4.
      ENDIF.

*   raise event node_double_click with business key
      RAISE EVENT node_double_click
        EXPORTING
          e_carrid   = l_carrid
          e_connid   = l_connid
          e_fldate   = l_fldate
          e_bookid   = l_bookid
          e_level    = l_level.
    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD on_expand_no_children.
* local data
      DATA: mapping TYPE mapping_type.

*   test for ROOT (special case)
      IF node_key = 'ROOT'.         " expand root       node -> i_scarr
        CALL METHOD me->fill_scarr_node
          EXPORTING
            i_node_key = 'ROOT'
        EXCEPTIONS
          mapping_insert_error  = 1
          node_add_error = 2.

        IF sy-subrc NE 0.
*       open to implement
        ENDIF.

      ELSE.                            " any other node to expand

* get business key of selected node
        CALL METHOD o_mapping->get_business_key
               EXPORTING
                 i_tkey  = node_key
               IMPORTING
                 e_bkey1 = mapping-carrid
                 e_bkey2 = mapping-connid
                 e_bkey3 = mapping-fldate
                 e_bkey4 = mapping-bookid
               EXCEPTIONS
                 invalid_teckey = 1.
        IF sy-subrc NE 0.
*        open to implement
        ENDIF.

        IF mapping-connid IS INITIAL.  " expand carrier node
                                       " -> i_spfli
          CALL METHOD me->fill_spfli_node
            EXPORTING
              i_node_key = node_key
              i_key1     = mapping-carrid
            EXCEPTIONS
              mapping_insert_error = 1
              node_add_error       = 2.

          IF sy-subrc NE 0.
*         open to implement
          ENDIF.

        ELSEIF mapping-fldate IS INITIAL." expand connection node
                                       " -> i_sflight
          CALL METHOD me->fill_sflight_node
            EXPORTING
              i_node_key = node_key
              i_key1     = mapping-carrid
              i_key2     = mapping-connid
            EXCEPTIONS
              mapping_insert_error = 1
              node_add_error       = 2.

          IF sy-subrc NE 0.
*          open to implement
          ENDIF.

        ELSEIF mapping-bookid IS INITIAL." expand flight node
                                       " -> i_sbook
          CALL METHOD me->fill_sbook_node
            EXPORTING
              i_node_key = node_key
              i_key1     = mapping-carrid
              i_key2     = mapping-connid
              i_key3     = mapping-fldate
            EXCEPTIONS
              mapping_insert_error = 1
              node_add_error       = 2.

          IF sy-subrc NE 0.
*          open to implement
          ENDIF.
        ENDIF.
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD fill_scarr_node.
* local node table
      DATA: node_table   TYPE node_table_type,
            wa_node      LIKE LINE OF node_table,
            wa_prev_node LIKE wa_node,
* local mapping structure used to construct node_key
            mapping      TYPE mapping_type.

* read data from database table scarr:
* note: this method is executed only one time during program run
*       it is called the first time the user tries to expand the root
*       node. In all other cases the corresponding data has already
*       send to the tree control. Thus the event expand_no_children
*       is only fired the first time.
      SELECT * FROM scarr INTO CORRESPONDING FIELDS OF TABLE it_scarr.

* create node entries
      CLEAR: wa_node.
     wa_node-hidden     = ' '.         " ' ' = visible, 'X' = invisible
      wa_node-disabled   = ' '.        " node is selectable
      wa_node-isfolder   = 'X'.
    wa_node-n_image    = ' '.         " use default icon (closed folder)
    wa_node-exp_image  = ' '.         " use default icon (expand folder)
      wa_node-style      = cl_gui_simple_tree=>style_default.
*   wa_node-last_hitem = .
*   wa_node-no_branch  = .
      IF level_no = c_level_1.
        wa_node-expander   = ' '.
      ELSE.
        wa_node-expander   = 'X'.
      ENDIF.
*   wa_node-dragdropid = .

      LOOP AT it_scarr INTO wa_scarr.

        CLEAR: mapping.
        MOVE-CORRESPONDING wa_scarr TO mapping.
        CALL METHOD o_mapping->insert_business_key
           EXPORTING
             i_bkey1 = mapping-carrid
             i_bkey2 = mapping-connid
             i_bkey3 = mapping-fldate
             i_bkey4 = mapping-bookid
           IMPORTING
             e_tkey  = wa_node-node_key
           EXCEPTIONS
             internal_error  = 1
             teckey_overflow = 2
             invalid_buskey  = 3.
        IF sy-subrc NE 0.
          RAISE mapping_insert_error.
        ENDIF.
        wa_node-text       = wa_scarr-carrname.

*   first entry of sub nodes
        wa_node-relatkey   = i_node_key.
        wa_node-relatship  = cl_gui_simple_tree=>relat_last_child.
        INSERT wa_node INTO TABLE node_table.
        wa_prev_node = wa_node.
      ENDLOOP.

      CALL METHOD o_simple_tree->add_nodes
         EXPORTING
           table_structure_name = 'BC412_SIM_TREE_NODE_STRUC'
           node_table           = node_table
         EXCEPTIONS
           error_in_node_table            = 1
           failed                         = 2
           dp_error                       = 3
           table_structure_name_not_found = 4.

      IF sy-subrc NE 0.
        RAISE node_add_error.
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD fill_spfli_node.
* local node table
      DATA: node_table   TYPE node_table_type,
            wa_node      LIKE LINE OF node_table,
            wa_prev_node LIKE wa_node,
* local mapping structure used to construct node_key
            mapping      TYPE mapping_type,
* local spfli table
            li_spfli     TYPE SORTED TABLE OF spfli
                         WITH UNIQUE KEY carrid connid.

* read data from database table
* remember: the event expand_no_children is only fired if the tree
*           control on the frontend has no data to show as children
      SELECT * FROM spfli   INTO CORRESPONDING FIELDS OF TABLE li_spfli
         WHERE carrid = i_key1.

* create node entries
      CLEAR: wa_node.
     wa_node-hidden     = ' '.         " ' ' = visible, 'X' = invisible
      wa_node-disabled   = ' '.        " node is selectable
      wa_node-isfolder   = 'X'.
    wa_node-n_image    = ' '.         " use default icon (closed folder)
    wa_node-exp_image  = ' '.         " use default icon (expand folder)
      wa_node-style      = cl_gui_simple_tree=>style_default.
*   wa_node-last_hitem = .
*   wa_node-no_branch  = .

      IF level_no = c_level_2.
        wa_node-expander   = ' '.
      ELSE.
        wa_node-expander   = 'X'.
      ENDIF.

*   wa_node-dragdropid = .

      LOOP AT li_spfli INTO wa_spfli.

        CLEAR: mapping.
        MOVE-CORRESPONDING wa_spfli TO mapping.
        CALL METHOD o_mapping->insert_business_key
           EXPORTING
             i_bkey1 = mapping-carrid
             i_bkey2 = mapping-connid
             i_bkey3 = mapping-fldate
             i_bkey4 = mapping-bookid
           IMPORTING
             e_tkey  = wa_node-node_key
           EXCEPTIONS
             internal_error  = 1
             teckey_overflow = 2
             invalid_buskey  = 3.
        IF sy-subrc NE 0.
          RAISE mapping_insert_error.
        ENDIF.

        CONCATENATE wa_spfli-connid ': ' wa_spfli-cityfrom '--> '
                    wa_spfli-cityto
                    INTO wa_node-text SEPARATED BY ' '.

*   first entry of sub node -> first child
        wa_node-relatkey   = i_node_key.
        wa_node-relatship  = cl_gui_simple_tree=>relat_last_child.
        INSERT wa_node  INTO TABLE node_table.    " fill node table
      INSERT wa_spfli INTO TABLE it_spfli.      " fill global data table
        wa_prev_node = wa_node.
      ENDLOOP.

      CALL METHOD o_simple_tree->add_nodes
         EXPORTING
           table_structure_name = 'BC412_SIM_TREE_NODE_STRUC'
           node_table           = node_table
         EXCEPTIONS
           error_in_node_table            = 1
           failed                         = 2
           dp_error                       = 3
           table_structure_name_not_found = 4.

      IF sy-subrc NE 0.
        RAISE node_add_error.
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD fill_sflight_node.
* local node table
      DATA: node_table   TYPE node_table_type,
            wa_node      LIKE LINE OF node_table,
            wa_prev_node LIKE wa_node,
* local mapping structure used to construct node_key
            mapping      TYPE mapping_type,
* local sflight table
            li_sflight   TYPE SORTED TABLE OF sflight
                         WITH UNIQUE KEY carrid connid fldate,
* auxiliary fields
            freeseats(5),
            text1(36),
            text2(36).

* read database entry corresponding to node to expand
    SELECT * FROM sflight INTO CORRESPONDING FIELDS OF TABLE li_sflight
         WHERE carrid = i_key1
         AND   connid = i_key2.

* create node entry
      CLEAR: wa_node.
     wa_node-hidden     = ' '.         " ' ' = visible, 'X' = invisible
      wa_node-disabled   = ' '.        " node is selectable
      wa_node-isfolder   = 'X'.
    wa_node-n_image    = ' '.         " use default icon (closed folder)
    wa_node-exp_image  = ' '.         " use default icon (expand folder)
      wa_node-style      = cl_gui_simple_tree=>style_default.
*   wa_node-last_hitem = .
*   wa_node-no_branch  = .

      IF level_no = c_level_3.
        wa_node-expander   = ' '.
      ELSE.
        wa_node-expander   = 'X'.
      ENDIF.

*   wa_node-dragdropid = .

      LOOP AT li_sflight INTO wa_sflight.

        CLEAR: mapping, freeseats.
        MOVE-CORRESPONDING wa_sflight TO mapping.
        CALL METHOD o_mapping->insert_business_key
           EXPORTING
             i_bkey1 = mapping-carrid
             i_bkey2 = mapping-connid
             i_bkey3 = mapping-fldate
             i_bkey4 = mapping-bookid
           IMPORTING
             e_tkey  = wa_node-node_key
           EXCEPTIONS
             internal_error  = 1
             teckey_overflow = 2
             invalid_buskey  = 3.
        IF sy-subrc NE 0.
          RAISE mapping_insert_error.
        ENDIF.

        freeseats = wa_sflight-seatsmax - wa_sflight-seatsocc.
        IF freeseats > 0.              " still seats to book
          WRITE wa_sflight-fldate TO text1.
          text2 =  sflight_node_text1.
          CONCATENATE text1 ': ' freeseats text2
                      INTO wa_node-text SEPARATED BY ' '.
        ELSE.                          " no free seats
          WRITE wa_sflight-fldate TO text1.
          text2 = sflight_node_text2.
          CONCATENATE text1 ': ' text2
                      INTO wa_node-text SEPARATED BY ' '.
        ENDIF.

        wa_node-relatkey   = i_node_key.
        wa_node-relatship  = cl_gui_simple_tree=>relat_last_child.
        INSERT wa_node    INTO TABLE node_table.  " fill node table
      INSERT wa_sflight INTO TABLE it_sflight.  " fill global data table
        wa_prev_node = wa_node.
      ENDLOOP.

      CALL METHOD o_simple_tree->add_nodes
         EXPORTING
           table_structure_name = 'BC412_SIM_TREE_NODE_STRUC'
           node_table           = node_table
         EXCEPTIONS
           error_in_node_table            = 1
           failed                         = 2
           dp_error                       = 3
           table_structure_name_not_found = 4.

      IF sy-subrc NE 0.
        RAISE node_add_error.
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD fill_sbook_node.
* local node table
      DATA: node_table   TYPE node_table_type,
            wa_node      LIKE LINE OF node_table,
            wa_prev_node LIKE wa_node,
* local mapping structure used to construct node_key
            mapping      TYPE mapping_type,
* local sbook table
            li_sbook     TYPE it_booking_type,
            wa_l_sbook   LIKE LINE OF li_sbook,

* auxiliary fields
            freeseats(5),
            text1(10),
            text2(10).

* read database table corresponding to node to expand
      SELECT * FROM sbook INTO CORRESPONDING FIELDS OF TABLE li_sbook
         WHERE carrid = i_key1
         AND   connid = i_key2
         AND   fldate = i_key3.

* get customer names corresponding to names
      CALL METHOD get_customer_names
        CHANGING
          i_booking_info = li_sbook
        EXCEPTIONS
          data_error = 1.
      IF sy-subrc NE 0.
*     should not occur: inconsistent data in database tables
      ENDIF.

* create node entry
      CLEAR: wa_node.
     wa_node-hidden     = ' '.         " ' ' = visible, 'X' = invisible
      wa_node-disabled   = ' '.        " node is selectable
      wa_node-isfolder   = ' '.
    wa_node-n_image    = ' '.         " use default icon (closed folder)
    wa_node-exp_image  = ' '.         " use default icon (expand folder)
      wa_node-style      = cl_gui_simple_tree=>style_default.
*   wa_node-last_hitem = .
*   wa_node-no_branch  = .

      IF level_no = c_level_4.
        wa_node-expander   = ' '.
      ELSE.
        wa_node-expander   = ' '.      " always not expandable
      ENDIF.


      wa_node-expander   = ' '.
*   wa_node-dragdropid = .

      LOOP AT li_sbook INTO wa_l_sbook
         WHERE carrid = i_key1
         AND   connid = i_key2
         AND   fldate = i_key3.

        CLEAR: mapping, freeseats.
        MOVE-CORRESPONDING wa_l_sbook TO mapping.
        CALL METHOD o_mapping->insert_business_key
           EXPORTING
             i_bkey1 = mapping-carrid
             i_bkey2 = mapping-connid
             i_bkey3 = mapping-fldate
             i_bkey4 = mapping-bookid
           IMPORTING
             e_tkey  = wa_node-node_key
           EXCEPTIONS
             internal_error  = 1
             teckey_overflow = 2
             invalid_buskey  = 3.
        IF sy-subrc NE 0.
          RAISE mapping_insert_error.
        ENDIF.

        wa_node-text = wa_l_sbook-name.

*     construct hierarchy
        wa_node-relatkey   = i_node_key.
        wa_node-relatship  = cl_gui_simple_tree=>relat_last_child.
        INSERT wa_node  INTO TABLE node_table.    " fill node table
        MOVE-CORRESPONDING wa_l_sbook TO wa_sbook.
      INSERT wa_sbook INTO TABLE it_sbook.      " fill global data table
        wa_prev_node = wa_node.
      ENDLOOP.

      CALL METHOD o_simple_tree->add_nodes
         EXPORTING
           table_structure_name = 'BC412_SIM_TREE_NODE_STRUC'
           node_table           = node_table
         EXCEPTIONS
           error_in_node_table            = 1
           failed                         = 2
           dp_error                       = 3
           table_structure_name_not_found = 4.

      IF sy-subrc NE 0.
        RAISE node_add_error.
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
    METHOD get_customer_names.
*   CHANGING
*     i_booking_info TYPE booking_node_type
*   EXCEPTIONS
*     data_error.
      DATA: wa_booking LIKE LINE OF i_booking_info,
            wa_scustom LIKE LINE OF it_scustom,
            it_cust_no LIKE TABLE OF wa_scustom-id,
            li_scustom TYPE TABLE OF scustom.

      LOOP AT i_booking_info INTO wa_booking.
        READ TABLE it_scustom INTO wa_scustom
             WITH TABLE KEY
                id = wa_booking-customid.
        IF sy-subrc NE 0.              " customer not cashed so far
          INSERT wa_booking-customid INTO TABLE it_cust_no.
        ELSE.                          " customer already cashed
*       copy name and modify booking_node_table
          wa_booking-name = wa_scustom-name.
          MODIFY TABLE i_booking_info FROM wa_booking.
        ENDIF.
      ENDLOOP.

*   check: database access needed?
      READ TABLE it_cust_no INDEX 1 TRANSPORTING NO FIELDS.

      IF sy-subrc EQ 0.                " new customers to read
*     read new customers
        SELECT * FROM scustom
                 INTO CORRESPONDING FIELDS OF TABLE li_scustom
                 FOR ALL ENTRIES IN it_cust_no
                 WHERE id = it_cust_no-table_line.
        IF sy-subrc NE 0.
          RAISE data_error.
        ENDIF.

        LOOP AT li_scustom INTO wa_scustom.
*       store in global cash table
          INSERT wa_scustom INTO TABLE it_scustom.

*       add new names to booking_node_table
          LOOP AT i_booking_info INTO wa_booking
            WHERE customid = wa_scustom-id.

            wa_booking-name = wa_scustom-name.
            MODIFY TABLE i_booking_info FROM wa_booking.
          ENDLOOP.

        ENDLOOP.
      ELSE.
*     nothing to do, because name have already been copied
      ENDIF.

    ENDMETHOD.
*-----------------------------------------------------------------------
  ENDCLASS.
