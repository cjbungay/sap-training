*&---------------------------------------------------------------------*
*&  Include           SAPBC401_PRJS_WAITLIST_INC
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
*       INTERFACE if_taw10_status
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
INTERFACE if_taw10_status.
  METHODS display_status.
ENDINTERFACE.                    "if_taw10_status


*---------------------------------------------------------------------*
*       CLASS lcl_00_customer DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_00_customer DEFINITION.

  PUBLIC SECTION.
    METHODS constructor IMPORTING im_id TYPE s_customer
                                  im_name TYPE s_custname
                                  im_street TYPE s_street
                                  im_city TYPE city
                                  im_app_date TYPE d.

    METHODS get_attributes EXPORTING ex_cust TYPE taw10_typd_cust.

    DATA:  id       TYPE s_customer READ-ONLY.

    INTERFACES if_taw10_status.

  PRIVATE SECTION.
    DATA:  name     TYPE s_custname,
           street   TYPE s_street,
           city     TYPE city,
           app_date TYPE d.

ENDCLASS.                    "lcl_00_customer DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_00_customer IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_00_customer IMPLEMENTATION.
  METHOD constructor.
    id = im_id.
    name = im_name.
    street = im_street.
    city = im_city.
    app_date = im_app_date.
  ENDMETHOD.                    "constructor

  METHOD get_attributes.
    ex_cust-id = id.
    ex_cust-name = name.
    ex_cust-street = street.
    ex_cust-city = city.
    ex_cust-app_date = app_date.
  ENDMETHOD.                    "get_attributes

  METHOD if_taw10_status~display_status.
    DATA custtype TYPE s_custtype.
    CONSTANTS: bcust(1) TYPE c VALUE 'B',
               pcust(1) TYPE c VALUE 'P'.

    SELECT SINGLE custtype FROM scustom INTO (custtype)
      WHERE id = id.

    IF sy-subrc = 0.
      CASE custtype.
        WHEN bcust.
          MESSAGE i015(taw10) WITH id 'Geschäftskunde'(001).
*         Kunde &1 ist &2.
        WHEN pcust.
          MESSAGE i015(taw10) WITH id 'Privatkunde'(002).
*         Kunde &1 ist &2.
      ENDCASE.
    ENDIF.

  ENDMETHOD.                    "if_taw10_status~display_status

ENDCLASS.                    "lcl_00_customer IMPLEMENTATION





*---------------------------------------------------------------------*
*       CLASS cl_00_waitlist DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_00_waitlist DEFINITION.
  PUBLIC SECTION.

    TYPES itt_wait_list
            TYPE STANDARD TABLE OF REF TO lcl_00_customer WITH DEFAULT
            KEY.

    METHODS constructor IMPORTING im_carrid TYPE sflight-carrid
                                  im_connid TYPE sflight-connid
                                  im_fldate TYPE sflight-fldate.

    METHODS add IMPORTING im_customer TYPE REF TO lcl_00_customer
                RAISING   cx_taw10_cust_in_list.

    METHODS delete IMPORTING im_customer TYPE REF TO lcl_00_customer
                   RAISING   cx_taw10_cust_not_in_list.

    METHODS get_pos IMPORTING im_customer TYPE REF TO lcl_00_customer
                    EXPORTING ex_pos LIKE sy-tabix
                    RAISING   cx_taw10_cust_not_in_list.

    METHODS get_wait_list EXPORTING ex_wait_list TYPE itt_wait_list.
    METHODS get_first     RAISING   cx_taw10_empty_list.


    DATA:
      carrid TYPE sflight-carrid READ-ONLY,
      connid TYPE sflight-connid READ-ONLY,
      fldate TYPE sflight-fldate READ-ONLY.

    INTERFACES if_taw10_status.
    EVENTS first_got EXPORTING value(ex_cust) TYPE REF TO
    lcl_00_customer.

  PRIVATE SECTION.

    DATA   wait_list TYPE itt_wait_list.

ENDCLASS.                    "cl_00_waitlist DEFINITION



*---------------------------------------------------------------------*
*       CLASS cl_00_waitlist IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_00_waitlist IMPLEMENTATION.
  METHOD constructor.
    carrid = im_carrid.
    connid = im_connid.
    fldate = im_fldate.
  ENDMETHOD.                    "constructor

  METHOD get_wait_list.
    ex_wait_list = wait_list.
  ENDMETHOD.                    "get_wait_list

  METHOD add.
    READ TABLE wait_list  WITH KEY
        table_line->id = im_customer->id TRANSPORTING NO FIELDS.

    IF sy-subrc <> 0.
      INSERT im_customer INTO TABLE wait_list.
    ELSE.

      RAISE EXCEPTION TYPE cx_taw10_cust_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.
  ENDMETHOD.                    "add


  METHOD get_first.
    DATA r_cust TYPE REF TO lcl_00_customer.

    READ TABLE wait_list INTO r_cust INDEX 1.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_taw10_empty_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          carrid = carrid
          connid = connid
          fldate = fldate.

    ELSE.
      DELETE wait_list INDEX 1.
      RAISE EVENT first_got EXPORTING ex_cust = r_cust.
    ENDIF.
  ENDMETHOD.                    "get_first


  METHOD delete.
    DELETE wait_list
        WHERE table_line->id = im_customer->id.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_taw10_cust_not_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.
  ENDMETHOD.                    "delete


  METHOD get_pos.
    READ TABLE wait_list
          WITH KEY table_line->id = im_customer->id
          TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      ex_pos = sy-tabix.
    ELSE.

      RAISE EXCEPTION TYPE cx_taw10_cust_not_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.

  ENDMETHOD.                    "get_pos


  METHOD if_taw10_status~display_status.
    DATA n_o_lines LIKE sy-tabix.
    n_o_lines = lines( wait_list ).

    MESSAGE i014(taw10) WITH carrid connid fldate n_o_lines.
*   Die Warteliste zum Flug &1 &2 &3 enthält &4 Einträge.
  ENDMETHOD.                    "if_taw10_status~display_status

ENDCLASS.                    "cl_00_waitlist IMPLEMENTATION



*---------------------------------------------------------------------*
*       CLASS cl_00_display_log DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_00_display_log DEFINITION.
  PUBLIC SECTION.
    METHODS display_log.

  PROTECTED SECTION.
    DATA: it_log TYPE taw10_typd_cust_list.

ENDCLASS.                    "cl_00_display_log DEFINITION


*---------------------------------------------------------------------*
*       CLASS cl_00_display_log IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_00_display_log IMPLEMENTATION.

  METHOD display_log.
    DATA n_o_lines LIKE sy-tabix.

    n_o_lines = lines( it_log ).

    IF n_o_lines > 0.
      SORT it_log BY id.
      DELETE ADJACENT DUPLICATES FROM it_log COMPARING id.
      CALL FUNCTION 'TAW10_DISPLAY_DATA'
        EXPORTING
          im_list = it_log.
    ELSE.
      MESSAGE 'Es sind keine Nachrücker vorhanden.'(003) TYPE 'I'.
    ENDIF.
  ENDMETHOD.                    "display_log

ENDCLASS.                    "cl_00_display_log IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS cl_00_log DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_00_log DEFINITION INHERITING FROM cl_00_display_log.
  PUBLIC SECTION.
    METHODS get_cust FOR EVENT first_got OF cl_00_waitlist
                            IMPORTING ex_cust.

    INTERFACES if_taw10_status.

ENDCLASS.                    "cl_00_log DEFINITION

*---------------------------------------------------------------------*
*       CLASS cl_00_log IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_00_log IMPLEMENTATION.
  METHOD get_cust.
    DATA wa_cust TYPE taw10_typd_cust.

    ex_cust->get_attributes( IMPORTING ex_cust = wa_cust ).
    INSERT wa_cust INTO TABLE it_log.
  ENDMETHOD.                    "get_cust


  METHOD if_taw10_status~display_status.
    DATA: n_o_lines LIKE sy-tabix,
          c_n_o_lines TYPE string,
          text TYPE string.

    SORT it_log BY id.
    DELETE ADJACENT DUPLICATES FROM it_log COMPARING id.

    n_o_lines = lines( it_log ).
    c_n_o_lines = n_o_lines.
    CONCATENATE 'Anzahl der Nachrücker:'(004)
                 c_n_o_lines INTO text SEPARATED BY space.

    MESSAGE  text TYPE 'I'.

  ENDMETHOD.                    "if_taw10_status~display_status

ENDCLASS.                    "cl_00_log IMPLEMENTATION
