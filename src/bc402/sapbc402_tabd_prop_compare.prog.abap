*&---------------------------------------------------------------------*
*& Report  SAPBC402_TABD_PROP_COMPARE                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Runtime comparison for algorithms of programs                       *
*& - SAPBC402_TABD_TABLE_PROPS_0  --> short program_0                  *
*& - SAPBC402_TABD_TABLE_PROPS_1  --> short program_1                  *
*& - SAPBC402_TABD_TABLE_PROPS_2  --> short program_2                  *
*& - SAPBC402_TABD_TABLE_PROPS_3. --> short program_3                  *
*&                                                                     *
*& The algorithms of all four programs are implemented with the help   *
*& of four local classes. Runtime measurement is performed via         *
*& execution of a corresponding instance method.                       *
*&                                                                     *
*& Note: the results of the runtime measurement depend on the amount   *
*&       of data maintained in database tables SPFLI and SFLIGHT.      *
*&       In most cases the amount of data is too small to show         *
*&       a different improvement.                                      *
*&       Overall the runtime for all four algorithms are equal         *
*&       (all runtimes in range of few milli seconds).                 *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  sapbc402_tabd_prop_compare.

INCLUDE bc402_tabd_prop_comp_lcl1. " local class for program_0
INCLUDE bc402_tabd_prop_comp_lcl2. " local class for program_1
INCLUDE bc402_tabd_prop_comp_lcl3. " local class for program_2
INCLUDE bc402_tabd_prop_comp_lcl4. " local class for program_3

DATA: ref_1       TYPE REF TO lcl_class_1,
      ref_2       TYPE REF TO lcl_class_2,
      ref_3       TYPE REF TO lcl_class_3,
      ref_4       TYPE REF TO lcl_class_4,

      l_runtime   TYPE i,
      runtime_sum TYPE i.

PARAMETERS:
  p_num TYPE p DEFAULT 100.

START-OF-SELECTION.
  CLEAR: runtime_sum.
  CREATE OBJECT ref_1.

  DO p_num TIMES.
    CALL METHOD ref_1->execute IMPORTING runtime = l_runtime.
    runtime_sum = runtime_sum + l_runtime.
  ENDDO.

  runtime_sum = runtime_sum / p_num.

  WRITE: / text-001,
* (001) EN: 'first implementation, runtime in micro seconds'
            runtime_sum.
  CLEAR ref_1.
* ------------------------------------------------------------------
  CLEAR: runtime_sum.
  CREATE OBJECT ref_2.

  DO p_num TIMES.
    CALL METHOD ref_2->execute IMPORTING runtime = l_runtime.
    runtime_sum = runtime_sum + l_runtime.
  ENDDO.

  runtime_sum = runtime_sum / p_num.

  WRITE: / text-002,
* (002) EN: 'second implementation, runtime in micro seconds'
            runtime_sum.
  CLEAR ref_2.
* ------------------------------------------------------------------
  CLEAR: runtime_sum.
  CREATE OBJECT ref_3.

  DO p_num TIMES.
    CALL METHOD ref_3->execute IMPORTING runtime = l_runtime.
    runtime_sum = runtime_sum + l_runtime.
  ENDDO.

  runtime_sum = runtime_sum / p_num.

  WRITE: / text-003,
* (003) EN: 'third implementation, runtime in micro seconds'
            runtime_sum.
  CLEAR ref_3.
* ------------------------------------------------------------------
  CLEAR: runtime_sum.
  CREATE OBJECT ref_4.

  DO p_num TIMES.
    CALL METHOD ref_4->execute IMPORTING runtime = l_runtime.
    runtime_sum = runtime_sum + l_runtime.
  ENDDO.

  runtime_sum = runtime_sum / p_num.

  WRITE: / text-004,
* (002) EN: 'fourth implementation, runtime in micro seconds'
            runtime_sum.
  CLEAR ref_4.
