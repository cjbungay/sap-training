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
  IF sy-subrc = 0.
    CREATE OBJECT r_customer EXPORTING im_id = scustom-id
                                       im_name = scustom-name
                                       im_street = scustom-street
                                       im_city = scustom-city
                                       im_app_date = sy-datum.
  ELSE.
    CLEAR: scustom-name, scustom-city.
    MESSAGE e916(bc401) WITH scustom-id.
*   Kundennummer & ist nicht vorhanden. Bitte Eingabe korrigieren!
  ENDIF.
ENDMODULE.                 " check_and_create_cust  INPUT


*&---------------------------------------------------------------------*
*&      Module  user_command_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
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
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                             im_connid = sdyn_conn-connid
                             im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        r_waitlist->get_wait_list( IMPORTING ex_wait_list = waitlist ).
        n_o_lines = LINES( waitlist ).

        IF n_o_lines > 0.
          clear it_wait_list.
          LOOP AT waitlist INTO r_cust.
            r_cust->get_attributes( IMPORTING ex_cust = wa_cust ).
            INSERT wa_cust INTO TABLE it_wait_list.
          ENDLOOP.

          CALL FUNCTION 'bc401_DISPLAY_DATA'
            EXPORTING
              im_list = it_wait_list.

        ELSE.
          MESSAGE s903(bc401)
                        WITH sdyn_conn-carrid sdyn_conn-connid
                        sdyn_conn-fldate.
*         Die Warteliste zum Flug &1 &2 &3 enthält keine Einträge!
        ENDIF.

      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       Keine Warteliste zum Flug &1 &2 &3 vorhanden!
      ENDIF.

    WHEN 'DELETE'.   "##########################################
      TRY.
          r_buffer->delete_wait_list( EXPORTING
                            im_carrid = sdyn_conn-carrid
                            im_connid = sdyn_conn-connid
                            im_fldate = sdyn_conn-fldate ).

          MESSAGE s906(bc401) WITH
              sdyn_conn-carrid sdyn_conn-connid sdyn_conn-fldate.
*       Warteliste zum Flug &1 &2 &3 wurde erfolgreich gelöscht!
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
*         Der erste Wartende aus der Warteliste zum Flug &1 &2 &3
*         wurde gelöscht.
          CATCH cx_bc401_empty_list INTO r_exc.
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.
      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       Keine Warteliste zum Flug &1 &2 &3 vorhanden!
      ENDIF.


    WHEN 'ADD'.   "##########################################
      IF scustom-id IS INITIAL.
        MESSAGE s008(bc401).
*       Bitte eine gültige Kundennummer auswählen!
        EXIT.
      ENDIF.
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                             im_connid = sdyn_conn-connid
                             im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        TRY.
            r_waitlist->add( r_customer ).
            MESSAGE s910(bc401)
                  WITH scustom-id sdyn_conn-carrid sdyn_conn-connid
                       sdyn_conn-fldate.
*           Kunde &1 in die Warteliste zum Flug &2 &3 &4 aufgenommen
          CATCH cx_wait_list INTO r_exc.  "wann könnte das passieren ???
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.

      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       Keine Warteliste zum Flug &1 &2 &3 vorhanden!
      ENDIF.


    WHEN 'DEL'.   "##########################################
      IF scustom-id IS INITIAL.
        MESSAGE s908(bc401).
*       Bitte eine gültige Kundennummer auswählen!
        EXIT.
      ENDIF.
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                             im_connid = sdyn_conn-connid
                             im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        TRY.
            r_waitlist->delete( r_customer ).
            MESSAGE s912(bc401)
             WITH scustom-id sdyn_conn-carrid sdyn_conn-connid
             sdyn_conn-fldate.
*          Kunde &1 wurde von der Warteliste zum Flug &2 &3 &4 gelöscht!
          CATCH cx_wait_list INTO r_exc.
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.

      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       Keine Warteliste zum Flug &1 &2 &3 vorhanden!
      ENDIF.


    WHEN 'POS'.    "##########################################

      DATA pos LIKE sy-tabix.
      DATA flight TYPE string.
      DATA fldate(10) TYPE c.

      IF scustom-id IS INITIAL.
        MESSAGE s908(bc401).
*       Bitte eine gültige Kundennummer auswählen!
        EXIT.
      ENDIF.
     r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                             im_connid = sdyn_conn-connid
                             im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
        TRY.
            r_waitlist->get_pos( EXPORTING  im_customer = r_customer
                                 IMPORTING  ex_pos      = pos ).
            WRITE sdyn_conn-fldate TO fldate.
            CONCATENATE sdyn_conn-carrid sdyn_conn-connid fldate
              INTO flight SEPARATED BY space.
            MESSAGE i913(bc401) WITH scustom-id flight pos.
*           Kunde &1 steht auf der Warteliste zum Flug &2 an Position &3
          CATCH cx_wait_list INTO r_exc.
            text = r_exc->get_text( ).
            MESSAGE text TYPE 'I'.
        ENDTRY.

      ELSE.
        MESSAGE s902(bc401) WITH sdyn_conn-carrid sdyn_conn-connid
        sdyn_conn-fldate.
*       Keine Warteliste zum Flug &1 &2 &3 vorhanden!
      ENDIF.


    WHEN 'STATWL' OR 'STATCU' OR 'STATPR'. "########################
      IF save_ok = 'STATWL'.
      r_waitlist = r_buffer->get_wait_list( im_carrid = sdyn_conn-carrid
                             im_connid = sdyn_conn-connid
                             im_fldate = sdyn_conn-fldate ).
      IF r_waitlist IS BOUND.
          r_if_status = r_waitlist.
        ELSE.
          MESSAGE s902(bc401)
           WITH sdyn_conn-carrid sdyn_conn-connid sdyn_conn-fldate.
*          Keine Warteliste zum Flug &1 &2 &3 vorhanden!
          EXIT.
        ENDIF.
      ENDIF.

      IF save_ok = 'STATCU'.
        IF scustom-id IS INITIAL.
          MESSAGE s908(bc401).
*         Bitte eine gültige Kundennummer auswählen!
          EXIT.
        ENDIF.

        r_if_status = r_customer.

      ENDIF.

      IF save_ok = 'STATPR'.
        r_if_status = r_log.
      ENDIF.

      r_if_status->display_status( ).

    WHEN 'LOG'.   "##########################################
      r_log->display_log( ).

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
*   Bitte einen gültigen Flug auswählen
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
