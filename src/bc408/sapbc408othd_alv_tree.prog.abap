*&---------------------------------------------------------------------
*& Report  SAPBC408OTHD_ALV_TREE                                       *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc408othd_alv_tree.
NODES: spfli, sflight.
DATA: wa_sflight TYPE sflight,
      it_sflight LIKE TABLE OF wa_sflight,
      wa_spfli TYPE spfli,
      it_spfli TYPE TABLE OF spfli,
      ok_code TYPE sy-ucomm.

DATA: alv_tree TYPE REF TO cl_gui_alv_tree,
      cont TYPE REF TO cl_gui_custom_container.
DATA  hierarchy_header TYPE treev_hhdr.

DATA: BEGIN OF t_node,
        tree_id TYPE lvc_nkey,
        parent_id TYPE lvc_nkey,
        mandt TYPE sy-mandt,
        carrid TYPE spfli-carrid,
        connid TYPE spfli-connid,
        attributes(100),
      END OF t_node.

DATA: it_tab LIKE TABLE OF t_node,
      it_outtab LIKE TABLE OF t_node.

DATA: seqnr TYPE i,
      parent TYPE lvc_nkey.

DATA: node_text type lvc_value.
DATA: fieldcatalog TYPE lvc_t_fcat.

START-OF-SELECTION.

GET spfli.
  CLEAR t_node.
  ADD 1 TO seqnr.
  t_node-tree_id = seqnr.
  parent = t_node-tree_id.
  MOVE-CORRESPONDING spfli TO t_node.

  WRITE: spfli-airpfrom TO t_node-attributes,
        spfli-airpto TO t_node-attributes+4,
        spfli-fltime TO t_node-attributes+8,
        spfli-deptime TO t_node-attributes+19.


  APPEND t_node TO it_tab.

GET sflight.
  CLEAR t_node.
  ADD 1 TO seqnr.
  t_node-tree_id = seqnr.
  t_node-parent_id = parent.
  MOVE-CORRESPONDING sflight TO t_node.

  WRITE: sflight-fldate     TO t_node-attributes,
         sflight-seatsocc RIGHT-JUSTIFIED     TO t_node-attributes+11,
         sflight-seatsmax RIGHT-JUSTIFIED     TO t_node-attributes+20,
         sflight-planetype     TO t_node-attributes+29.


  APPEND t_node TO it_tab.

END-OF-SELECTION.
  CALL SCREEN 100.

*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'DYN'.
  SET TITLEBAR 'T1'.

ENDMODULE.                 " STATUS_0100  OUTPUT

*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      PERFORM free.
      SET SCREEN 0.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_0100  INPUT

*----------------------------------------------------------------------*
MODULE create_objects OUTPUT.
  CHECK cont IS INITIAL.
  CREATE OBJECT cont
    EXPORTING
      container_name              = 'MY_CONTROL_AREA'
    EXCEPTIONS
      OTHERS                      = 1
      .
  IF sy-subrc <> 0.
    MESSAGE a010(bc408).
  ENDIF.

  CREATE OBJECT alv_tree
    EXPORTING
      parent          = cont
      item_selection  = ' '
    EXCEPTIONS
      OTHERS            = 1
      .
  IF sy-subrc <> 0.
    MESSAGE a010(bc408).
  ENDIF.

*     define hierarchy header
  PERFORM define_hierarchy_header
          CHANGING hierarchy_header.

  PERFORM build_fieldcatalog CHANGING fieldcatalog.

  CALL METHOD alv_tree->set_table_for_first_display
    EXPORTING
*    I_STRUCTURE_NAME     =
*    IS_VARIANT           =
*    I_SAVE               =
*    I_DEFAULT            = 'X'
      is_hierarchy_header  = hierarchy_header
*    IS_EXCEPTION_FIELD   =
*    IT_SPECIAL_GROUPS    =
*    IT_LIST_COMMENTARY   =
*    I_LOGO               =
*    I_BACKGROUND_ID      =
*    IT_TOOLBAR_EXCLUDING =
    CHANGING
      it_outtab            = it_outtab
*    IT_FILTER            =
    it_fieldcatalog      = fieldcatalog
      .

  IF sy-subrc <> 0.
    MESSAGE a012(bc408).
  ENDIF.


  LOOP AT it_tab INTO t_node.
    IF t_node-parent_id IS INITIAL.
      node_text = t_node-carrid.
      node_text+4 = t_node-connid.
    ELSE.
      node_text = t_node-attributes(10).
    ENDIF.

    CALL METHOD alv_tree->add_node
      EXPORTING
        i_relat_node_key = t_node-parent_id
        i_relationship   = cl_gui_column_tree=>relat_last_child
        is_outtab_line   = t_node
*    IS_NODE_LAYOUT       =
*    IT_ITEM_LAYOUT       =
    i_node_text          = node_text
*  IMPORTING
*    E_NEW_NODE_KEY       =
*  EXCEPTIONS
*    RELAT_NODE_NOT_FOUND = 1
*    NODE_NOT_FOUND       = 2
*    others               = 3
    .
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDLOOP.
  CALL METHOD alv_tree->column_optimize
    EXPORTING
      i_start_column         = 'MANDT'
      i_end_column           = 'ATTRIBUTES'
*      i_include_heading      = ' '
*  EXCEPTIONS
*    START_COLUMN_NOT_FOUND = 1
*    END_COLUMN_NOT_FOUND   = 2
*    others                 = 3
          .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD alv_tree->frontend_update.
  CALL METHOD cl_gui_cfw=>flush.


ENDMODULE.                 " create_objects  OUTPUT

*----------------------------------------------------------------------*
FORM free.
  CALL METHOD: alv_tree->free,
               cont->free.

  FREE: alv_tree,
        cont.
ENDFORM.                    " free


*----------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR ok_code.
ENDMODULE.                 " clear_ok_code  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  define_hierarchy_header
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_HIERARCHY_HEADER  text
*----------------------------------------------------------------------*
FORM define_hierarchy_header CHANGING
                               p_hierarchy_header TYPE treev_hhdr.

  p_hierarchy_header-heading = 'Objektbezeichner'(300).
  p_hierarchy_header-tooltip = 'Objektbezeichner'(300).
  p_hierarchy_header-width = 48.
  p_hierarchy_header-width_pix = ' '.

ENDFORM.                               " define_hierarchy_header
*&---------------------------------------------------------------------*
*&      Form  build_fieldcatalog
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_FIELDCATALOG  text
*----------------------------------------------------------------------*
FORM build_fieldcatalog
     CHANGING fieldcatalog TYPE lvc_t_fcat.

  DATA: ls_fieldcatalog TYPE lvc_s_fcat.

  CLEAR fieldcatalog[].

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname  = 'MANDT'.
  ls_fieldcatalog-ref_field  = 'MANDT'.
  ls_fieldcatalog-ref_table  = 'SPFLI'.
  ls_fieldcatalog-colddictxt = 'R'.
  ls_fieldcatalog-col_pos    = 1.
  APPEND ls_fieldcatalog TO fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname  = 'CARRID'.
  ls_fieldcatalog-ref_field  = 'CARRID'.
  ls_fieldcatalog-ref_table  = 'SPFLI'.
  ls_fieldcatalog-colddictxt = 'R'.
  ls_fieldcatalog-col_pos    = 2.
  APPEND ls_fieldcatalog TO fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname  = 'CONNID'.
  ls_fieldcatalog-ref_field  = 'CONNID'.
  ls_fieldcatalog-ref_table  = 'SPFLI'.
  ls_fieldcatalog-colddictxt = 'R'.
  ls_fieldcatalog-col_pos    = 3.
  APPEND ls_fieldcatalog TO fieldcatalog.

  CLEAR ls_fieldcatalog.
  ls_fieldcatalog-fieldname  = 'ATTRIBUTES'.
*  ls_fieldcatalog-ref_field  = 'CONNID'.
*  ls_fieldcatalog-ref_table  = 'SPFLI'.
*  ls_fieldcatalog-colddictxt = 'R'.
  ls_fieldcatalog-coltext = 'Sonstiges'.
  ls_fieldcatalog-intlen = 100.
  ls_fieldcatalog-inttype = 'C'.
  ls_fieldcatalog-col_pos    = 4.
  APPEND ls_fieldcatalog TO fieldcatalog.

ENDFORM.                    " build_fieldcatalog
