*----------------------------------------------------------------------*
*   INCLUDE BC412_UDCS_EXERCISE_1C01                                   *
*----------------------------------------------------------------------*

*---------------------------------------------------------------------*
*       CLASS lcl_booking DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_booking DEFINITION.
  PUBLIC SECTION.
    DATA wa_customer TYPE scustom.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS handle_expand_no_children
                  FOR EVENT expand_no_children
                  OF cl_simple_tree_model
                  IMPORTING node_key.


    CLASS-METHODS handle_ondrag FOR EVENT ondrag
                                OF cl_gui_alv_grid
                                IMPORTING
                                  e_row
                                  e_dragdropobj.

    CLASS-METHODS handle_drop FOR EVENT drop
                              OF cl_simple_tree_model
                              IMPORTING
                                node_key
                                drag_drop_object.

    CLASS-METHODS handle_node_double_click
                  FOR EVENT node_double_click
                  OF cl_simple_tree_model
                  IMPORTING
                    node_key.

ENDCLASS.


*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_expand_no_children.
    DATA:
      BEGIN OF l_wa_key_sflight_c,
        carrid(3) TYPE c,
        connid(4) TYPE n,
        fldate(8) TYPE n,
      END OF l_wa_key_sflight_c,

      l_it_sflight LIKE it_sflight,
      l_it_nodes TYPE treemsnota,
      l_wa_node  TYPE treemsnodt,
      date_text(10) TYPE c.

*   get application keys:
    CLEAR wa_sflight.

    SPLIT node_key AT c_sep INTO
          l_wa_key_sflight_c-carrid
          l_wa_key_sflight_c-connid
          l_wa_key_sflight_c-fldate.
    IF l_wa_key_sflight_c-connid CO space.
      CLEAR l_wa_key_sflight_c-connid.
    ENDIF.
    IF l_wa_key_sflight_c-fldate CO space.
      CLEAR l_wa_key_sflight_c-fldate.
    ENDIF.

    MOVE-CORRESPONDING l_wa_key_sflight_c TO wa_sflight.

*   create only sflight-notes:
    IF ( NOT wa_sflight-connid IS INITIAL
    AND  wa_sflight-fldate IS INITIAL ).

*     maybe data for sflight-nodes is already buffered:
      LOOP AT it_sflight INTO wa_sflight
                         WHERE carrid = wa_sflight-carrid
                         AND   connid = wa_sflight-connid.
        INSERT wa_sflight INTO TABLE l_it_sflight.
      ENDLOOP.
      IF sy-subrc <> 0.
*       otherwise get more sflight-data ...
        SELECT * FROM sflight
                 INTO TABLE l_it_sflight
                 WHERE carrid = wa_sflight-carrid
                 AND   connid = wa_sflight-connid.
        IF sy-subrc <> 0.
          MESSAGE a062.
        ENDIF.
*       buffer additional data:
        INSERT LINES OF l_it_sflight INTO TABLE it_sflight.
      ENDIF.

      IF l_it_sflight IS INITIAL.
*       absolutely no application data available :-(
        CALL METHOD ref_tree_model->node_set_expander
         EXPORTING
           node_key       = node_key
           expander       = space
         EXCEPTIONS
           OTHERS         = 1.
        IF sy-subrc <> 0.
          MESSAGE a012.
        ENDIF.
        EXIT.
      ENDIF.

*     and create nodes:
      LOOP AT l_it_sflight INTO wa_sflight.
        CLEAR l_wa_node.
        CONCATENATE wa_sflight-carrid
                    wa_sflight-connid
                    wa_sflight-fldate
                    INTO l_wa_node-node_key
                    SEPARATED BY c_sep.
        CONCATENATE wa_sflight-carrid
                    wa_sflight-connid
                    INTO l_wa_node-relatkey
                    SEPARATED BY c_sep.
        l_wa_node-relatship  = cl_simple_tree_model=>relat_last_child.
        l_wa_node-isfolder   = 'X'.
        l_wa_node-expander   = space.
*       drop booking should only be possible for flight date nodes:
        l_wa_node-dragdropid = handle_trg.
        WRITE wa_sflight-fldate TO date_text.
        l_wa_node-text = date_text.
        INSERT l_wa_node INTO TABLE l_it_nodes.
      ENDLOOP.

      CALL METHOD ref_tree_model->add_nodes
        EXPORTING
          node_table          = l_it_nodes
        EXCEPTIONS
          OTHERS              = 1.
      IF sy-subrc <> 0.
        MESSAGE a012.
      ENDIF.

*     expand the node:
      CALL METHOD ref_tree_model->expand_node
        EXPORTING
          node_key = node_key.

    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------
  METHOD handle_ondrag.
    DATA l_ref_booking TYPE REF TO lcl_booking.

    CREATE OBJECT l_ref_booking.
    READ TABLE it_scustom INTO l_ref_booking->wa_customer
                          INDEX e_row-index.
    e_dragdropobj->object = l_ref_booking.
  ENDMETHOD.

*---------------------------------------------------------------------
  METHOD handle_drop.
    DATA:
      l_ref_booking TYPE REF TO lcl_booking,
      l_wa_newnode TYPE treemsnodt.

    CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
      l_ref_booking ?= drag_drop_object->object.
    ENDCATCH.

    IF sy-subrc = 0.
*       create new booking node,
*       due to didactical reasons just take sy-datum and sy-uzeit
*       as node key here, begin with them to make separation easier
*
*       correct solution would be:
*       get number from number range intervall (->BC414)
      CONCATENATE sy-datum sy-uzeit
                  node_key               "imported!
                  l_ref_booking->wa_customer-id
                  INTO l_wa_newnode-node_key
                  SEPARATED BY c_sep.

      CALL METHOD ref_tree_model->add_node
        EXPORTING
          node_key          = l_wa_newnode-node_key
          relative_node_key = node_key       "imported!
          relationship      = cl_simple_tree_model=>relat_last_child
          isfolder          = space
          text              = l_wa_newnode-node_key
        EXCEPTIONS
          OTHERS            = 1.
      IF sy-subrc <> 0.
        CALL METHOD drag_drop_object->abort.
      ENDIF.

*     buffer new node for undo functionality:
      undo_node_key = l_wa_newnode-node_key.

*     of course new booking would have to be stored in table SBOOK now
*     left out here due to didactical reasons
*     ...

*     expand the parent node:
      CALL METHOD ref_tree_model->expand_node
        EXPORTING
          node_key = node_key.

    ELSE.
      CALL METHOD drag_drop_object->abort.
    ENDIF.

  ENDMETHOD.

*---------------------------------------------------------------------
  METHOD handle_node_double_click.
    DATA:
      BEGIN OF l_wa_key_sbook_c,
        carrid(3)   TYPE c,
        connid(4)   TYPE n,
        fldate(8)   TYPE n,
*       bookid(8)   TYPE n, left out for didactical reason
        customid(8) TYPE n,
      END OF l_wa_key_sbook_c.

    CLEAR wa_sbook.

* separate sy-datum and sy-uzeit first:
    DO 2 TIMES.
      SEARCH node_key FOR c_sep.
      SHIFT node_key BY sy-fdpos PLACES.
      SHIFT node_key.
    ENDDO.

    SPLIT node_key AT c_sep INTO
          l_wa_key_sbook_c-carrid
          l_wa_key_sbook_c-connid
          l_wa_key_sbook_c-fldate
          l_wa_key_sbook_c-customid.

    IF l_wa_key_sbook_c-connid CO space.
      CLEAR l_wa_key_sbook_c-connid.
    ENDIF.
    IF l_wa_key_sbook_c-fldate CO space.
      CLEAR l_wa_key_sbook_c-fldate.
    ENDIF.
    IF l_wa_key_sbook_c-customid CO space.
      CLEAR l_wa_key_sbook_c-customid.
    ENDIF.

    MOVE-CORRESPONDING l_wa_key_sbook_c TO wa_sbook.

*   display only booking data:
    IF NOT wa_sbook-customid IS INITIAL.
      READ TABLE it_scustom INTO wa_scustom
                            WITH TABLE KEY id = wa_sbook-customid.
      IF sy-subrc <> 0.
        SELECT SINGLE * FROM scustom INTO wa_scustom
                        WHERE id = wa_sbook-customid.
        IF sy-subrc <> 0.
          MESSAGE i064.
          EXIT.
        ENDIF.
      ENDIF.
      CALL SCREEN 200 STARTING AT  50  5
                      ENDING   AT 130 30.

    ELSE.
      EXIT.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
