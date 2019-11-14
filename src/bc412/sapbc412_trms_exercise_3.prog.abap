*&---------------------------------------------------------------------*
*& SAPBC412_TRMS_EXERCISE_3                                            *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Model solution for the third exercise of unit 'TREE Control'        *
*& of classroom training BC412.                                        *
*& The program displays SCARR, SPFLI and SFLIGHT data                  *
*& using an Column Tree Model.                                         *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_trms_exercise_3 MESSAGE-ID bc412.

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

* content:
  ref_tree_model TYPE REF TO cl_column_tree_model,

* auxiliary:
  wa_hier_header TYPE treemhhdr.



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
*       create container object
*----------------------------------------------------------------------*
MODULE init_container_processing_0100 OUTPUT.
  IF ref_cont_left IS INITIAL.

    CREATE OBJECT ref_cont_left
      EXPORTING
        ratio                   = 75
      EXCEPTIONS
        others                  = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_tree_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create tree object, link to container and fill with data
*----------------------------------------------------------------------*
MODULE init_tree_processing_0100 OUTPUT.
  IF ref_tree_model IS INITIAL.

    wa_hier_header-t_image = icon_ws_plane.
    wa_hier_header-heading = text-hir.
    wa_hier_header-width   = 65.
    CREATE OBJECT ref_tree_model
      EXPORTING
       node_selection_mode = cl_column_tree_model=>node_sel_mode_single
       hierarchy_column_name = 'HIER'
       hierarchy_header       = wa_hier_header
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
      MESSAGE a042.
    ENDIF.

    PERFORM add_columns USING ref_tree_model.
    PERFORM add_nodes   USING ref_tree_model.

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
  CALL METHOD:
    ref_cont_left->free.

  FREE:
    ref_tree_model,
    ref_cont_left.

ENDFORM.                               " FREE_CONTROL_RESSOURCES


*---------------------------------------------------------------------*
*       FORM add_columns                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  L_REF_TREE_MODEL                                              *
*---------------------------------------------------------------------*
FORM add_columns USING l_ref_tree_model
                          TYPE REF TO cl_column_tree_model.

  CALL METHOD l_ref_tree_model->add_column
    EXPORTING
      name                = 'PRICE'
      width               = 40
      header_text         = text-pri
     EXCEPTIONS
       OTHERS              = 1.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

  CALL METHOD l_ref_tree_model->add_column
    EXPORTING
      name                = 'CURRENCY'
      width               = 10
      header_text         = text-cur
     EXCEPTIONS
       OTHERS              = 1.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

  CALL METHOD l_ref_tree_model->add_column
  EXPORTING
    name                = 'PLANETYPE'
    width               = 20
    header_text         = text-pty
   EXCEPTIONS
     OTHERS              = 1.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

  CALL METHOD l_ref_tree_model->add_column
  EXPORTING
    name                = 'SEATSFREE'
    width               = 20
    header_text         = text-fre
   EXCEPTIONS
     OTHERS              = 1.
  IF sy-subrc <> 0.
    MESSAGE a012.
  ENDIF.

ENDFORM.

*---------------------------------------------------------------------*
*       FORM ADD_NODES                                                *
*---------------------------------------------------------------------*
*       build up a hierarchy consisting of                            *
*       carriers, connections and                                     *
*       flight dates with additional data                             *
*                                                                     *
*---------------------------------------------------------------------*
*  -->  L_REF_TREE_MODEL                                              *
*---------------------------------------------------------------------*
FORM add_nodes USING l_ref_tree_model TYPE REF TO cl_column_tree_model.

  DATA:
    l_wa_node  TYPE treemcnodt,
    l_it_items TYPE treemcitab,

    l_conn_text(40)  TYPE c,
    l_date_text(10)  TYPE c,
    l_price_text(20) TYPE c,
    l_seats_text(10) TYPE c.

  PERFORM fill_itemtab
              USING
                 text-car
                 space
                 space
                 space
                 space
              CHANGING
                 l_it_items.

  CALL METHOD l_ref_tree_model->add_node
    EXPORTING
      node_key                = 'ROOT'
*      RELATIVE_NODE_KEY       =
*      RELATIONSHIP            =
      isfolder                = 'X'
      expander                = 'X'
      item_table              = l_it_items
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

    PERFORM fill_itemtab
                USING
                   wa_scarr-carrname
                   space
                   space
                   space
                   space
                CHANGING
                   l_it_items.

    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = 'ROOT'
        relationship      = cl_column_tree_model=>relat_last_child
        isfolder          = 'X'
        expander          = 'X'
        item_table        = l_it_items
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
    l_wa_node-relatkey = wa_spfli-carrid.

    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                ':'
                wa_spfli-cityfrom
                '->'
                wa_spfli-cityto
                INTO l_conn_text
                SEPARATED BY space.
    PERFORM fill_itemtab
                USING
                   l_conn_text
                   space
                   space
                   space
                   space
                CHANGING
                   l_it_items.

    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = l_wa_node-relatkey
        relationship      = cl_column_tree_model=>relat_last_child
        isfolder          = 'X'
        expander          = 'X'
        item_table        = l_it_items
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

    WRITE wa_sflight-fldate TO l_date_text.
    WRITE wa_sflight-price TO l_price_text
                           CURRENCY wa_sflight-currency.
    IF wa_sflight-seatsmax >= wa_sflight-seatsocc.
      l_seats_text = wa_sflight-seatsmax - wa_sflight-seatsocc.
    ELSE.
      MESSAGE a075.
    ENDIF.
    PERFORM fill_itemtab
                USING
                   l_date_text
                   l_price_text
                   wa_sflight-currency
                   wa_sflight-planetype
                   l_seats_text
                CHANGING
                   l_it_items.

    CALL METHOD l_ref_tree_model->add_node
      EXPORTING
        node_key          = l_wa_node-node_key
        relative_node_key = l_wa_node-relatkey
        relationship      = cl_column_tree_model=>relat_last_child
        isfolder          = space
        expander          = space
        item_table        = l_it_items
      EXCEPTIONS
        OTHERS            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
  ENDLOOP.

ENDFORM.                               " ADD_NODES

*---------------------------------------------------------------------*
*       FORM fill_itemtab                                             *
*---------------------------------------------------------------------*
*       adds one line into the item table for each column of the tree *
*---------------------------------------------------------------------*
*  -->  P_IT_ITEMS                                                    *
*---------------------------------------------------------------------*
FORM fill_itemtab USING    p_hier_text  TYPE c
                           p_price_text TYPE c
                           p_curr_text  TYPE c
                           p_plane_text TYPE c
                           p_free_text  TYPE c
                  CHANGING p_it_items TYPE treemcitab.

  DATA l_wa_item LIKE LINE OF p_it_items.

  CLEAR p_it_items.
  l_wa_item-class     = cl_column_tree_model=>item_class_text.

  l_wa_item-item_name = 'HIER'.
  l_wa_item-text      = p_hier_text.
  INSERT l_wa_item INTO TABLE p_it_items.

  l_wa_item-item_name = 'PRICE'.
  l_wa_item-text      = p_price_text.
  INSERT l_wa_item INTO TABLE p_it_items.

  l_wa_item-item_name = 'CURRENCY'.
  l_wa_item-text      = p_curr_text.
  INSERT l_wa_item INTO TABLE p_it_items.

  l_wa_item-item_name = 'PLANETYPE'.
  l_wa_item-text      = p_plane_text.
  INSERT l_wa_item INTO TABLE p_it_items.

  l_wa_item-item_name = 'SEATSFREE'.
  l_wa_item-text      = p_free_text.
  INSERT l_wa_item INTO TABLE p_it_items.

ENDFORM.
