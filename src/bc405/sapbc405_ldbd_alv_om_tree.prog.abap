*&---------------------------------------------------------------------*
*& Report  SAPBC405_LDBD_ALV_OM_TREE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  SAPBC405_LDBD_ALV_OM_TREE.

NODES:
  spfli,
  sflight.

DATA:
  BEGIN OF wa.
INCLUDE TYPE dv_flights.
DATA:
  fltype TYPE spfli-fltype,
  END OF wa,
  it LIKE TABLE OF wa,
  r_tree TYPE REF TO cl_salv_tree.

DATA:
  l_connid_key TYPE lvc_nkey,
  l_flight_key TYPE lvc_nkey.

PARAMETERS:
  pa_ftp TYPE spfli-fltype.

SELECT-OPTIONS:
  so_occ FOR sflight-seatsocc.

START-OF-SELECTION.
*TRY.
  CALL METHOD cl_salv_tree=>factory
*  EXPORTING
*    R_CONTAINER =
    IMPORTING
      r_salv_tree = r_tree
    CHANGING
      t_table     = it
      .
* CATCH CX_SALV_ERROR .
*ENDTRY.

  PERFORM build_header.

GET spfli.
  CHECK spfli-fltype = pa_ftp.
  CLEAR wa.
  MOVE-CORRESPONDING spfli TO wa.
  PERFORM add_connid_line USING    wa
                                   ''
                          CHANGING l_connid_key.

GET sflight.
  CHECK so_occ.
  CLEAR wa.
  MOVE-CORRESPONDING sflight TO wa.
  PERFORM add_flight_line USING    wa
                                   l_connid_key
                          CHANGING l_flight_key.


END-OF-SELECTION.
  r_tree->set_screen_status(
     pfstatus      =  'SALV_STANDARD'
     report        =  'SALV_DEMO_TREE_SIMPLE'
     set_functions =  r_tree->c_functions_all ).


*... set the columns technical
  DATA: r_columns TYPE REF TO cl_salv_columns_tree.

  r_columns = r_tree->get_columns( ).
  r_columns->set_optimize( 'X' ).

  PERFORM set_columns_technical USING r_columns.

  CALL METHOD r_tree->display
    .

*&---------------------------------------------------------------------*
*&      Form  build_header
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_header .


  DATA: settings TYPE REF TO cl_salv_tree_settings.

  settings = r_tree->get_tree_settings( ).
  settings->set_hierarchy_header( 'ALV Tree BC405'(hdr) ).
  settings->set_hierarchy_tooltip( 'ALV Tree BC405 Tooltip'(ttp) ).
  settings->set_hierarchy_size( 30 ).

  DATA: title TYPE salv_de_tree_text.
  title = 'Connections and Flights'(ttl).
  settings->set_header( title ).

ENDFORM.                    " build_header
*&---------------------------------------------------------------------*
*&      Form  add_carrid_line
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_DATA  text
*      -->P_0039   text
*      <--P_L_CARRID_KEY  text
*----------------------------------------------------------------------*
FORM add_connid_line  USING    p_wa LIKE wa " TYPE dv_flights
                               p_key
                      CHANGING p_l_connid_key.

  DATA: nodes TYPE REF TO cl_salv_nodes,
        node TYPE REF TO cl_salv_node.

* working with nodes
  nodes = r_tree->get_nodes( ).

  TRY.
* add a new node
      node = nodes->add_node( related_node = p_key
                              relationship =
   cl_gui_column_tree=>relat_last_child ).

* set the data for the new node
      node->set_data_row( p_wa ).
* set color combination
      node->set_row_style( if_salv_c_tree_style=>emphasized_positive ).

*  possible color combinations
*
*  Text color Background color Constant
*  ---------- ---------------- --------
*  Black      Standard         DEFAULT
*  Black      Light yellow     EMPHASIZED
*  Black      Medium blue      EMPHASIZED_A
*  Black      Light blue       EMPHASIZED_B
*  Black      Salmon color     EMPHASIZED_C
*  Black      Red              EMPHASIZED_NEGATIVE
*  Black      Green            EMPHASIZED_POSITIVE
*  Gray       Standard         INACTIVE
*  Dark blue  Standard         INTENSIFIED
*  Dark red   Standard         INTENSIFIED_CRITICAL


      p_l_connid_key = node->get_key( ).
    CATCH cx_salv_msg.
  ENDTRY.

ENDFORM.                    " add_connid_line
*&---------------------------------------------------------------------*
*&      Form  add_flight_line
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_WA  text
*      -->P_L_CONNID_KEY  text
*      <--P_L_FLIGHT_KEY  text
*----------------------------------------------------------------------*
FORM add_flight_line  USING    p_wa LIKE wa " TYPE dv_flights
                               p_l_connid_key
                      CHANGING p_l_flight_key.

  DATA: nodes TYPE REF TO cl_salv_nodes,
        node TYPE REF TO cl_salv_node.

  nodes = r_tree->get_nodes( ).

  TRY.
      node = nodes->add_node( related_node = p_l_connid_key
                              relationship =
                                cl_gui_column_tree=>relat_last_child ).

      node->set_row_style( if_salv_c_tree_style=>emphasized_b ).
      node->set_data_row( p_wa ).

      p_l_flight_key = node->get_key( ).
    CATCH cx_salv_msg.
  ENDTRY.


ENDFORM.                    " add_flight_line
*&---------------------------------------------------------------------*
*&      Form  set_columns_technical
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LR_COLUMNS  text
*----------------------------------------------------------------------*
FORM set_columns_technical
  USING ir_columns TYPE REF TO cl_salv_columns_tree.

  DATA: lr_column TYPE REF TO cl_salv_column.

  TRY.
      lr_column = ir_columns->get_column( 'MANDT' ).
      lr_column->set_technical( if_salv_c_bool_sap=>true ).
    CATCH cx_salv_not_found.                            "#EC NO_HANDLER
  ENDTRY.

ENDFORM.                    " set_columns_technical
