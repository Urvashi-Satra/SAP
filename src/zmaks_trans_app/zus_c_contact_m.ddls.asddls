@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for contract- Managed'
@Metadata.ignorePropagatedAnnotations: true

@Metadata.allowExtensions: true
define root view entity ZUS_C_Contact_M 
provider contract transactional_query
as projection on ZUS_I_CONTACT_M
{
    key ContactId,
    FirstName,
    MiddleName,
    LastName,
    Gender,
    Dob,
    Age,
    Telephone,
    Email,
    Active,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
