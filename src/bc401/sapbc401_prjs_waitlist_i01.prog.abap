*----------------------------------------------------------------------*
***INCLUDE bc401_CSS1_WAITLIST_I01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  check_and_create_cust  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_and_create_cust INPUT.
  SELECT SINGLE name street city FROM scustom
                                INTO CORRESPONDING FIELDS OF scustom
                                WHERE id = scustom-id.
  IF sy-subrc <> 0.
    CLEAR: scustom-name, scustom-city.
    MESSAGE e916(bc401) WITH scustom-id.
*   Customer & does not exist. Please correct !
  ENDIF.
ENDMODULE.                 " check_and_create_cust  INPUT


*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA: text TYPE string.
  DATA: n_o_lines TYPE i.
  DATA: save_ok TYPE sy-ucomm.

  CLEAR r_waitlist.
  save_ok = ok_code.
  CLEAR ok_code.
  CASE save_ok.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'CREATE'. "##########################################
      TRY.
          r_buffer->create_wait_list( EXPORTING
                                         im_carrid = sdyn_conn-carrid
                                         im_connid = sdyn_conn-connid
                                         im_fldate = sdyn_conn-fldate ).
          MESSAGE s005(bc401)
            WITH sdyn_conn-carrid sdyn_conn-connid sdyn_conn-fldate.
        CATCH cx_wait_list INTO r_exc.
          text = r_exc->get_text( ).
          MESSAGE s901(bc401) WITH sdyn_conn-carrid sdyn_conn-connid.
      ENDTRY.

    WHEN 'SHOW'.  "##########################################
      DATA: it_customer_list TYPE STANDARD TABLE OF bc401_typd_cust.
      DATA: wa_cust LIKE LINE OF it_customer_list.
      DATA: r_customer_list TYPE TABLE OF REF TO lcl_customer.
      DATA: r_cust TYPE REF TO lcl_customer.

      r_waitlist = r_buffer->get_wait_list(
                            im_carrid = sdyn_conn-carrid
                            im_connid = sdyn_conn-connid
                            im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        r_waitlist->get_wait_list( IMPORTING
                           ex_wait_list = r_customer_list ).
        n_o_lines = LINES( r_customer_list ).

        IF n_o_lines > 0.
          CLEAR it_customer_list.
          LOOP AT r_customer_list INTO r_cust.
            r_cust->get_attributes( IMPORTING ex_cust = wa_cust ).
            INSERT wa_cust INTO TABLE it_customer_list.
          ENDLOOP.

          " show dynpro with all customers and their data
          CALL FUNCTION 'BC401_DISPLAY_DATA'
            EXPORTING
              im_list = it_customer_list.
        ELSE.
          MESSAGE s903(bc401)
                        WITH sdyn_conn-carrid sdyn_conn-connid
                        sdyn_conn-fldate.
*         The waitinglist for flight &1 &2 &3 has no entries !

        ENDIF.
      ELSE.
        MESSAGE s002(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       There is no waitinglist for flight Flug &1 &2 &3 !

      ENDIF.

    WHEN 'DELETE'.   "##########################################
      TRY.
          r_buffer->delete_wait_list( EXPORTING
                            im_carrid = sdyn_conn-carrid
                            im_connid = sdyn_conn-connid
                            im_fldate = sdyn_conn-fldate ).

          MESSAGE s906(bc401) WITH
              sdyn_conn-carrid sdyn_conn-connid sdyn_conn-fldate.
*       Waitinglist for flight &1 &2 &3 has been deleted succesfully !
        CATCH cx_wait_list INTO r_exc.
          text = r_exc->get_text( ).
          MESSAGE text TYPE 'S'.
      ENDTRY.

    WHEN 'FIRST'.   "##########################################
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                              im_connid = sdyn_conn-connid
                              im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        TRY.
            r_waitlist->get_first( ).
            MESSAGE s907(bc401)
                      WITH sdyn_conn-carrid sdyn_conn-connid
                      sdyn_conn-fldate.
*         The first customer on waitinglist &1 &2 &3
*         has been deleted.

          CATCH cx_wait_list INTO r_exc.
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.
      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       There is no waitinglist for flight &1 &2 &3 !
      ENDIF.


    WHEN 'ADD'.   "##########################################
      IF scustom-id IS INITIAL.
        MESSAGE s908(bc401).
*       Please enter a correct customernumber !
        EXIT.
      ENDIF.
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                            im_connid = sdyn_conn-connid
                            im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        TRY.
            CREATE OBJECT r_customer EXPORTING im_id = scustom-id
                                        im_name = scustom-name
                                        im_street = scustom-street
                                        im_city = scustom-city
                                        im_app_date = sy-datum.
            r_waitlist->add( r_customer ).
            MESSAGE s910(bc401)
                  WITH scustom-id sdyn_conn-carrid sdyn_conn-connid
                       sdyn_conn-fldate.
*           Customer &1 was appended to waitinglist for flight &2 &3 &4
          CATCH cx_wait_list INTO r_exc.  "wann könnte das passieren ???
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.

      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       There is no waitinglist for flight &1 &2 &3 !
      ENDIF.


    WHEN 'DEL'.   "##########################################
      IF scustom-id IS INITIAL.
        MESSAGE s908(bc401).
*       Please select a valid customernumber !
        EXIT.
      ENDIF.
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                             im_connid = sdyn_conn-connid
                             im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        IF NOT r_customer IS BOUND.
          MESSAGE s911(bc401).
        ELSE.
          TRY.
              r_waitlist->delete( r_customer ).
              MESSAGE s912(bc401)
               WITH scustom-id sdyn_conn-carrid sdyn_conn-connid
               sdyn_conn-fldate.
*        Customer &1 was deleted from waitinglist for flight &2 &3 &4 !


            CATCH cx_wait_list INTO r_exc.
              text = r_exc->get_text( ).
              MESSAGE text TYPE 'I'.
          ENDTRY.
        ENDIF.
      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       There is no waitinglist for flight &1 &2 &3 !
      ENDIF.

    WHEN 'POS'.    "##########################################
      DATA pos LIKE sy-tabix.
      DATA flight TYPE string.
      DATA fldate(10) TYPE c.

      IF scustom-id IS INITIAL.
        MESSAGE s908(bc401).
*       Please enter a valid customernumber !
        EXIT.
      ENDIF.
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                            im_connid = sdyn_conn-connid
                            im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        TRY.
            CREATE OBJECT r_customer EXPORTING im_id = scustom-id
                                        im_name = scustom-name
                                        im_street = scustom-street
                                        im_city = scustom-city
                                        im_app_date = sy-datum.
            r_waitlist->get_pos( EXPORTING  im_customer = r_customer
                                 IMPORTING  ex_pos      = pos ).
            WRITE sdyn_conn-fldate TO fldate.
            CONCATENATE sdyn_conn-carrid sdyn_conn-connid fldate
              INTO flight SEPARATED BY space.
            MESSAGE i913(bc401) WITH scustom-id flight pos.
*           Customer &1 is held on list for flight &2 at position &3
          CATCH cx_wait_list INTO r_exc.
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.

      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       There is no waitinglist for flight &1 &2 &3 !
      ENDIF.

  ENDCASE.

ENDMODULE.                 " user_command_0100  INPUT


*&---------------------------------------------------------------------*
*&      Module  check_flight  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_flight INPUT.
  SELECT SINGLE * FROM sflight INTO wa_sflight
      WHERE      carrid = sdyn_conn-carrid
            AND  connid = sdyn_conn-connid
            AND  fldate = sdyn_conn-fldate.

  IF sy-subrc <> 0.
    MESSAGE e904(bc401).
*   Please select a valid flight !
  ENDIF.
ENDMODULE.                 " check_flight  INPUT


*&---------------------------------------------------------------------*
*&      Module  exit  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  CASE ok_code.
    WHEN 'CANCEL'.
      CLEAR: scustom, sdyn_conn.
      LEAVE TO SCREEN 100.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.

ENDMODULE.                 " exit  INPUT
