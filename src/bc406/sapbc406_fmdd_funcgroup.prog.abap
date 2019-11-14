*&---------------------------------------------------------------------*
*& Report  SAPbc406_FMDD_FUNCGROUP                                     *
*&                                                                     *
*&---------------------------------------------------------------------*
*& navigates through a waiting list dialog (only "quick and dirty");   *
*& waiting list itself is maintained by a function group               *
*&---------------------------------------------------------------------*

REPORT  sapbc406_fmdd_funcgroup MESSAGE-ID bc406.

DATA:
  wa_cust TYPE bc406_typd_cust.


* for user dialog:
******************
TABLES scustom.

DATA:
  position LIKE sy-tabix,
  new_pos  LIKE sy-tabix.

DATA:
  ok_code LIKE sy-ucomm,
  save_ok LIKE ok_code.



*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET TITLEBAR 'NAVI'.
ENDMODULE.                             " STATUS_0100  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_TO_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE trans_to_0100 OUTPUT.
  MOVE-CORRESPONDING wa_cust TO scustom.
ENDMODULE.                             " TRANS_TO_0100  OUTPUT



*&---------------------------------------------------------------------*
*&      Module  GOOD_BYE_0100  INPUT
*&---------------------------------------------------------------------*
MODULE good_bye_0100 INPUT.
  CHECK ok_code = 'EXIT'.
  LEAVE PROGRAM.
ENDMODULE.                             " GOOD_BYE_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  TRANS_FROM_0100  INPUT
*&---------------------------------------------------------------------*
*&      database access necessary to avoid inconsistent customer data
*&---------------------------------------------------------------------*
MODULE trans_from_0100 INPUT.
  IF ok_code = 'NEW'.
    CLEAR wa_cust.
    MOVE:
      scustom-name TO wa_cust-name,
      scustom-city TO wa_cust-city.
    MESSAGE i198.
  ELSE.
    SELECT SINGLE id name city FROM scustom
                               INTO CORRESPONDING FIELDS OF wa_cust
                               WHERE id = scustom-id.
    IF sy-subrc <> 0.
      CLEAR ok_code.
      MESSAGE i151.
    ENDIF.
  ENDIF.
ENDMODULE.                             " TRANS_FROM_0100  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.

* add a waiting customer:
*************************
    WHEN 'ADD'.
      CALL FUNCTION 'BC406_FMDD_WAIT_ADD'
           EXPORTING
                ip_cust = wa_cust
           EXCEPTIONS
                in_list = 1
                OTHERS  = 2.

      CASE sy-subrc.
        WHEN 0.
          CALL FUNCTION 'BC406_FMDD_WAIT_DISPLAY'
               EXCEPTIONS
                    list_empty = 1
                    OTHERS     = 2.
          CASE sy-subrc.
            WHEN 1.
              MESSAGE ID sy-msgid
                      TYPE 'I'
                      NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            WHEN 2.
              MESSAGE i701.
          ENDCASE.

        WHEN 1.
          MESSAGE ID sy-msgid
                  TYPE 'I'
                  NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        WHEN 2.
          MESSAGE i701.
      ENDCASE.


* delete a waiting customer:
****************************
    WHEN 'DEL'.
      CALL FUNCTION 'BC406_FMDD_WAIT_DELETE'
           EXPORTING
                ip_id       = wa_cust-id
           EXCEPTIONS
                not_in_list = 1
                OTHERS      = 2.
      CASE sy-subrc.
        WHEN 0.
          CALL FUNCTION 'BC406_FMDD_WAIT_DISPLAY'
               EXCEPTIONS
                    list_empty = 1
                    OTHERS     = 2.
          CASE sy-subrc.
            WHEN 1.
              MESSAGE ID sy-msgid
                      TYPE 'I'
                      NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            WHEN 2.
              MESSAGE i701.
          ENDCASE.

        WHEN 1.
          MESSAGE ID sy-msgid
                  TYPE 'I'
                  NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        WHEN 2.
          MESSAGE i701.
      ENDCASE.



* get the first waiting customer:
*********************************
    WHEN 'FIRST'.
      CLEAR wa_cust.
      CALL FUNCTION 'BC406_FMDD_WAIT_GET_FIRST'
           IMPORTING
                ep_cust    = wa_cust
           EXCEPTIONS
                list_empty = 1
                OTHERS     = 2.
      CASE sy-subrc.
        WHEN 0.
          MESSAGE s199.
        WHEN 1.
          MESSAGE ID sy-msgid
                  TYPE 'I'
                  NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        WHEN 2.
          MESSAGE i701.
      ENDCASE.

* get position of a waiting customer:
*************************************
    WHEN 'POS'.
      CALL FUNCTION 'BC406_FMDD_WAIT_GET_POS'
           EXPORTING
                ip_id       = wa_cust-id
           IMPORTING
                ep_pos      = position
           EXCEPTIONS
                not_in_list = 1
                OTHERS      = 2.
      CASE sy-subrc.
        WHEN 0.
          MESSAGE i201(BC406) WITH position.
        WHEN 1.
          MESSAGE ID sy-msgid
                  TYPE 'I'
                  NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        WHEN 2.
          MESSAGE i701.
      ENDCASE.



* move a waiting customer:
**************************
    WHEN 'SHIFT'.
      CALL FUNCTION 'BC406_FMDD_WAIT_SHIFT'
           EXPORTING
                ip_id       = wa_cust-id
                ip_new_pos  = new_pos
           EXCEPTIONS
                not_in_list = 1
                OTHERS      = 2.
      CASE sy-subrc.
        WHEN 0.
          CALL FUNCTION 'BC406_FMDD_WAIT_DISPLAY'
               EXCEPTIONS
                    list_empty = 1
                    OTHERS     = 2.
          CASE sy-subrc.
            WHEN 1.
              MESSAGE ID sy-msgid
                      TYPE 'I'
                      NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
            WHEN 2.
              MESSAGE i701.
          ENDCASE.

        WHEN 1.
          MESSAGE ID sy-msgid
                  TYPE 'I'
                  NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        WHEN 2.
          MESSAGE i701.
      ENDCASE.


* display the waiting list:
***************************
    WHEN 'SHOW'.
      CALL FUNCTION 'BC406_FMDD_WAIT_DISPLAY'
           EXCEPTIONS
                list_empty = 1
                OTHERS     = 2.
      CASE sy-subrc.
        WHEN 1.
          MESSAGE ID sy-msgid
                  TYPE 'I'
                  NUMBER sy-msgno
                  WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        WHEN 2.
          MESSAGE i701.
      ENDCASE.


* create a new entry for a customer (database table!)
*****************************************************
    WHEN 'NEW'.
      PERFORM create_customer USING wa_cust.


  ENDCASE.

ENDMODULE.                             " USER_COMMAND_0100  INPUT




*&---------------------------------------------------------------------*
*&      Form  CREATE_CUSTOMER
*&---------------------------------------------------------------------*
*       calls a transaction using a internal bdcdata table
*----------------------------------------------------------------------*
*      -->P_WA_CUST  customer data to create
*----------------------------------------------------------------------*
FORM create_customer USING value(p_wa_cust) LIKE wa_cust.

  DATA:
    wa_bdcdata TYPE bdcdata,
    it_bdcdata LIKE TABLE OF wa_bdcdata.

* fill the bdcdata table:
*************************
  wa_bdcdata-program  = 'SAPBC406_CALD_CREATE_CUSTOMER'.
  wa_bdcdata-dynpro   = 100.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = 'SCUSTOM-NAME'.
  wa_bdcdata-fval = p_wa_cust-name.
  APPEND wa_bdcdata TO it_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = 'SCUSTOM-CITY'.
  wa_bdcdata-fval = p_wa_cust-city.
  APPEND wa_bdcdata TO it_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = 'BDC_OKCODE'.
  wa_bdcdata-fval = 'SAVE'.
  APPEND wa_bdcdata TO it_bdcdata.

  CALL TRANSACTION 'BC406_CALD_CRE_CUST'
                   USING it_bdcdata
                   MODE 'N'.
  IF sy-subrc <> 0.
    MESSAGE i510 WITH 'BC406_CALD_CRE_CUS' sy-subrc.
  ENDIF.
ENDFORM.                               " CREATE_CUSTOMER
