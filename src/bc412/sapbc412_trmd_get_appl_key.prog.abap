*&---------------------------------------------------------------------*
*& SAPBC412_TRMD_GET_APPL_KEY                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& The program displays SCARR, SPFLI and SFLIGHT data                  *
*& using an Simple Tree Model.                                         *
*&                                                                     *
*& After a double click on a node the application key is retrieved     *
*& from the node key using string manipulation commands.               *
*&                                                                     *
*& Two different algorithms are implemented in order to seperate the   *
*& application key from the node key                                   *
*&---------------------------------------------------------------------*

REPORT  sapbc412_trmd_get_appl_key MESSAGE-ID bc412.

CONSTANTS c_sep(1) TYPE c VALUE ';'.

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
  ref_tree_model TYPE REF TO cl_simple_tree_model,

* event registration:
  it_events TYPE cntl_simple_events,
  wa_event  LIKE LINE OF it_events.

PARAMETERS:
  pa_split RADIOBUTTON GROUP algo DEFAULT 'X',
  pa_shift RADIOBUTTON GROUP algo.



*---------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS on_node_double_click FOR EVENT node_double_click
                                       OF cl_simple_tree_model
                                       IMPORTING node_key.
ENDCLASS.

*---------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_node_double_click.

    DATA:
      BEGIN OF l_wa_key_sflight_c,
        carrid(3) TYPE c,
        connid(4) TYPE n,
        fldate(8) TYPE n,
      END OF l_wa_key_sflight_c,

     l_rem_key TYPE string. " only for SEARCH-SHIFT-Algorithm

    IF node_key = 'ROOT'.
      MESSAGE i090.
    ELSE.

*     separate node_key into application keys:
      CLEAR wa_sflight.

      IF pa_split = 'X'. " SPLIT-Algorithm
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


      ELSE. " SEARCH-SHIFT-Algorithm
        l_rem_key = node_key.
        SEARCH l_rem_key FOR c_sep.
        IF sy-subrc = 0.
          wa_sflight-carrid = l_rem_key(sy-fdpos).
          SHIFT l_rem_key BY sy-fdpos PLACES.
          SHIFT l_rem_key.
          SEARCH l_rem_key FOR c_sep.
          IF sy-subrc = 0.
            wa_sflight-connid = l_rem_key(sy-fdpos).
            SHIFT l_rem_key BY sy-fdpos PLACES.
            SHIFT l_rem_key.
            wa_sflight-fldate = l_rem_key.
          ELSE.
            wa_sflight-connid = l_rem_key.
          ENDIF.
        ELSE.
          wa_sflight-carrid = l_rem_key.
        ENDIF.
      ENDIF.


*     get the correct application data:
      IF wa_sflight-connid IS INITIAL.
        READ TABLE it_scarr INTO wa_scarr
                   WITH TABLE KEY carrid = wa_sflight-carrid.
        IF sy-subrc <> 0.
          MESSAGE a075.
        ENDIF.
      ELSEIF wa_sflight-fldate IS INITIAL.
        READ TABLE it_spfli INTO wa_spfli
                   WITH TABLE KEY carrid = wa_sflight-carrid
                                  connid = wa_sflight-connid.
        IF sy-subrc <> 0.
          MESSAGE a075.
        ENDIF.
      ELSE.
        READ TABLE it_sflight INTO wa_sflight
                   WITH TABLE KEY carrid = wa_sflight-carrid
                                  connid = wa_sflight-connid
                                  fldate = wa_sflight-fldate.
        IF sy-subrc <> 0.
          MESSAGE a075.
        ENDIF.
      ENDIF.

* due to didactical reasons only a message here:
      MESSAGE i091 WITH wa_sflight-carrid
                        wa_sflight-connid
                        wa_sflight-fldate.
    ENDIF.

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
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       Start control handling.
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
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

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

    wa_event-eventid = cl_simple_tree_model=>eventid_node_double_click.
    INSERT wa_event INTO TABLE it_events.
    CALL METHOD ref_tree_model->set_registered_events
      EXPORTING
        events                    = it_events
      EXCEPTIONS
        OTHERS                    = 1
            .
    IF sy-subrc <> 0.
      MESSAGE a012.
    ENDIF.

    SET HANDLER lcl_event_handler=>on_node_double_click
                FOR ref_tree_model.

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
        expander          = space
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
                SEPARATED BY c_sep.
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
        expander          = space
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
                SEPARATED BY c_sep.
    CONCATENATE wa_sflight-carrid
                wa_sflight-connid
                INTO l_wa_node-relatkey
                SEPARATED BY c_sep.
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
