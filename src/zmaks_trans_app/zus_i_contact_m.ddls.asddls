@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for contact - managed'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZUS_I_CONTACT_M
  as select from zmaks_contact_m
{
  key contact_id      as ContactId,
      first_name      as FirstName,
      middle_name     as MiddleName,
      last_name       as LastName,
      gender          as Gender,
      dob             as Dob,
      age             as Age,
      telephone       as Telephone,
      email           as Email,
      active          as Active,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt
}
