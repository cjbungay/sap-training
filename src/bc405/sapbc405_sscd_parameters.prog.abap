*&---------------------------------------------------------------------*
*& Report  SAPBC405_SSCD_PARAMETERS                                    *
*&                                                                     *
*&---------------------------------------------------------------------*
*&    Defining selection criteria (PARAMETERS):                        *
*&      -   with default values                                        *
*&      -   using the SPA/GPA memory                                   *
*&      -   obligatory                                                 *
*&---------------------------------------------------------------------*

REPORT  SAPBC405_SSCD_PARAMETERS MESSAGE-ID BC405.

*  Defining selection criteria (PARAMETERS)
PARAMETERS: PA_TXT(50) TYPE C DEFAULT 'Dies ist ein Textfeld ...'(001),
            PA_CNT     TYPE I MEMORY ID CNT OBLIGATORY.

DO PA_CNT TIMES.
 WRITE: / PA_TXT.
ENDDO.
