*&---------------------------------------------------------------------*
*& Report  SAPBC412_COND_VISIBILITY                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc412_cond_visibility MESSAGE-ID bc412.
* data types
TYPES:
      t_url        TYPE bapiuri-uri.

* global data definitions
*   screen
DATA: ok_code          TYPE sy-ucomm,
      copy_ok          LIKE ok_code,

*   navigation
      wa_nav           TYPE sy-dynnr,
      navigation_hist  LIKE TABLE OF wa_nav,
      navigation_level TYPE i,

*   auxiliary
      l_url            TYPE t_url,

*   object references
      ref_container    TYPE REF TO cl_gui_custom_container,
      ref_picture      TYPE REF TO cl_gui_picture.



CALL FUNCTION 'BC412_BDS_GET_PIC_URL'
*    EXPORTING
*         NUMBER        = 1
     IMPORTING
          url           = l_url
     EXCEPTIONS
          OTHERS        = 1.

IF sy-subrc <> 0.
  MESSAGE i035(bc412) WITH 1.
  LEAVE PROGRAM.
ENDIF.

ADD 1 TO navigation_level.
wa_nav = 0.
APPEND wa_nav TO navigation_hist.


CALL SCREEN 200.



*&---------------------------------------------------------------------*
*&      Module  STATUS_GLOBAL  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_global OUTPUT.
  SET PF-STATUS 'NORM'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                             " STATUS_GLOBAL  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  INIT_CONTROL_PROCESSING  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF ref_container IS INITIAL.

*   create a container object
    CREATE OBJECT ref_container
      EXPORTING
        container_name = 'CONTROL_AREA1'
      EXCEPTIONS
        others = 1.
    IF sy-subrc NE 0.
      MESSAGE a010.
    ENDIF.

*   create a picture object
    CREATE OBJECT ref_picture
      EXPORTING
        parent = ref_container
      EXCEPTIONS
        others = 1.
    IF sy-subrc NE 0.
      MESSAGE a011.
    ENDIF.

*   load picture
    CALL METHOD ref_picture->load_picture_from_url
      EXPORTING
        url = l_url
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
      MESSAGE a012.
    ENDIF.
  ENDIF.
ENDMODULE.                             " INIT_CONTROL_PROCESSING  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command INPUT.
  copy_ok = ok_code.
  CLEAR ok_code.

  CASE copy_ok.
    WHEN 'CALL_0100'.
      ADD 1 TO navigation_level.
      wa_nav = 0.
      APPEND wa_nav TO navigation_hist.

      CALL SCREEN 100.

    WHEN 'SET_0100'.
      ADD 1 TO navigation_level.
      wa_nav = sy-dynnr.
      APPEND wa_nav TO navigation_hist.

      LEAVE TO SCREEN 100.
    WHEN 'CALL_0200'.
      ADD 1 TO navigation_level.
      wa_nav = 0.
      APPEND wa_nav TO navigation_hist.

      CALL SCREEN 200.
    WHEN 'SET_0200'.
      ADD 1 TO navigation_level.
      wa_nav = sy-dynnr.
      APPEND wa_nav TO navigation_hist.

      LEAVE TO SCREEN 200.
    WHEN 'POPUP_0100'.
      ADD 1 TO navigation_level.
      wa_nav = 0.
      APPEND wa_nav TO navigation_hist.

      CALL SCREEN 100 STARTING AT 5 5.
    WHEN 'POPUP_0200'.
      ADD 1 TO navigation_level.
      wa_nav = 0.
      APPEND wa_nav TO navigation_hist.

      CALL SCREEN 200 STARTING AT 5 5.
    WHEN 'BACK' OR 'CANCEL'.
      READ TABLE navigation_hist INTO wa_nav INDEX navigation_level.
      IF sy-subrc NE 0.
*       should not occur
      ENDIF.

      CASE wa_nav.
        WHEN 0.
          DELETE navigation_hist INDEX navigation_level.
          navigation_level = navigation_level - 1.

          LEAVE TO SCREEN 0.
        WHEN 100.
          DELETE navigation_hist INDEX navigation_level.
          navigation_level = navigation_level - 1.

          LEAVE TO SCREEN 100.
        WHEN 200.
          DELETE navigation_hist INDEX navigation_level.
          navigation_level = navigation_level - 1.

          LEAVE TO SCREEN 200.
      ENDCASE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.                             " USER_COMMAND  INPUT
