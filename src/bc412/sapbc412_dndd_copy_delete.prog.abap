*&---------------------------------------------------------------------*
*& Report  SAPBC412_DNDD_COPY_DELETE                                   *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& Demo program for Drag&Drop functionality between a SAP Grid Control,*
*& a Simple Tree Control and a Picture Control                         *
*&                                                                     *
*& user should press <Ctrl> + left mouse button to drag one customer   *
*& and drop into the booking tree                                      *
*&                                                                     *
*& user should press only left mouse button to drag one booking        *
*& and drop into the recycle bin                                       *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_dndd_copy_delete MESSAGE-ID bc412.

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
  it_scustom TYPE STANDARD TABLE OF scustom
             WITH NON-UNIQUE KEY id,

  wa_scarr LIKE LINE OF it_scarr,
  wa_spfli LIKE LINE OF it_spfli,
  wa_sflight LIKE LINE OF it_sflight,
  wa_scustom LIKE LINE OF it_scustom,

* container:
  ref_cont_left   TYPE REF TO cl_gui_docking_container,
  ref_cont_center TYPE REF TO cl_gui_docking_container,
  ref_cont_right  TYPE REF TO cl_gui_docking_container,

* content:
  ref_bin_pic    TYPE REF TO cl_gui_picture,
  ref_alv        TYPE REF TO cl_gui_alv_grid,
  ref_tree_model TYPE REF TO cl_simple_tree_model,

* note table for tree:
  it_nodes TYPE treemsnota,

* to set filter for picture-d&d-events:
  it_events TYPE cntl_simple_events,

* drag&drop-specific:
  wa_layout TYPE lvc_s_layo,

  ref_flav_src TYPE REF TO cl_dragdrop,
  ref_flav_trg TYPE REF TO cl_dragdrop,

  handle_src TYPE i,
  handle_trg TYPE i.


*---------------------------------------------------------------------*
*       CLASS lcl_booking DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_booking DEFINITION.
  PUBLIC SECTION.
    DATA:
      wa_customer TYPE scustom,
      wa_node     TYPE treemsnodt.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
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

    CLASS-METHODS handle_drag FOR EVENT drag
                              OF cl_simple_tree_model
                              IMPORTING
                                node_key
                                drag_drop_object.

    CLASS-METHODS handle_drop_complete FOR EVENT drop_complete
                                       OF cl_simple_tree_model
                                       IMPORTING
                                         node_key
                                         drag_drop_object.

ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

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

    IF drag_drop_object->flavor = 'BOOK'.
      CATCH SYSTEM-EXCEPTIONS move_cast_error = 1.
        l_ref_booking ?= drag_drop_object->object.
      ENDCATCH.

      IF sy-subrc = 0.
*       create new booking node,
*       due to didactical reasons just take sy-datum and sy-uzeit
*       as node key here
*
*       correct solution would be:
*       get number from number range intervall (->BC414)
        CONCATENATE sy-datum sy-uzeit
                    INTO l_wa_newnode-node_key
                    SEPARATED BY space.

        CONCATENATE l_wa_newnode-node_key
                    l_ref_booking->wa_customer-id
                    INTO l_wa_newnode-text
                    SEPARATED BY space.

*     drag to cancel should only be possible for booking nodes:
        CALL METHOD ref_tree_model->add_node
          EXPORTING
            node_key          = l_wa_newnode-node_key
            relative_node_key = node_key       "imported!
            relationship      = cl_simple_tree_model=>relat_last_child
            isfolder          = space
            text              = l_wa_newnode-text
            drag_drop_id      = handle_src
          EXCEPTIONS
            OTHERS            = 1.
        IF sy-subrc <> 0.
          CALL METHOD drag_drop_object->abort.
        ENDIF.

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
    ELSE.
      MESSAGE i100 WITH text-bok.
      CALL METHOD drag_drop_object->abort.
    ENDIF.
  ENDMETHOD.

*---------------------------------------------------------------------
  METHOD handle_drag.
* something should be done somewhere else with such a node
* so: transport data again:
    DATA l_ref_booking TYPE REF TO lcl_booking.

    CREATE OBJECT l_ref_booking.
*   fill l_ref_booking ...
    drag_drop_object->object = l_ref_booking.
  ENDMETHOD.

*---------------------------------------------------------------------
  METHOD handle_drop_complete.
    IF drag_drop_object->flavor = 'CANC'.

      CALL METHOD ref_tree_model->delete_node
        EXPORTING
          node_key = node_key. "imported!

*   here no further actions necessary due to didactical reasons
*   (not stored in data base)
*   for complete version work as seen above:
*   get application key and delete data set from table SBOOK
*   ...

    ELSE.
      MESSAGE i100 WITH text-del.
      CALL METHOD drag_drop_object->abort.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
*---------------------------------------------------------------------

SELECT-OPTIONS so_cust FOR wa_scustom-id.



***********************************************************************
*                                                                     *
*    M A I N    P R O G R A M                                         *
*                                                                     *
***********************************************************************
LOAD-OF-PROGRAM.
* default values for select-option:
  so_cust-low    = 1.
  so_cust-high   = 100.
  so_cust-sign   = 'I'.
  so_cust-option = 'BT'.
  APPEND so_cust.



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

  SELECT * FROM scustom
       INTO TABLE it_scustom
       WHERE id IN so_cust.
  IF sy-subrc <> 0.
    MESSAGE a060.
  ENDIF.



  CALL SCREEN 100.


************************************************************************
*                                                                      *
*  M O D U L E S   U S E D   B Y   S C R E E N   1 0 0                 *
*                                                                      *
************************************************************************

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
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
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

    CREATE OBJECT ref_cont_center
      EXPORTING
        ratio                   = 25
      EXCEPTIONS
        others                  = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

    CREATE OBJECT ref_cont_right
      EXPORTING
        ratio                   = 40
      EXCEPTIONS
        others                  = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_dragdrop_0100  OUTPUT
*&---------------------------------------------------------------------*
*       creates flavor tables and retrieves handles to them
*----------------------------------------------------------------------*
MODULE init_dragdrop_processing_0100 OUTPUT.
  IF ref_flav_src IS INITIAL.

    CREATE OBJECT:
      ref_flav_src,
      ref_flav_trg.

    CALL METHOD ref_flav_src->add
      EXPORTING
        flavor          = 'BOOK'
        dragsrc         = 'X'
        droptarget      = space
        effect          = cl_dragdrop=>copy
        effect_in_ctrl  = cl_dragdrop=>none
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_src->add
      EXPORTING
        flavor          = 'CANC'
        dragsrc         = 'X'
        droptarget      = space
        effect          = cl_dragdrop=>move
        effect_in_ctrl  = cl_dragdrop=>none
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_trg->add
      EXPORTING
        flavor          = 'BOOK'
        dragsrc         = space
        droptarget      = 'X'
        effect          = cl_dragdrop=>copy
        effect_in_ctrl  = cl_dragdrop=>none
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_trg->add
      EXPORTING
        flavor          = 'CANC'
        dragsrc         = space
        droptarget      = 'X'
        effect          = cl_dragdrop=>move
        effect_in_ctrl  = cl_dragdrop=>none
      EXCEPTIONS
        OTHERS          = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_src->get_handle
      IMPORTING
        handle      = handle_src
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_flav_trg->get_handle
      IMPORTING
        handle      = handle_trg
      EXCEPTIONS
        OTHERS      = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_dragdrop_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_picture_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create picture object and link to container
*----------------------------------------------------------------------*
MODULE init_picture_processing_0100 OUTPUT.
  IF ref_bin_pic IS INITIAL.

    CREATE OBJECT ref_bin_pic
      EXPORTING
        parent = ref_cont_right
      EXCEPTIONS
        others = 1
        .
    IF sy-subrc <> 0.
      MESSAGE a011.
    ENDIF.

    CALL METHOD ref_bin_pic->load_picture_from_sap_icons
      EXPORTING
        icon   = icon_delete
      EXCEPTIONS
        OTHERS = 1
          .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

*   assign d&d-handle for picture and its control:
    CALL METHOD ref_bin_pic->set_dragdrop_picture
      EXPORTING
        dragdrop = ref_flav_trg
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    CALL METHOD ref_bin_pic->set_dragdrop_control
      EXPORTING
        dragdrop = ref_flav_trg
      EXCEPTIONS
        OTHERS
        = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

*   set filter for d&d events implicitly:
    CALL METHOD ref_bin_pic->set_registered_events
      EXPORTING
        events                    = it_events " can be initial here!!!
      EXCEPTIONS
        OTHERS                    = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_picture_processing_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_alv_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create alv object, link to container and fill with data
*----------------------------------------------------------------------*
MODULE init_alv_processing_0100 OUTPUT.
  IF ref_alv IS INITIAL.

    CREATE OBJECT ref_alv
      EXPORTING
        i_parent          = ref_cont_left
      EXCEPTIONS
        others            = 5
        .
    IF sy-subrc <> 0.
      MESSAGE a045.
    ENDIF.

    SET HANDLER lcl_event_handler=>handle_ondrag FOR ref_alv.

*   assign d&d-handle:
    wa_layout-s_dragdrop-row_ddid = handle_src.

    CALL METHOD ref_alv->set_table_for_first_display
      EXPORTING
        i_structure_name              = 'SCUSTOM'
        is_layout                     = wa_layout
      CHANGING
        it_outtab                     = it_scustom
      EXCEPTIONS
        OTHERS                        = 4
            .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_alv_processing_0100  OUTPUT

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
        parent                       = ref_cont_center
      EXCEPTIONS
        OTHERS                       = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

*   other implementation here than in unit "Tree Control":
    PERFORM create_node_table CHANGING it_nodes.

    CALL METHOD ref_tree_model->add_nodes
      EXPORTING
        node_table          = it_nodes
      EXCEPTIONS
        OTHERS              = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.
    CLEAR it_nodes. "not needed any more!

    SET HANDLER:
      lcl_event_handler=>handle_drop          FOR ref_tree_model,
      lcl_event_handler=>handle_drag          FOR ref_tree_model,
      lcl_event_handler=>handle_drop_complete FOR ref_tree_model.

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
    ref_cont_left->free,
    ref_cont_center->free,
    ref_cont_right->free.

  FREE:
    ref_bin_pic,
    ref_tree_model,
    ref_alv,

    ref_cont_left,
    ref_cont_center,
    ref_cont_right.
ENDFORM.                               " FREE_CONTROL_RESSOURCES

*---------------------------------------------------------------------*
*       FORM create_node_table                                        *
*---------------------------------------------------------------------*
*       build up a hierarchy consisting of                            *
*       carriers, connections and flight dates                        *
*---------------------------------------------------------------------*
*  -->  P_IT_NODES                                                    *
*---------------------------------------------------------------------*
FORM create_node_table CHANGING p_it_nodes LIKE it_nodes.

  DATA:
    l_wa_node LIKE LINE OF p_it_nodes,
    date_text(10) TYPE c.

  l_wa_node-node_key   = 'ROOT'.
  l_wa_node-isfolder   = 'X'.
  l_wa_node-expander   = space.
  l_wa_node-text       = text-car.
  INSERT l_wa_node INTO TABLE p_it_nodes.

* scarr-nodes:
  CLEAR l_wa_node.
  LOOP AT it_scarr INTO wa_scarr.
    CLEAR l_wa_node.
    l_wa_node-node_key   = wa_scarr-carrid.
    l_wa_node-relatkey   = 'ROOT'.
    l_wa_node-relatship  = cl_simple_tree_model=>relat_last_child.
    l_wa_node-isfolder   = 'X'.
    l_wa_node-expander   = space.
    l_wa_node-text       = wa_scarr-carrname.
    INSERT l_wa_node INTO TABLE p_it_nodes.
  ENDLOOP.

* spfli-nodes:
  CLEAR l_wa_node.
  LOOP AT it_spfli INTO wa_spfli.
    CLEAR l_wa_node.
    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                INTO l_wa_node-node_key
                SEPARATED BY space.
    l_wa_node-relatkey   = wa_spfli-carrid.
    l_wa_node-relatship  = cl_simple_tree_model=>relat_last_child.
    l_wa_node-isfolder   = 'X'.
    l_wa_node-expander   = space.
    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                ':'
                wa_spfli-cityfrom
                '->'
                wa_spfli-cityto
                INTO l_wa_node-text
                SEPARATED BY space.
    INSERT l_wa_node INTO TABLE p_it_nodes.
  ENDLOOP.

* sflight-nodes:
  CLEAR l_wa_node.
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
    l_wa_node-relatship  = cl_simple_tree_model=>relat_last_child.
    l_wa_node-isfolder   = 'X'.
    l_wa_node-expander   = space.
*   drop booking should only be possible for flight date nodes:
    l_wa_node-dragdropid = handle_trg.
    WRITE wa_sflight-fldate TO date_text DD/MM/YYYY.
    l_wa_node-text = date_text.
    INSERT l_wa_node INTO TABLE p_it_nodes.
  ENDLOOP.

ENDFORM.                               " CREATE_NODE_TABLE
