*----------------------------------------------------------------------*
***INCLUDE BC412_UDCS_EXERCISE_1O01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  status_0100  OUTPUT
*&---------------------------------------------------------------------*
*       set GUI for screen 0100
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_NORM_0100'.
  SET TITLEBAR 'TITLE_NORM_0100'.
ENDMODULE.                 " status_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_container_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create screen "frames"
*----------------------------------------------------------------------*
MODULE init_container_processing_0100 OUTPUT.
  IF ref_cont_left IS INITIAL.

    CREATE OBJECT ref_cont_right
      EXPORTING
        ratio     = 41
        side      = cl_gui_docking_container=>dock_at_right
      EXCEPTIONS
        others                  = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

    CREATE OBJECT ref_cont_left
      EXPORTING
        ratio     = 90
        side      = cl_gui_docking_container=>dock_at_bottom
      EXCEPTIONS
        others                  = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_container_processing_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_dragdrop_processing_0100  OUTPUT
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

ENDMODULE.                 " init_dragdrop_processing_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  init_alv_processing_0100  OUTPUT
*&---------------------------------------------------------------------*
*       create alv object, link to container and fill with data
*----------------------------------------------------------------------*
MODULE init_alv_processing_0100 OUTPUT.
  IF ref_alv IS INITIAL. " first screen processing

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

*   get content for first display:
    SELECT * FROM scustom
             INTO TABLE it_scustom
             WHERE id IN so_cust.
    IF sy-subrc <> 0.
      MESSAGE a060.
    ENDIF.

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

  ELSE.
*   refresh grid if new customers are selected:
    IF so_cust[] <> set_cust_old.
      SELECT * FROM scustom
               INTO TABLE it_scustom
               WHERE id IN so_cust.
      IF sy-subrc = 0.
        MOVE so_cust[] TO set_cust_old.
      ELSE.
        MESSAGE i064.
      ENDIF.

      CALL METHOD ref_alv->refresh_table_display
        EXCEPTIONS
          OTHERS        = 2
              .
      IF sy-subrc <> 0.
        MESSAGE a012.
      ENDIF.
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
        parent                       = ref_cont_right
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
      lcl_event_handler=>handle_expand_no_children FOR ref_tree_model,
      lcl_event_handler=>handle_drop FOR ref_tree_model,
      lcl_event_handler=>handle_node_double_click FOR ref_tree_model.

    wa_event-eventid = cl_simple_tree_model=>eventid_node_double_click.
    INSERT wa_event INTO TABLE it_events.
*   Tree Model Instance sets filter for event EXPAND_NO_CHILDREN!
    CALL METHOD ref_tree_model->set_registered_events
      EXPORTING
        events                    = it_events
      EXCEPTIONS
        OTHERS                    = 1.
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

  ENDIF.
ENDMODULE.                 " init_tree_processing_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       for the ABAP list
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
  SET PF-STATUS space.
  SET TITLEBAR 'LIST'.
ENDMODULE.                 " STATUS_0200  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  create_list_0200  OUTPUT
*&---------------------------------------------------------------------*
*       creates the itenarary
*----------------------------------------------------------------------*
MODULE create_list_0200 OUTPUT.
  SUPPRESS DIALOG.
  LEAVE TO LIST-PROCESSING AND RETURN TO SCREEN 0.

* customer name:
  WRITE: /
    text-hdr COLOR COL_HEADING,
    wa_scustom-form COLOR COL_HEADING,
    wa_scustom-name COLOR COL_HEADING.
  ULINE.
  SKIP.

* connection data:
  READ TABLE it_spfli INTO wa_spfli
             WITH TABLE KEY carrid = wa_sbook-carrid
                            connid = wa_sbook-connid.
  IF sy-subrc = 0.
    WRITE: /
      text-fli,
      wa_spfli-carrid,
      wa_spfli-connid.

    SKIP.

    READ TABLE it_sflight INTO wa_sflight
               WITH TABLE KEY carrid = wa_sbook-carrid
                              connid = wa_sbook-connid
                              fldate = wa_sbook-fldate.
    IF sy-subrc = 0.
      WRITE: /
        text-dep,
        wa_sflight-fldate,
        wa_spfli-deptime,
        wa_spfli-airpfrom.

      arr_date = wa_sflight-fldate + wa_spfli-period.

      SKIP.
      WRITE: /
        text-arr,
        arr_date,
      wa_spfli-arrtime,
      wa_spfli-airpto.

    ELSE.
      EXIT.
    ENDIF.
  ELSE.
    EXIT.
  ENDIF.

ENDMODULE.                 " create_list_0200  OUTPUT
