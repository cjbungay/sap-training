FUNCTION ALE_CONTACT_UPDATE.
*"----------------------------------------------------------------------
*"*"Lokale Schnittstelle:
*"       IMPORTING
*"             VALUE(CONTACT) TYPE  BAPI0417_2-PARNR
*"             VALUE(CUSTOMER) TYPE  BAPI0417_2-KUNNR
*"             VALUE(TELEPHONE) TYPE  BAPI0417_2-TELF1
*"             VALUE(ENTERED) TYPE  BAPI0417_2-ERNAM
*"             VALUE(SERIAL_ID) LIKE  SERIAL-CHNUM DEFAULT '0'
*"       TABLES
*"              RECEIVERS STRUCTURE  BDI_LOGSYS
*"              COMMUNICATION_DOCUMENTS STRUCTURE  SWOTOBJID OPTIONAL
*"              APPLICATION_OBJECTS STRUCTURE  SWOTOBJID OPTIONAL
*"       EXCEPTIONS
*"              ERROR_CREATING_IDOCS
*"----------------------------------------------------------------------
*----------------------------------------------------------------------*
*  this function module is generated                                   *
*          never change it manually, please!        13.11.2001         *
*----------------------------------------------------------------------*

  DATA: IDOC_CONTROL  LIKE BDICONTROL,
        IDOC_DATA     LIKE EDIDD      OCCURS 0 WITH HEADER LINE,
        IDOC_RECEIVER LIKE BDI_LOGSYS OCCURS 0 WITH HEADER LINE,
        IDOC_COMM     LIKE EDIDC      OCCURS 0 WITH HEADER LINE,
        SYST_INFO     LIKE SYST.


* create IDoc control-record                                           *
  IDOC_CONTROL-MESTYP = 'CONTACT_UPDATE'.
  IDOC_CONTROL-IDOCTP = 'CONTACT_UPDATE01'.
  IDOC_CONTROL-SERIAL = SY-DATUM.
  IDOC_CONTROL-SERIAL+8 = SY-UZEIT.

  IDOC_RECEIVER[] = RECEIVERS[].

*   call subroutine to create IDoc data-record                         *
    clear: syst_info, IDOC_DATA.
    REFRESH IDOC_DATA.
    PERFORM IDOC_CONTACT_UPDATE
            TABLES
                IDOC_DATA
            USING
                CONTACT
                CUSTOMER
                TELEPHONE
                ENTERED
                SYST_INFO
                .
    IF NOT SYST_INFO IS INITIAL.
      MESSAGE ID SYST_INFO-MSGID
            TYPE SYST_INFO-MSGTY
          NUMBER SYST_INFO-MSGNO
            WITH SYST_INFO-MSGV1 SYST_INFO-MSGV2
                 SYST_INFO-MSGV3 SYST_INFO-MSGV4
      RAISING ERROR_CREATING_IDOCS.
    ENDIF.

*   distribute idocs                                                   *
    CALL FUNCTION 'ALE_IDOCS_CREATE'
         EXPORTING
              IDOC_CONTROL                = IDOC_CONTROL
              OBJ_TYPE                    = 'CON0417'
              CHNUM                       = SERIAL_ID
         TABLES
              IDOC_DATA                   = IDOC_DATA
              RECEIVERS                   = IDOC_RECEIVER
*             CREATED_IDOCS               =                            *
              CREATED_IDOCS_ADDITIONAL    = IDOC_COMM
              APPLICATION_OBJECTS         = APPLICATION_OBJECTS
         EXCEPTIONS
              IDOC_INPUT_WAS_INCONSISTENT = 1
              OTHERS                      = 2
              .
    IF SY-SUBRC <> 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
      RAISING ERROR_CREATING_IDOCS.
    ENDIF.

    IF COMMUNICATION_DOCUMENTS IS REQUESTED.
      LOOP AT IDOC_COMM.
        CLEAR COMMUNICATION_DOCUMENTS.
        COMMUNICATION_DOCUMENTS-OBJTYPE  = 'IDOC'.
        COMMUNICATION_DOCUMENTS-OBJKEY   = IDOC_COMM-DOCNUM.
        COMMUNICATION_DOCUMENTS-LOGSYS   = IDOC_COMM-RCVPRN.
        COMMUNICATION_DOCUMENTS-DESCRIBE = SPACE.
        APPEND COMMUNICATION_DOCUMENTS.
      ENDLOOP.
    ENDIF.

* applications do commit work to trigger communications                *





ENDFUNCTION.


* subroutine creating IDoc data-record                                 *
form IDOC_CONTACT_UPDATE
     tables
         idoc_data structure edidd
     using
         CONTACT like
           BAPI0417_2-PARNR
         CUSTOMER like
           BAPI0417_2-KUNNR
         TELEPHONE like
           BAPI0417_2-TELF1
         ENTERED like
           BAPI0417_2-ERNAM
         syst_info like syst
         .

  data:  E1CONTACT_UPDATE like E1CONTACT_UPDATE.

* go through all IDoc-segments                                         *

* for segment 'E1CONTACT_UPDATE'                                       *
    clear: E1CONTACT_UPDATE,
           idoc_data.
    move CONTACT
      to E1CONTACT_UPDATE-CONTACT.
    move CUSTOMER
      to E1CONTACT_UPDATE-CUSTOMER.
    move TELEPHONE
      to E1CONTACT_UPDATE-TELEPHONE.
    move ENTERED
      to E1CONTACT_UPDATE-ENTERED.
   if not E1CONTACT_UPDATE is initial.
    idoc_data-sdata  = E1CONTACT_UPDATE.
    idoc_data-segnam = 'E1CONTACT_UPDATE'.
    append idoc_data.
   endif.


* end of through all IDoc-segments                                     *

endform.                               " IDOC_CONTACT_UPDATE
