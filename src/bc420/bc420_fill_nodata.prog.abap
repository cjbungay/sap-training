*----------------------------------------------------------------------*
*   INCLUDE BC420_FILL_NODATA                                          *
*----------------------------------------------------------------------*
form init changing p_rec p_nodata.
   field-symbols <f>.
   do.
     assign component sy-index of structure p_rec to <f>.
     if sy-subrc <> 0. exit. endif.
     <f> = p_nodata.
   enddo.
endform.                               " INIT
