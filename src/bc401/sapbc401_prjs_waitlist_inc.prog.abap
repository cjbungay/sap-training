*&---------------------------------------------------------------------*
*&  Include           SAPBC401_PRJS_WAITLIST_INC
*&---------------------------------------------------------------------*
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

    METHODS get_attributes EXPORTING ex_cust TYPE bc401_typd_cust.

    DATA:  id       TYPE s_customer READ-ONLY.

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

ENDCLASS.                    "lcl_00_customer IMPLEMENTATION

*---------------------------------------------------------------------*
*       CLASS lcl_00_waitlist DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_00_waitlist DEFINITION.
  PUBLIC SECTION.

    TYPES itt_wait_list
            TYPE STANDARD TABLE OF REF TO lcl_00_customer WITH DEFAULT
            KEY.

    METHODS constructor IMPORTING im_carrid TYPE sflight-carrid
                                  im_connid TYPE sflight-connid
                                  im_fldate TYPE sflight-fldate.

    METHODS add IMPORTING im_customer TYPE REF TO lcl_00_customer
                RAISING   cx_bc401_cust_in_list.

    METHODS delete IMPORTING im_customer TYPE REF TO lcl_00_customer
                   RAISING   cx_bc401_cust_not_in_list.

    METHODS get_pos IMPORTING im_customer TYPE REF TO lcl_00_customer
                    EXPORTING ex_pos LIKE sy-tabix
                    RAISING   cx_bc401_cust_not_in_list.

    METHODS get_wait_list EXPORTING ex_wait_list TYPE itt_wait_list.
    METHODS get_first     RAISING   cx_bc401_empty_list.


    DATA:
      carrid TYPE sflight-carrid READ-ONLY,
      connid TYPE sflight-connid READ-ONLY,
      fldate TYPE sflight-fldate READ-ONLY.

  PRIVATE SECTION.

    DATA   wait_list TYPE itt_wait_list.

ENDCLASS.                    "lcl_00_waitlist DEFINITION



*---------------------------------------------------------------------*
*       CLASS lcl_00_waitlist IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_00_waitlist IMPLEMENTATION.
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

      RAISE EXCEPTION TYPE cx_bc401_cust_in_list
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

      RAISE EXCEPTION TYPE cx_bc401_empty_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          carrid = carrid
          connid = connid
          fldate = fldate.

    ELSE.
      DELETE wait_list INDEX 1.
    ENDIF.
  ENDMETHOD.                    "get_first


  METHOD delete.
    DELETE wait_list
        WHERE table_line->id = im_customer->id.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_bc401_cust_not_in_list
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

      RAISE EXCEPTION TYPE cx_bc401_cust_not_in_list
        EXPORTING
*         TEXTID =
*         PREVIOUS =
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.

  ENDMETHOD.                    "get_pos

ENDCLASS.                    "lcl_00_waitlist IMPLEMENTATION
