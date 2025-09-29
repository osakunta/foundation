Create a new project through the Google Cloud Console

`pulumi login file://./pulumi-state`

`pulumi stack init prod`
`pulumi config set gcp:project <project id>`
`pulumi config set --secret organizationId <organizationId>`
`pulumi config set --secret billingAccount <billingAccountId>`

`pulumi up`

# migrate to cloud storage

`pulumi stack export --show-secrets --file local_state.json`
`pulumi login gs://osakunta-foundation-prod-pulumi-state`
`pulumi stack import --file local_state.json`
`rm local_state.json`
