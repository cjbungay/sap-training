*----------------------------------------------------------------------*
*   INCLUDE BC414T_BOOKINGS_06F06
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  CREATE_CHANGE_DOCUMENTS
*&---------------------------------------------------------------------*
FORM create_change_documents.
************************************************************************
* a) Create a change document for each booking, which is changed on the
*    DB table SBOOK: Loop over the internal table ITAB_SBOOK_MODIFY
*    (containing all modified dataset) and read the corresponding
*    original dataset from the internal table ITAB_CD (into the workarea
*    *sbook).
* b) Define an object key from the key fields of sbook (you may use
*    the ABAP statement CONCATENATE)
* c) Fill interface parameters, which are used by the generated
*    function module
* d) add the PERFORM statement for the generated form encapsulating the
*    creation of the change document.
************************************************************************
ENDFORM.                               " CREATE_CHANGE_DOCUMENTS
