CLASS zcl_plane DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF ts_attributes,
              name  TYPE string,
              value TYPE string,
            END OF ts_ATTRIBUTES.
    TYPES: tt_attributes TYPE SORTED TABLE OF ts_attributes WITH UNIQUE KEY name.

    METHODS constructor
        IMPORTING
            iv_manufacturer Type string
            iv_type type string.

     Methods : get_attributes
     returning value(rt_attributes) type tt_attributes.
        interfaces if_oo_adt_classrun .
  PROTECTED SECTION.
    DATA manufacturer TYPE string.
    DATA type TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_plane IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  ENDMETHOD.
  METHOD constructor.
    manufacturer = iv_manufacturer .
    type = iv_type.
  ENDMETHOD.

  METHOD get_attributes.
    rt_attributes = VALUE #(
                            ( name = 'MANUFACTURER' value = manufacturer )
                            ( name = 'TYPE' value = type )
                            ).
  ENDMETHOD.

ENDCLASS.




