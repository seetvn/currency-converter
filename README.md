# README
## Design choices

I chose to create two functions that handles the bulk of currency conversions within the CurrenciesController : one which checks for an implicit exchange rate if its between two non-Euro currencies and the other if the currency can be converted via a 'transit currency'.

I chose to store the currency exchange as a Rails model with (source,target,exchange rate and date) as the attributes. 

There is functionality to add new currencies but only legitimate ones are supported.

Errors are raised when the currency exchange on a certain doesn't exist and a currency doesn't exist.

Testing was only done manually and no scripts were used since I didn't have much time.

## Database Configuration

The web application uses SQLite as its default database. However, it's worth noting that the database can be changed, as Rails supports various database systems. If you want to switch to a different database, you can update the configuration in the `config/database.yml` file.

## Database Migration

Before launching the entire web application, it's crucial to run the database migrations. This step ensures that the database schema is set up according to the specifications in your Rails application. To perform the migration, use the following command:

```bash
rails db:migrate
```

## Database Seeding

The database can be populated with the data from the currency json by using

```bash
rails import:currency_json_data
```

## Starting the web app

Web app can be started with

```bash
rails server 
```
