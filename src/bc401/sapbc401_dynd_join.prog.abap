*&---------------------------------------------------------------------*
*& Report  SAPBC401_DYND_JOIN                                          *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Dynamic SELECT could have been programmed as one single statement;  *
*& problem here is the INTO clause: No way to define it dynamically!   *
*&                                                                     *
*& Therefore some workaround with two SELECT into two string tables,   *
*& followed by a "collected" output.                                   *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc401_dynd_join              .

PARAMETERS:
  p_tab1  TYPE tabname16 DEFAULT 'SCARR',
  p_tab2  LIKE p_tab1    DEFAULT 'SPFLI',
  p_field TYPE fieldname DEFAULT 'CARRID'.

DATA d_ref TYPE REF TO data.

DATA from_clause TYPE string.

DATA:
  it_output1 TYPE STANDARD TABLE OF string,
  it_output2 LIKE it_output1,
  line TYPE string.



START-OF-SELECTION.
  CONCATENATE p_tab1 'JOIN' p_tab2 'ON' p_tab1
              INTO from_clause
              SEPARATED BY space.

  CONCATENATE from_clause '~' p_field INTO from_clause.

  CONCATENATE from_clause '=' p_tab2
              INTO from_clause
              SEPARATED BY space.

  CONCATENATE from_clause '~' p_field
              INTO from_clause.

  CREATE DATA d_ref TYPE (p_tab1).
  PERFORM dyn_select
              USING
                 from_clause
                 d_ref
              CHANGING
                it_output1.



  CREATE DATA d_ref TYPE (p_tab2).
  PERFORM dyn_select
              USING
                 from_clause
                 d_ref
              CHANGING
                it_output2.

  LOOP AT it_output1 INTO line.
    WRITE: / line.
    READ TABLE it_output2 INTO line INDEX sy-tabix.
    WRITE: /2 line.
    SKIP.
  ENDLOOP.


*---------------------------------------------------------------------*
*  FORM dyn_select
*---------------------------------------------------------------------*
*  selects data with given FROM-clause into given output table
*  target data object is defined dynamically
*  data are seperated into components
*  components of one data set are put into one single table line each
*---------------------------------------------------------------------*
*  -->  P_FROM_CLAUSE
*  -->  P_D_REF
*  -->  P_IT_OUTPUT
*---------------------------------------------------------------------*
FORM dyn_select USING    p_from_clause TYPE string
                         p_d_ref       TYPE REF TO data
                CHANGING p_it_output   LIKE it_output1.

  DATA:
    l_comp TYPE string,
    l_line TYPE string.

  FIELD-SYMBOLS:
    <fs_wa>   TYPE ANY,
    <fs_comp> TYPE ANY.

  ASSIGN p_d_ref->* TO <fs_wa>.

  SELECT * FROM (p_from_clause)
           INTO CORRESPONDING FIELDS OF <fs_wa>.

    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_wa> TO <fs_comp>.
      IF sy-subrc = 0.
        l_comp = <fs_comp>.
        CONCATENATE l_line l_comp INTO l_line
                    SEPARATED BY space.
      ELSE.
        INSERT l_line INTO TABLE p_it_output.
        CLEAR l_line.
        EXIT.
      ENDIF.
    ENDDO.

  ENDSELECT.
ENDFORM.                    "dyn_select
