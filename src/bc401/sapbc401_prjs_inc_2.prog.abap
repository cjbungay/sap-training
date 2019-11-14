*&---------------------------------------------------------------------*
*&  Include           SAPBC401_PRJS_INC_1
*&---------------------------------------------------------------------*


*---------------------------------------------------------------------*
*       INTERFACE if_status
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
INTERFACE if_status.
  METHODS display_status.
ENDINTERFACE.                    "if_status


*---------------------------------------------------------------------*
*       CLASS lcl_customer DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_customer DEFINITION.

  PUBLIC SECTION.
    METHODS constructor IMPORTING im_id TYPE s_customer
                                  im_name TYPE s_custname
                                  im_street TYPE s_street
                                  im_city TYPE city
                                  im_app_date TYPE d.

    METHODS get_attributes EXPORTING ex_cust TYPE bc401_typd_cust.

    DATA:  id       TYPE s_customer READ-ONLY.

    INTERFACES if_status.

  PRIVATE SECTION.
    DATA:  name     TYPE s_custname,
           street   TYPE s_street,
           city     TYPE city,
           app_date TYPE d.

ENDCLASS.                    "lcl_customer DEFINITION


*---------------------------------------------------------------------*
*       CLASS lcl_customer IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_customer IMPLEMENTATION.
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

  METHOD if_status~display_status.
    DATA custtype TYPE s_custtype.
    CONSTANTS: bcust(1) TYPE c VALUE 'B',
               pcust(1) TYPE c VALUE 'P'.

    SELECT SINGLE custtype FROM scustom INTO (custtype)
      WHERE id = id.

    IF sy-subrc = 0.
      CASE custtype.
        WHEN bcust.
          MESSAGE i015(bc401) WITH id 'Geschäftskunde'(001).
*         Kunde &1 ist &2.
        WHEN pcust.
          MESSAGE i015(bc401) WITH id 'Privatkunde'(002).
*         Kunde &1 ist &2.
      ENDCASE.
    ENDIF.

  ENDMETHOD.                    "if_status~display_status

ENDCLASS.                    "lcl_customer IMPLEMENTATION





*---------------------------------------------------------------------*
*       CLASS lcl_waitlist DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_waitlist DEFINITION.
  PUBLIC SECTION.

    TYPES itt_wait_list
            TYPE STANDARD TABLE OF REF TO lcl_customer WITH DEFAULT
            KEY.

    METHODS constructor IMPORTING im_carrid TYPE sflight-carrid
                                  im_connid TYPE sflight-connid
                                  im_fldate TYPE sflight-fldate.

    METHODS add IMPORTING im_customer TYPE REF TO lcl_customer
                RAISING   cx_wait_list.

    METHODS delete IMPORTING im_customer TYPE REF TO lcl_customer
                   RAISING   cx_wait_list.

    METHODS get_pos IMPORTING im_customer TYPE REF TO lcl_customer
                    EXPORTING ex_pos LIKE sy-tabix
                    RAISING   cx_wait_list.


    METHODS get_wait_list EXPORTING ex_wait_list TYPE itt_wait_list.
    METHODS get_first     RAISING   cx_wait_list.


    DATA:
      carrid TYPE sflight-carrid READ-ONLY,
      connid TYPE sflight-connid READ-ONLY,
      fldate TYPE sflight-fldate READ-ONLY.

    INTERFACES if_status.
    EVENTS first_got EXPORTING value(ex_cust) TYPE REF TO
    lcl_customer.

  PRIVATE SECTION.

    DATA   customer_list TYPE itt_wait_list.

ENDCLASS.                    "lcl_waitlist DEFINITION



*---------------------------------------------------------------------*
*       CLASS lcl_waitlist IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_waitlist IMPLEMENTATION.
  METHOD constructor.
    carrid = im_carrid.
    connid = im_connid.
    fldate = im_fldate.
  ENDMETHOD.                    "constructor

  METHOD get_wait_list.
    ex_wait_list = customer_list.
  ENDMETHOD.                    "get_wait_list

  METHOD add.
    READ TABLE customer_list  WITH KEY
        table_line->id = im_customer->id TRANSPORTING NO FIELDS.

*** customer is not in wait_list
    IF sy-subrc <> 0.
      INSERT im_customer INTO TABLE customer_list.
    ELSE.
***    customer is already in wait_list for this flight !!!
      RAISE EXCEPTION TYPE cx_wait_list
        EXPORTING
         textid = cx_wait_list=>cx_wait_list_customer_there
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.
  ENDMETHOD.                    "add


  METHOD get_first.
    DATA r_cust TYPE REF TO lcl_customer.

    READ TABLE customer_list INTO r_cust INDEX 1.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_wait_list
        EXPORTING
         textid = cx_wait_list=>cx_wait_list_no_entry
          carrid = carrid
          connid = connid
          fldate = fldate.

    ELSE.
      DELETE customer_list INDEX 1.
      RAISE EVENT first_got EXPORTING ex_cust = r_cust.
    ENDIF.
  ENDMETHOD.                    "get_first


  METHOD delete.
    DELETE customer_list
        WHERE table_line->id = im_customer->id.
    IF sy-subrc <> 0.

      RAISE EXCEPTION TYPE cx_wait_list
        EXPORTING
          textid = cx_wait_list=>cx_wait_list_customer_notthere
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.

    ENDIF.
  ENDMETHOD.                    "delete

  METHOD get_pos.
    READ TABLE customer_list
          WITH KEY table_line->id = im_customer->id
          TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      ex_pos = sy-tabix.
    ELSE.
      RAISE EXCEPTION TYPE cx_wait_list
        EXPORTING
          textid = cx_wait_list=>cx_wait_list_customer_notthere
          customer = im_customer->id
          carrid = carrid
          connid = connid
          fldate = fldate.
    ENDIF.
  ENDMETHOD.                    "get_pos


  METHOD if_status~display_status.
    DATA n_o_lines LIKE sy-tabix.
    n_o_lines = LINES( customer_list ).

    MESSAGE i014(bc401) WITH carrid connid fldate n_o_lines.
*   Die Warteliste zum Flug &1 &2 &3 enthält &4 Einträge.
  ENDMETHOD.                    "if_status~display_status

ENDCLASS.                    "lcl_waitlist IMPLEMENTATION



*---------------------------------------------------------------------*
*       CLASS cl_bc401_display_log DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_bc401_display_log DEFINITION.
  PUBLIC SECTION.
    METHODS display_log.

  PROTECTED SECTION.
    DATA: it_log TYPE bc401_typd_cust_list.

ENDCLASS.                    "cl_bc401_display_log DEFINITION


*---------------------------------------------------------------------*
*       CLASS cl_bc401_display_log IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS cl_bc401_display_log IMPLEMENTATION.

  METHOD display_log.
    DATA n_o_lines LIKE sy-tabix.

    n_o_lines = LINES( it_log ).

    IF n_o_lines > 0.
      SORT it_log BY id.
      DELETE ADJACENT DUPLICATES FROM it_log COMPARING id.
      CALL FUNCTION 'bc401_DISPLAY_DATA'
        EXPORTING
          im_list = it_log.
    ELSE.
      MESSAGE 'Es sind keine Nachrücker vorhanden.'(003) TYPE 'I'.
    ENDIF.
  ENDMETHOD.                    "display_log

ENDCLASS.                    "cl_bc401_display_log IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_log DEFINITION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_log DEFINITION INHERITING FROM cl_bc401_display_log.
  PUBLIC SECTION.
    METHODS get_cust FOR EVENT first_got OF lcl_waitlist
                            IMPORTING ex_cust.

    INTERFACES if_status.

ENDCLASS.                    "lcl_log DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_log IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_log IMPLEMENTATION.
  METHOD get_cust.
    DATA wa_cust TYPE bc401_typd_cust.

    ex_cust->get_attributes( IMPORTING ex_cust = wa_cust ).
    INSERT wa_cust INTO TABLE it_log.
  ENDMETHOD.                    "get_cust


  METHOD if_status~display_status.
    DATA: n_o_lines LIKE sy-tabix,
          c_n_o_lines TYPE string,
          text TYPE string.

    SORT it_log BY id.
    DELETE ADJACENT DUPLICATES FROM it_log COMPARING id.

    n_o_lines = LINES( it_log ).
    c_n_o_lines = n_o_lines.
    CONCATENATE 'Anzahl der Nachrücker:'(004)
                 c_n_o_lines INTO text SEPARATED BY space.

    MESSAGE  text TYPE 'I'.

  ENDMETHOD.                    "if_status~display_status

ENDCLASS.                    "lcl_log IMPLEMENTATION


*---------------------------------------------------------------------*
*       CLASS lcl_buffer DEFINITION
*---------------------------------------------------------------------*
* implemented as SINGLETON, should exist only once !                  *
*---------------------------------------------------------------------*
CLASS lcl_buffer DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    "--------------
    CLASS-METHODS: class_constructor.
    CLASS-METHODS: get_buffer_ref RETURNING value(re_buffer)
                       TYPE REF TO lcl_buffer.
    METHODS: insert_wait_list IMPORTING im_wait_list
                  TYPE REF TO lcl_waitlist.

    METHODS: create_wait_list IMPORTING im_carrid TYPE s_carr_id
                                        im_connid TYPE s_conn_id
                                        im_fldate TYPE sflight-fldate
                              RETURNING value(re_waitlist)
                                     TYPE REF TO lcl_waitlist
                              RAISING cx_wait_list.

    METHODS: get_wait_list IMPORTING im_carrid TYPE s_carr_id
                                     im_connid TYPE s_conn_id
                                     im_fldate TYPE sflight-fldate
                              RETURNING value(re_waitlist)
                                     TYPE REF TO lcl_waitlist.

    METHODS: delete_wait_list IMPORTING im_carrid TYPE s_carr_id
                                        im_connid TYPE s_conn_id
                                        im_fldate TYPE sflight-fldate
                                        raising cx_wait_list.

    METHODS: delete_all_wait_lists.

    DATA: wait_list TYPE STANDARD TABLE OF
                    REF TO lcl_waitlist READ-ONLY.

  PRIVATE SECTION.
    "--------------
    CLASS-DATA: r_buffer TYPE REF TO lcl_buffer.

ENDCLASS.                    "lcl_buffer DEFINITION

*---------------------------------------------------------------------*
*       CLASS lcl_buffer IMPLEMENTATION
*---------------------------------------------------------------------*
*
*---------------------------------------------------------------------*
CLASS lcl_buffer IMPLEMENTATION.
  METHOD class_constructor.
    CREATE OBJECT r_buffer.
  ENDMETHOD.                    "class_constructor

  METHOD get_buffer_ref.
    re_buffer = r_buffer.
  ENDMETHOD.                    "get_buffer_ref

  METHOD insert_wait_list." importing im_wait_list
    "                  type ref to lcl_waitlist.
    INSERT im_wait_list INTO TABLE wait_list.
  ENDMETHOD.                    "insert_wait_list

  METHOD create_wait_list.
*    CLEAR re_waitlist.
    re_waitlist = get_wait_list( im_carrid = im_carrid
                             im_connid = im_connid
                             im_fldate = im_fldate ).
    IF NOT re_waitlist IS BOUND.
      CREATE OBJECT re_waitlist EXPORTING im_carrid = im_carrid
                                         im_connid = im_connid
                                         im_fldate = im_fldate.
      INSERT re_waitlist INTO TABLE wait_list.
    ELSE.
      RAISE EXCEPTION TYPE cx_wait_list
         EXPORTING
            carrid = im_carrid
            connid = im_connid
            fldate = im_fldate
            textid = cx_wait_list=>cx_wait_list_exists.
    ENDIF.
  ENDMETHOD.                    "create_wait_list

  METHOD get_wait_list.
    READ TABLE wait_list INTO re_waitlist WITH KEY
           table_line->carrid = im_carrid
           table_line->connid = im_connid
           table_line->fldate = im_fldate.
*    IF sy-subrc <> 0.                KONTROLLIEREN !!!
*      clear re_waitlist.
*    ENDIF.

  ENDMETHOD.                    "get_wait_list


  METHOD delete_wait_list.    "UNKRITISCH !!!
    DATA: r_waitlist TYPE REF TO lcl_waitlist.
    r_waitlist = get_wait_list( im_carrid = im_carrid
                             im_connid = im_connid
                             im_fldate = im_fldate ).
    IF NOT r_waitlist IS BOUND.
      RAISE EXCEPTION TYPE cx_wait_list
         EXPORTING
            carrid = im_carrid
            connid = im_connid
            fldate = im_fldate.
    ELSE.
      DELETE wait_list
         WHERE       table_line->carrid = im_carrid
               AND   table_line->connid = im_connid
               AND   table_line->fldate = im_fldate.
    ENDIF.

  ENDMETHOD.                    "delete_wait_list

  METHOD delete_all_wait_lists.
    CLEAR wait_list.
    " ATTENTION: in our case, this also deletes all customer-objects.
    " --> COMPOSITION in class-diagram ?
  ENDMETHOD.                    "delete_all_wait_lists

ENDCLASS.                    "lcl_buffer IMPLEMENTATION
