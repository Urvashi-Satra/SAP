CLASS zcl_passenger_plane DEFINITION
  PUBLIC
  INHERITING FROM zcl_plane
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
Methods constructor
Importing iv_manufacturer type string
          iv_type type string
          iv_seats type i.

 METHODS get_Attributes REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.

  data seats type i.
ENDCLASS.



CLASS zcl_passenger_plane IMPLEMENTATION.


  METHOD constructor.

    super->constructor( iv_manufacturer = iv_manufacturer iv_type = iv_type ).

  ENDMETHOD.

  METHOD get_attributes.
    rt_attributes = super->get_attributes( ).
    rt_attributes = value #( base rt_attributes ( name = 'SEATS' value = seats ) ).
  ENDMETHOD.

ENDCLASS.
