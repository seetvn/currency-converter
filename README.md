# README
# Design choices
## Storing the currency exchange
I chose to store the currency exchange as a Rails model ```Currency``` with (```source_currency```,```target_currency```,```exchange_rate``` and ```date```) as the attributes. This allowed for easier manipulation of the data when it comes to CRUD operations and allowed the exchange rates to be stored in a more formatted way, making it easier to switch between different foreign exchange rates that can be based on any currency.
## Adding new currency exchange data
New currency exchange data could be added through the ```new``` function and its corresponding ```views``` template but it only supports legitimate currencies.
## Currency conversion
The ```CurrenciesController``` handled the currency conversion. I chose to create three functions that handle the bulk of currency conversions within the ```CurrenciesController``` : ```result``` was the function that displayed the final result based on the ```source_currency```, ```target_currency``` and ```date``` , ```calculate_implicit_exchange_rate``` calculated the exchange rate between non-Euro currencies by using their values relative to the Euro (this can be changed to another currency) and ```find_transit_currency``` checked if there was a common ```Currency``` instance  between two currencies from where the exchange rate could be calculated.
## Error handling
Errors are raised when the currency exchange on a certain date doesn't exist or a currency doesn't exist.
## Testing
Testing was only done manually and no scripts were used since I didn't allocate enough time for it.
## Possible extension I couldn't do
A DFS method for currency conversion could have been employed where the exchange rate is calculated based on the 'path' between 2 currencies but I didn't think of it originally until I was writing this up.

# Database Configuration
The web application uses SQLite as its default database. However, it's worth noting that the database can be changed, as Rails supports various database systems. If you want to switch to a different database, you can update the configuration in the `config/database.yml` file.

# Database Migration

Before launching the entire web application, please run the database migrations with the following command:

```bash
rails db:migrate
```

# Database Seeding

The database should be populated with the data from the currency json by using. 

```bash
rails import:currency_json_data
```

# Starting the web app

Web app can be started with

```bash
rails server 
```
