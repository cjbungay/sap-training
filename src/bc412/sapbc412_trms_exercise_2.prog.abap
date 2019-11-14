*&---------------------------------------------------------------------*
*& SAPBC412_TRMS_EXERCISE_2                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Model solution for the second exercise of unit 'TREE Control'       *
*& of classroom training BC412.                                        *
*& The program displays SCARR, SPFLI and SFLIGHT data                  *
*& using an Simple Tree Model                                          *
*& and offers a toolbar with nice additional functionality.            *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_trms_exercise_2 MESSAGE-ID bc412.

TYPE-POOLS icon.

DATA:
* screen-specific:
  ok_code TYPE sy-ucomm,
  copy_ok LIKE ok_code,

* application data:
  it_scarr TYPE SORTED TABLE OF scarr
           WITH UNIQUE KEY carrid,
  it_spfli TYPE SORTED TABLE OF spfli
           WITH UNIQUE KEY carrid connid,
  it_sflight TYPE SORTED TABLE OF sflight
             WITH UNIQUE KEY carrid connid fldate,

  wa_scarr LIKE LINE OF it_scarr,
  wa_spfli LIKE LINE OF it_spfli,
  wa_sflight LIKE LINE OF it_sflight,

* container:
  ref_cont_left   TYPE REF TO cl_gui_docking_container,
  ref_cont_split  TYPE REF TO cl_gui_splitter_container,
  ref_cell_top    TYPE REF TO cl_gui_container,
  ref_cell_bott   LIKE ref_cell_top,

* content:
  ref_tree_model TYPE REF TO cl_simple_tree_model,
  ref_toolbar    TYPE REF TO cl_gui_toolbar,

* auxiliary:
  it_hit_nodes TYPE treemnotab,

* event registration:
  it_events TYPE cntl_simple_events,
  wa_event  LIKE LINE OF it_events.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_function_selected FOR EVENT function_selected
                                       OF cl_gui_toolbar
                                       IMPORTING fcode.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_function_selected.
    DATA:
      l_titletext TYPE string,
      l_search_result_type     TYPE i,
      l_search_result_node_key TYPE string.


    CASE fcode.
      WHEN 'PRINT'.

        l_titletext = text-tit.
        CALL METHOD ref_tree_model->print_tree
          EXPORTING
            all_nodes            = space "displayed nodes only
            title                = l_titletext
            preview              = 'X'   "preview mode
          EXCEPTIONS
            OTHERS               = 1.
        IF sy-subrc <> 0.
          MESSAGE a012.
        ENDIF.

      WHEN 'SEARCH' OR 'SEARCHNEXT'.

        IF fcode = 'SEARCH'.

          CALL METHOD ref_tree_model->unselect_all.

*         user dialog for search pattern, then find first occurence:
          CALL METHOD ref_tree_model->find
            IMPORTING
              result_type     = l_search_result_type
              result_node_key = l_search_result_node_key.

          CASE l_search_result_type.
            WHEN cl_simple_tree_model=>find_match.
*             store hit in order to be able to continue later ...
              CLEAR it_hit_nodes.
              INSERT l_search_result_node_key INTO TABLE it_hit_nodes.
*             ... and select it (coding downwards!)

            WHEN cl_simple_tree_model=>find_no_match.
              MESSAGE s070.
              EXIT.
            WHEN cl_simple_tree_model=>find_canceled.
*             search dialog canceled: do nothing
              EXIT.
          ENDCASE.

        ELSE.            " fcode = 'SEARCHNEXT':
*         find next occurence,
*         doesn't matter which node has been selected:
          CALL METHOD ref_tree_model->find_next
             IMPORTING
               result_type     = l_search_result_type
               result_node_key = l_search_result_node_key.

          CASE l_search_result_type.
            WHEN cl_simple_tree_model=>find_match.
*             store hit in order to select it with the others:
              INSERT l_search_result_node_key INTO TABLE it_hit_nodes.

            WHEN cl_simple_tree_model=>find_no_match.
              MESSAGE s071(bc412).
              EXIT.
            WHEN cl_simple_tree_model=>find_canceled.
*             search dialog canceled: do nothing
              EXIT.
          ENDCASE.
        ENDIF.

*       select all hits now:
        CALL METHOD ref_tree_model->select_nodes
          EXPORTING
            node_key_table               = it_hit_nodes
           EXCEPTIONS
             OTHERS                       = 1.
        IF sy-subrc <> 0.
          MESSAGE a012(bc412).
        ENDIF.

    ENDCASE.
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.
* get application data:
  SELECT * FROM scarr
           INTO TABLE it_scarr.
  IF sy-subrc <> 0.
    MESSAGE a060.
  ENDIF.

  SELECT * FROM spfli
         INTO TABLE it_spfli.
  IF sy-subrc <> 0.
    MESSAGE a060.
  ENDIF.

  SELECT * FROM sflight
         INTO TABLE it_sflight.
  IF sy-subrc <> 0.
    MESSAGE a060.
  ENDIF.

  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI title and GUI status for screen 100.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'NORM_0100'.
  SET TITLEBAR 'TITLE_1'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_CONTAINER_PROCESSING_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Start control handling.
*       create container objects
*----------------------------------------------------------------------*
MODULE init_container_processing_0100 OUTPUT.
  IF ref_cont_left IS INITIAL.

    CREATE OBJECT ref_cont_left
      EXPORTING
        ratio                   = 35
      EXCEPTIONS
        others                  = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

    CREATE OBJECT ref_cont_split
      EXPORTING
        parent            = ref_cont_left
        rows              = 2
        columns           = 1
      EXCEPTIONS
        others            = 1.
    IF sy-subrc <> 0.
      MESSAGE a010.
    ENDIF.

* configure splitter container ...
* Easy Splitter Container unfortunately
* not able to be configurable enough:
* user should not be able to move border bar!
    CALL METHOD ref_cont_split->set_border
      EXPORTING
        border            = cl_gui_cfw=>false
      EXCEPTIONS
        OTHERS            = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_cont_split->set_row_mode
      EXPORTING
        mode              = cl_gui_splitter_container=>mode_absolute
*     IMPORTING
*       RESULT            =
      EXCEPTIONS
        OTHERS            = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_cont_split->set_row_height
      EXPORTING
        id                =  1
        height            = 23
*      IMPORTING
*        RESULT            =
      EXCEPTIONS
        OTHERS            = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_cont_split->set_row_sash
      EXPORTING
        id                =  1
        type              = cl_gui_splitter_container=>type_movable
        value             = cl_gui_splitter_container=>false
*      IMPORTING
*        RESULT            =
      EXCEPTIONS
        OTHERS            = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
**************

    ref_cell_top  = ref_cont_split->get_container( row = 1 column = 1 ).
    ref_cell_bott = ref_cont_split->get_container( row = 2 column = 1 ).

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_tree_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create tree object, link to container and fill with data
*----------------------------------------------------------------------*
MODULE init_tree_processing_0100 OUTPUT.
  IF ref_tree_model IS INITIAL.

    CREATE OBJECT ref_toolbar
      EXPORTING
        parent = ref_cell_top
      EXCEPTIONS
        others             = 4.
    IF sy-subrc <> 0.
      MESSAGE a050.
    ENDIF.

    PERFORM configure_toolbar CHANGING ref_toolbar.

    wa_event-eventid = cl_gui_toolbar=>m_id_function_selected.
    INSERT wa_event INTO TABLE it_events.
    CALL METHOD ref_toolbar->set_registered_events
      EXPORTING
        events                    = it_events
      EXCEPTIONS
        OTHERS                    = 4
            .
    IF sy-subrc <> 0.
      MESSAGE a042.
    ENDIF.

    SET HANDLER lcl_event_handler=>on_function_selected FOR ref_toolbar.

*   more than one node must be selectable in order to enable
*   search functionalities:
    CREATE OBJECT ref_tree_model
      EXPORTING
    node_selection_mode = cl_simple_tree_model=>node_sel_mode_multiple
      EXCEPTIONS
         others                      = 1.
    IF sy-subrc <> 0.
      MESSAGE a043.
    ENDIF.

    CALL METHOD ref_tree_model->create_tree_control
      EXPORTING
        parent = ref_cell_bott
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    PERFORM add_nodes USING ref_tree_model.

  ENDIF.
ENDMODULE.                 " init_tree_processing_0100  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type 'E' for screen 100.
*----------------------------------------------------------------------*
MODULE exit_command_0100 INPUT.
  CASE ok_code.
    WHEN 'CANCEL'.                     " Cancel screen processing
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.                       " Exit program
      PERFORM free_control_ressources.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                             " EXIT_COMMAND_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  COPY_OK_CODE  INPUT
*&---------------------------------------------------------------------*
*       Save the current user command in order to
*       prevent unintended field transport for the screen field ok_code
*       for next screen processing (ENTER)
*----------------------------------------------------------------------*
MODULE copy_ok_code INPUT.
  copy_ok = ok_code.
  CLEAR ok_code.
ENDMODULE.                             " COPY_FCODE  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       Implementation of user commands of type ' ' for screen 100.
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE copy_ok.
    WHEN 'BACK'.                       " Go back to program
      PERFORM free_control_ressources.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND_0100  INPUT



************************************************************************
*                                                                      *
*  F O R M   R O U T I N E S                                           *
*                                                                      *
************************************************************************

*&---------------------------------------------------------------------*
*&      Form  FREE_CONTROL_RESSOURCES
*&---------------------------------------------------------------------*
*       free control ressources on the presentation server
*       free all reference variables (ABAP object) -> garbage collector
*----------------------------------------------------------------------*
*       no interface
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD ref_cont_left->free.

  FREE:
    ref_toolbar,
    ref_tree_model,
    ref_cont_split,
    ref_cont_left.

ENDFORM.                               " FREE_CONTROL_RESSOURCES

*---------------------------------------------------------------------*
*       FORM ADD_NODES                                                *
*---------------------------------------------------------------------*
*       build up a hierarchy consisting of                            *
*       carriers, connections and flight dates                        *
*---------------------------------------------------------------------*
*  -->  L_REF_TREE_MODEL                                              *
*---------------------------------------------------------------------*
FORM add_nodes USING l_ref_tree_model TYPE REF TO cl_simple_tree_model.

  DATA:
    l_wa_node TYPE treemsnodt,
    date_text(10) TYPE c.

  l_wa_node-text = text-car.
  CALL METHOD l_ref_tree_model->add_node
    EXPORTING
      node_key                = 'ROOT'
*      RELATIVE_NODE_KEY       =
*      RELATIONSHIP            =
      isfolder                = 'X'
      text                    = l_wa_node-text
      expander                = 'X'
    EXCEPTIONS
      OTHERS                  = 5
          .
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

* scarr-nodes:
  LOOP AT it_scarr INTO wa_scarr.
    CLEAR l_wa_node.
    l_wa_node-node_key = wa_scarr-carrid.
    l_wa_node-text = wa_scarr-carrname.
    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = 'ROOT'
        relationship      = cl_simple_tree_model=>relat_last_child
        isfolder          = 'X'
        text              = l_wa_node-text
        expander          = 'X'
      EXCEPTIONS
        OTHERS            = 5
            .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
  ENDLOOP.

* spfli-nodes:
  LOOP AT it_spfli INTO wa_spfli.
    CLEAR l_wa_node.
    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                INTO l_wa_node-node_key
                SEPARATED BY space.
    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                ':'
                wa_spfli-cityfrom
                '->'
                wa_spfli-cityto
                INTO l_wa_node-text
                SEPARATED BY space.
    l_wa_node-relatkey = wa_spfli-carrid.
    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = l_wa_node-relatkey
        relationship      = cl_simple_tree_model=>relat_last_child
        isfolder          = 'X'
        text              = l_wa_node-text
        expander          = 'X'
      EXCEPTIONS
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
  ENDLOOP.

* sflight-nodes:
  LOOP AT it_sflight INTO wa_sflight.
    CLEAR l_wa_node.
    CONCATENATE wa_sflight-carrid
                wa_sflight-connid
                wa_sflight-fldate
                INTO l_wa_node-node_key
                SEPARATED BY space.
    CONCATENATE wa_sflight-carrid
                wa_sflight-connid
                INTO l_wa_node-relatkey
                SEPARATED BY space.
    WRITE wa_sflight-fldate TO date_text.
    l_wa_node-text = date_text.

    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = l_wa_node-relatkey
        relationship      = cl_simple_tree_model=>relat_last_child
        isfolder          = space
        text              = l_wa_node-text
        expander          = space
      EXCEPTIONS
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " ADD_NODES


*---------------------------------------------------------------------*
*       FORM configure_toolbar                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  P_REF_TOOLBAR                                                 *
*---------------------------------------------------------------------*
FORM configure_toolbar
     CHANGING p_ref_toolbar TYPE REF TO cl_gui_toolbar.

* print:
  CALL METHOD p_ref_toolbar->add_button
    EXPORTING
      fcode            = 'PRINT'
      icon             = icon_print
      butn_type        = cntb_btype_button
      quickinfo        = text-pri
  EXCEPTIONS
    OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

* search:
  CALL METHOD p_ref_toolbar->add_button
    EXPORTING
      fcode            = 'SEARCH'
      icon             = icon_search
      butn_type        = cntb_btype_button
      quickinfo        = text-src
  EXCEPTIONS
    OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

* search next:
  CALL METHOD p_ref_toolbar->add_button
    EXPORTING
      fcode            = 'SEARCHNEXT'
      icon             = icon_search_next
      butn_type        = cntb_btype_button
      quickinfo        = text-srn
  EXCEPTIONS
    OTHERS           = 4.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

ENDFORM.
