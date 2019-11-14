*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_REF_GLOB_TYPE                                 *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*& The two auxiliary variables are necessary to demonstrate the        *
*& different effects. (With just two "GET REFERENCE OF p_cityfr"       *
*& the address would just be copied from the first generic reference   *
*& instead of from the input parameter. So again the correct type      *
*& definition would be retrieved which we didn't want to demonstrate.) *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT sapbc401_dynd_ref_glob_type .

PARAMETERS p_cityfr TYPE spfli-cityfrom      "global type
                    DEFAULT 'BERLIN'.

DATA:
  cityfrom       LIKE p_cityfr,
  cityfrom_again LIKE cityfrom,

  ref_gen    TYPE REF TO data,
  ref_cityto TYPE REF TO spfli-cityto.       "other global type!

FIELD-SYMBOLS <fs_gen> TYPE ANY.



START-OF-SELECTION.

  cityfrom       = p_cityfr.
  cityfrom_again = cityfrom.

* here dynamic type is just passed along:
  GET REFERENCE OF cityfrom INTO ref_gen.
  ASSIGN ref_gen->* TO <fs_gen>.
  WRITE <fs_gen> COLOR COL_POSITIVE.

* here static type not equal to dynamic type,
* static type "wins":
  GET REFERENCE OF cityfrom_again INTO ref_cityto.
  ASSIGN ref_cityto->* TO <fs_gen>.
  WRITE: 40 <fs_gen> COLOR COL_NEGATIVE.
