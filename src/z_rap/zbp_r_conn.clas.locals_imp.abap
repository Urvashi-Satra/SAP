CLASS lhc_zr_flight DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Conn
        RESULT result,
      checkSemanticKey FOR VALIDATE ON SAVE
        IMPORTING keys FOR Conn~checkSemanticKey,
      checkAirline FOR VALIDATE ON SAVE
        IMPORTING keys FOR Conn~checkAirline,
      checkDestiation FOR VALIDATE ON SAVE
        IMPORTING keys FOR Conn~checkDestiation,
      GetCities FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Conn~GetCities.
ENDCLASS.

CLASS lhc_zr_flight IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD checkSemanticKey.
    DATA: read_keys   TYPE TABLE FOR READ IMPORT zr_flight,
          connections TYPE TABLE FOR READ RESULT zr_flight.

    DATA reported_record LIKE LINE OF reported-conn.
    DATA failed_record LIKE LINE OF failed-conn.

    read_keys = CORRESPONDING #( keys ).

    READ ENTITIES OF zr_flight IN LOCAL MODE
       ENTITY Conn
       FIELDS ( uuid CarrierID ConnectionID )
         WITH read_keys
       RESULT connections.

    LOOP AT connections INTO DATA(connection).

      SELECT FROM z99flight
      FIELDS uuid
      WHERE carrier_id = @connection-CarrierID
      AND connection_id = @connection-ConnectionID
      AND uuid <> @connection-uuid

      UNION
       SELECT FROM zconn_d
      FIELDS uuid
      WHERE carrierid = @connection-CarrierID
      AND connectionid = @connection-ConnectionID
      AND uuid <> @connection-uuid

      INTO TABLE @DATA(check_result).

      IF check_result IS NOT INITIAL.

        DATA(message) = me->new_message(
                         id = 'ZTEXT' "Message class name
                         number = '001' " Message number
                         severity = ms-error
                         v1 = connection-CarrierID
                         v2 = connection-ConnectionID
                      ).


        " Fill reported structure

        CLEAR reported_record.
        "reported record relates to the same transaction key as the connection instance.
        reported_record-%tky                       = connection-%tky. "%tky =  Transaction Key.
        reported_record-%msg                       = message.
        "The CarrierID element of this record should be marked as changed or highlighted in the response.
        reported_record-%element-CarrierID         = if_abap_behv=>mk-on.
        reported_record-%element-ConnectionID      = if_abap_behv=>mk-on.
        "if_abap_behv=>mk-on
        "Meaning: Marker constant for RAP.
        "mk-on is used to mark an element as changed or relevant for reporting.

        APPEND reported_record TO reported-conn.


        CLEAR failed_record.
        failed_record-%tky = connection-%tky.

        APPEND failed_record TO failed-conn.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD checkAirline.
    DATA reported_record LIKE LINE OF reported-conn.
    DATA failed_record LIKE LINE OF failed-conn.


    "Step 1 - Read Data from behavior defination - ZR_FLIGHT ENTITY CONN for field CARRIERID.
    READ ENTITIES OF zr_flight IN LOCAL MODE
    ENTITY Conn
    FIELDS ( CarrierID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(carrierIdData).


    "STEP 2 : LOOP over carrierIdData and validate - airline that the user has entered actually exists.
    LOOP AT carrieriddata INTO DATA(carrierRowData).
      SELECT SINGLE
      FROM /DMO/I_Carrier
      FIELDS @abap_true "Instead of selecting actual columns, it selects the constant abap_true (which equals 'X').
                         "This is a performance optimization: you don’t need actual data, just want to know if a row exists.
      WHERE AirlineID = @carrierRowData-CarrierID
      INTO @DATA(exists).

      "step 3 - validate if airline already exists and log error message .
      IF exists = abap_true.

        DATA(message) = me->new_message(
                     id = 'ZTEXT' "Message class name
                     number = '002' " Message number
                     severity = ms-error
                     v1 = carrierRowData-CarrierID

                  ).


        " Fill reported structure

        CLEAR reported_record.
        reported_record-%tky                       = carrierrowdata-%tky.
        reported_record-%msg                       = message.
        reported_record-%element-CarrierID         = if_abap_behv=>mk-on.
        reported_record-%element-ConnectionID      = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-conn.


        CLEAR failed_record.
        failed_record-%tky = carrierrowdata-%tky.

        APPEND failed_record TO failed-conn.


      ENDIF.

    ENDLOOP.




  ENDMETHOD.

  METHOD checkDestiation.
    DATA reported_record LIKE LINE OF reported-conn.
    DATA failed_record LIKE LINE OF failed-conn.

    READ ENTITIES OF zr_flight IN LOCAL MODE
    ENTITY conn
    FIELDS ( AirportFromID AirportToID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(destinationData).

    LOOP AT destinationData INTO DATA(destData).

      IF destData-AirportFromID = destData-AirportToID.
        DATA(message) = me->new_message(
        id = 'ZTEXT' number = '003' severity = ms-error v1 = destData-AirportFromID v2 = destData-AirportToID
         ).

        CLEAR reported_record.
        reported_record-%tky = destData-%tky.
        reported_record-%msg = message.
        reported_record-%element-airportfromid = if_abap_behv=>mk-on.
        reported_record-%element-airporttoid = if_abap_behv=>mk-on.

        APPEND reported_record TO reported-conn.

        CLEAR failed_record.
        failed_record-%tky = destdata-%tky.
        APPEND failed_record TO failed-conn.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  "Determination.
  METHOD GetCities.

    DATA getCitiesDatas_upd TYPE TABLE FOR UPDATE zr_flight.


    READ ENTITIES OF zr_flight
    ENTITY Conn
    FIELDS ( AirportFromID AirportToID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(getCitiesDatas).


    LOOP AT getCitiesDatas INTO DATA(getCitiesData).
      SELECT SINGLE
      FROM /DMO/I_Airport
      FIELDS City , CountryCode
      WHERE AirportID = @getcitiesdata-AirportFromID
      INTO ( @getcitiesdata-CityFrom , @getcitiesdata-CountryFrom ).

      SELECT SINGLE
      FROM /dmo/i_airport
      FIELDS City , CountryCode
      WHERE airportId = @getcitiesdata-AirportToID
      INTO ( @getcitiesdata-CityTo , @getcitiesdata-CountryTo  ).

      MODIFY getcitiesdatas FROM getcitiesdata.
    ENDLOOP.

    getCitiesDatas_upd = CORRESPONDING #( getcitiesdatas ).

    MODIFY ENTITIES OF zr_flight IN LOCAL MODE
    ENTITY Conn
    UPDATE FIELDS ( CityTo CountryTo CityFrom CountryFrom )
    WITH getcitiesdatas_upd
    REPORTED DATA(reported_records).

    reported-conn = CORRESPONDING #( reported_records-conn ).

  ENDMETHOD.

ENDCLASS.
