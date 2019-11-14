*&---------------------------------------------------------------------*
*& SAPBC412_DNDS_EXERCISE_1                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Model solution for the first exercise of unit                       *
*& 'Drag&Drop Functionality 'of classroom training BC412.              *
*&                                                                     *
*& The program displays SCARR, SPFLI and SFLIGHT data                  *
*& using an Simple Tree Model.                                         *
*& The user can "drag" flight date nodes and "drop" them into          *
*& the "favorites" folder.                                             *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc412_dnds_exercise_1 MESSAGE-ID bc412.

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
  ref_cont_left TYPE REF TO cl_gui_docking_container,

* content:
  ref_tree_model TYPE REF TO cl_simple_tree_model,

* drag&drop-specific:
  ref_flav_src TYPE REF TO cl_dragdrop,
  ref_flav_trg TYPE REF TO cl_dragdrop,

  handle_flav_src TYPE i,
  handle_flav_trg TYPE i.

*---------------------------------------------------------------------*
*       CLASS lcl_flightdate DEFINITION
*---------------------------------------------------------------------*
*       contains only instance attributes for data transportation     *
*       between drag&drop objects                                     *
*---------------------------------------------------------------------*
CLASS lcl_flightdate DEFINITION.
  PUBLIC SECTION.
    DATA wa_node TYPE treemsnodt.
ENDCLASS.


*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       contains event handler methods for darg&drop processing       *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS handle_drag FOR EVENT drag
                              OF cl_simple_tree_model
                              IMPORTING
                                sender
                                node_key
                                drag_drop_object.

    CLASS-METHODS handle_drop FOR EVENT drop
                              OF cl_simple_tree_model
                              IMPORTING
                                sender
                                node_key
                                drag_drop_object.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_drag.
    DATA l_ref_flightdate TYPE REF TO lcl_flightdate.

    CREATE OBJECT l_ref_flightdate.

    CALL METHOD sender->node_get_properties
      EXPORTING
        node_key       = node_key
      IMPORTING
        properties     = l_ref_flightdate->wa_node
      EXCEPTIONS
        OTHERS         = 2
            .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    l_ref_flightdate->wa_node-node_key = node_key.
    drag_drop_object->object = l_ref_flightdate.
  ENDMETHOD.

*--------------------------------------------------------------------
  METHOD handle_drop.
    DATA:
      l_ref_flightdate TYPE REF TO lcl_flightdate,
      l_wa_newnode TYPE treemsnodt.

    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
      l_ref_flightdate ?= drag_drop_object->object.
    ENDCATCH.
    IF sy-subrc = 0.
      l_wa_newnode = l_ref_flightdate->wa_node.
      CONCATENATE text-fli l_wa_newnode-node_key
                  INTO l_wa_newnode-text
                  SEPARATED BY space.
      CONCATENATE sy-datum sy-uzeit
                  l_wa_newnode-node_key
                  INTO l_wa_newnode-node_key
                  SEPARATED BY space.

      CALL METHOD ref_tree_model->add_node
        EXPORTING
          node_key          = l_wa_newnode-node_key
          relative_node_key = node_key
          relationship      = cl_simple_tree_model=>relat_last_child
          isfolder          = space
          text              = l_wa_newnode-text
        EXCEPTIONS
          OTHERS            = 1.
      IF sy-subrc <> 0.
        CALL METHOD drag_drop_object->abort.
      ENDIF.

      CALL METHOD ref_tree_model->expand_node
        EXPORTING
          node_key = 'FAV'.
    ELSE.
      CALL METHOD drag_drop_object->abort.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
*--------------------------------------------------------------------




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
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Set GUI title and GUI status for screen 100.
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'NORM_0100'.
  SET TITLEBAR 'TITLE_1'.
ENDMODULE.                             " status_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_container_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       Start control handling,
*       create container object
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

  ENDIF.
ENDMODULE.                     " init_container_processing_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_dragdrop_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       build up flavor tables and get handles to them
*----------------------------------------------------------------------*
MODULE init_dragdrop_processing_0100 OUTPUT.
  IF ref_flav_src IS INITIAL.

    CREATE OBJECT:
       ref_flav_src,
       ref_flav_trg.

    CALL METHOD ref_flav_src->add
      EXPORTING
        flavor          = 'FAV'
        dragsrc         = 'X'
        droptarget      = space
        effect          = cl_dragdrop=>copy
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_trg->add
      EXPORTING
        flavor          = 'FAV'
        dragsrc         = space
        droptarget      = 'X'
        effect          = cl_dragdrop=>copy
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_src->get_handle
      IMPORTING
        handle      = handle_flav_src
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_trg->get_handle
      IMPORTING
        handle      = handle_flav_trg
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_dragdrop_processing_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_tree_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create tree object, link to container and fill with data
*----------------------------------------------------------------------*
MODULE init_tree_processing_0100 OUTPUT.
  IF ref_tree_model IS INITIAL.

    CREATE OBJECT ref_tree_model
      EXPORTING
       node_selection_mode = cl_simple_tree_model=>node_sel_mode_single
      EXCEPTIONS
         others                      = 1.
    IF sy-subrc <> 0.
      MESSAGE a043.
    ENDIF.

    CALL METHOD ref_tree_model->create_tree_control
      EXPORTING
        parent                       = ref_cont_left
      EXCEPTIONS
        OTHERS                       = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    PERFORM add_nodes USING ref_tree_model.

    SET HANDLER:
      lcl_event_handler=>handle_drag FOR ref_tree_model,
      lcl_event_handler=>handle_drop FOR ref_tree_model.

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
ENDMODULE.                             " COPY_OK_CODE  INPUT

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
  CALL METHOD:
    ref_cont_left->free.

  FREE:
    ref_tree_model,
    ref_cont_left,

    ref_flav_src,
    ref_flav_trg.

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

* this node should be a drop-target
  CLEAR l_wa_node.
  l_wa_node-text       = text-fav.
  CALL METHOD l_ref_tree_model->add_node
    EXPORTING
      node_key                = 'FAV'
*      RELATIVE_NODE_KEY       =
*      RELATIONSHIP            =
      isfolder                = 'X'
      text                    = l_wa_node-text
      expander                = 'X'
      drag_drop_id            = handle_flav_trg
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
*   flight date nodes should be able to be dragged:
    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = l_wa_node-relatkey
        relationship      = cl_simple_tree_model=>relat_last_child
        isfolder          = space
        text              = l_wa_node-text
*        expander          =
      drag_drop_id            = handle_flav_src
      EXCEPTIONS
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " ADD_NODES
