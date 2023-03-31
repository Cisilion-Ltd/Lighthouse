//this bicep file will deploy the necessary permissions for Cisilion to manage the selected subscription(s) and resources in your tenant

param mspOfferName string = 'Cisilion Licensing Services'
param mspOfferDescription string = 'Cisilion Azure Lighthouse Licensing Service'
param managedByTenantId string = '97e97f2e-2cf9-4a26-a1ea-57167f7debad'
param authorizations array = [ 
  {
    // Assign Reader Role to the 'Lighthouse - Azure  Readers'
    principalId: 'b0d840a2-0a35-45f4-8a88-e2d3f21949ce'
    principalIdDisplayName: 'Cisilion Azure Lighthouse Readers'
    roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
  }
]

param eligibleAuthorizations array = [
  {
    justInTimeAccessPolicy: {
      multiFactorAuthProvider: 'Azure'
      maximumActivationDuration: 'PT8H'
      managedByTenantApprovers: []
    }
    principalId: 'b0d840a2-0a35-45f4-8a88-e2d3f21949ce'
    principalIdDisplayName: 'Cisilion Azure Lighthouse Cost Management Contributor'
    roleDefinitionId: '434105ed-43f6-45c7-a02f-909b2ba83430'
  } 
]

var mspRegistrationName = guid(mspOfferName)
var mspAssignmentName = guid(mspOfferName)

resource mspRegistration_resource 'Microsoft.ManagedServices/registrationDefinitions@2022-10-01' = {
  name: mspRegistrationName
  properties: {
    description: mspOfferDescription
    registrationDefinitionName:mspRegistrationName
    managedByTenantId: managedByTenantId
    authorizations: authorizations
    eligibleAuthorizations: eligibleAuthorizations
  }
  /*plan: {
    name: 
    product: 
    publisher: 
    version: 
  }*/
}

resource mspAssignment_resource 'Microsoft.ManagedServices/registrationAssignments@2022-10-01' = {
  name: mspAssignmentName
  properties: {
    registrationDefinitionId: mspRegistration_resource.id
  }
}

output mspOffer_output string = 'Managed by ${mspOfferName}'
output authorizations_output array = authorizations
