Connect-AzAccount

$single = New-Object System.Management.Automation.Host.ChoiceDescription '&Single'
$multiple = New-Object System.Management.Automation.Host.ChoiceDescription '&Multiple'
$suboptions = [System.Management.Automation.Host.ChoiceDescription[]] ($single, $multiple)

$SubTitle = 'Single or Multiple Subscription Access'
$submessage = 'Please select whether to grant for all subscriptions or just a single one'
$subresult = $host.ui.PromptForChoice($subtitle, $submessage, $suboptions, 1)

if ($subresult -eq 0) {
    Get-AzSubscription | Out-GridView -Title "Select Subscription" -PassThru | Select-AzSubscription
    New-AzDeployment -location uksouth -TemplateUri "https://raw.githubusercontent.com/Cisilion/Lighthouse/main/CisilionBilling.json"

}

if ($subresult -eq 1) {
$subs = Get-AzSubscription
    foreach ($sub in $subs) {
        Select-AzSubscription -SubscriptionId $sub.Id
        New-AzDeployment -location uksouth -TemplateUri "https://raw.githubusercontent.com/Cisilion/Lighthouse/main/CisilionBilling.json"
    }
}