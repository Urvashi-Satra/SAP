CLASS zcl_cargo_plane DEFINITION
  PUBLIC
  INHERITING FROM zcl_plane
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_manufacturing TYPE string
                iv_type          TYPE string
                iv_cargo         TYPE i.
    METHODS get_attributes REDEFINITION.
  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA cargo TYPE i.
ENDCLASS.



CLASS zcl_cargo_plane IMPLEMENTATION.

  METHOD constructor.

    super->constructor( iv_manufacturer = manufacturer iv_type = iv_type ).
    cargo = iv_cargo.
  ENDMETHOD.


  METHOD get_attributes.


* method uses protected attributes of superclass


    rt_attributes = VALUE #( ( name = 'MANUFACTURER' value = manufacturer )
    ( name = 'TYPE' value = type )
    ( name ='CARGO' value = cargo ) ).


  ENDMETHOD.
ENDCLASS.
