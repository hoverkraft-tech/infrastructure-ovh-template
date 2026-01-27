# OVH initial setup

## setup a new terraform app

NB: do this only once by OVH account (so there is a good chance it's already done)

- go to https://eu.api.ovh.com/createApp/
- fill name and description
- write down application key and secret in `.env`

## setup a new env

### get api credentials

- ask "user" rights on your OVH org and log in in OVH console with this user
- create a public cloud project
- launch the script `scripts/ovh-get-app-creds.sh`, follow the validation link and log in as your sub-user
- note the application key, application secret and consumer key and setup your .env accordingly

## setup vrack

![vrack creation](./images/schema_mksvrack.png)

- <https://www.ovh.com/fr/order/express/#/new/express/resume?products=~(~(planCode~'vrack~quantity~1~productId~'vrack))>
- wait a few minutes
- insert vrack id in `env.yaml`
