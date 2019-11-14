*&---------------------------------------------------------------------*
*& Report  SAPBC401_PRJD_SHAREDOBJECT
*&
*&---------------------------------------------------------------------*
*& Example for shared objects
*&
*&---------------------------------------------------------------------*

REPORT  sapbc401_prjd_sharedobject.


DATA: r_handle TYPE REF TO cl_shm_area_handle.
DATA: r_root TYPE REF TO cl_shm_area_root.

START-OF-SELECTION.
*#######################

  r_handle = cl_shm_area_handle=>attach_for_write( ).

  CREATE OBJECT r_root AREA HANDLE r_handle.
  r_root->text = 'Hiermit wird die Variable im Shared Object gefüllt'.

  r_handle->set_root( r_root ).

  r_handle->detach_commit( ).

*** now we will read the shared object again out of buffer
*** of course this could happen later in another program !

  r_handle = cl_shm_area_handle=>attach_for_read( ).
  WRITE: / r_handle->root->text.

  r_handle->detach( ).
