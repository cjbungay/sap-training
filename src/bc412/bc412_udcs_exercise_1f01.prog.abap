*----------------------------------------------------------------------*
***INCLUDE BC412_UDCS_EXERCISE_1F01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  free_control_ressources
*&---------------------------------------------------------------------*
*       free all control related ressources
*----------------------------------------------------------------------*
FORM free_control_ressources.
  CALL METHOD:
    ref_cont_left->free,
    ref_cont_right->free.

  FREE:
    ref_alv,
    ref_tree_model,

    ref_cont_left,
    ref_cont_right.
ENDFORM.                    " free_control_ressources

*---------------------------------------------------------------------*
*       FORM create_node_table                                        *
*---------------------------------------------------------------------*
*       build up a hierarchy consisting of                            *
*       carriers, connections and flight dates                        *
*---------------------------------------------------------------------*
*  -->  P_IT_NODES                                                    *
*---------------------------------------------------------------------*
FORM create_node_table CHANGING p_it_nodes LIKE it_nodes.

  DATA:
    l_wa_node LIKE LINE OF p_it_nodes,
    date_text(10) TYPE c.

  l_wa_node-node_key   = 'ROOT'.
  l_wa_node-isfolder   = 'X'.
  l_wa_node-expander   = space.
  l_wa_node-text       = text-car.
  INSERT l_wa_node INTO TABLE p_it_nodes.

* scarr-nodes:
  CLEAR l_wa_node.
  LOOP AT it_scarr INTO wa_scarr.
    CLEAR l_wa_node.
    l_wa_node-node_key   = wa_scarr-carrid.
    l_wa_node-relatkey   = 'ROOT'.
    l_wa_node-relatship  = cl_simple_tree_model=>relat_last_child.
    l_wa_node-isfolder   = 'X'.
    l_wa_node-expander   = space.
    l_wa_node-text       = wa_scarr-carrname.
    INSERT l_wa_node INTO TABLE p_it_nodes.
  ENDLOOP.

* spfli-nodes:
  CLEAR l_wa_node.
  LOOP AT it_spfli INTO wa_spfli.
    CLEAR l_wa_node.
    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                INTO l_wa_node-node_key
                SEPARATED BY c_sep.
    l_wa_node-relatkey   = wa_spfli-carrid.
    l_wa_node-relatship  = cl_simple_tree_model=>relat_last_child.
    l_wa_node-isfolder   = 'X'.
    l_wa_node-expander   = 'X'.
*   otherwise event expand_no_children couldn't be raised!

    CONCATENATE wa_spfli-carrid
                wa_spfli-connid
                ':'
                wa_spfli-cityfrom
                '->'
                wa_spfli-cityto
                INTO l_wa_node-text
                SEPARATED BY space.
    INSERT l_wa_node INTO TABLE p_it_nodes.
  ENDLOOP.

ENDFORM.                               " CREATE_NODE_TABLE
