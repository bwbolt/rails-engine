<h1 align="center">Welcome to rails-engine 👋</h1>
<p>
  <img alt="Version" src="https://img.shields.io/badge/version-1-blue.svg?cacheSeconds=2592000" />
  <a href="#" target="_blank">
    <img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-yellow.svg" />
  </a>
  <a href="https://twitter.com/BryceWein1" target="_blank">
    <img alt="Twitter: BryceWein1" src="https://img.shields.io/twitter/follow/BryceWein1.svg?style=social" />
  </a>
</p>

> Restful API for [Little Esty Shop](https://bulk-discounts-2203.herokuapp.com/), the E-Commerce Application.

---

# Heroku Deployment

https://bulk-discounts-api.herokuapp.com/api/v1/


Check out available endpoints below :point_down:

---
## Available Endpoints
-   Merchants:
    -   Get all merchants ('/api/v1/merchants') `GET`
    -   Get one merchant ('/api/v1/merchants/{merchant_id}') `GET`
    -   Get all items for a given merchant ID ('/api/v1/merchants/{merchant_id}/items') `GET`
    -   Search for Merchant (''/api/v1/merchants/find') `GET`
		 - Required Params: {name: "name")
	---
-   Items:
    -   Get all items ('/api/v1/items') `GET`
    -   Get one item ('/api/v1/items/{item_id}') `GET`
    -   Create an item ('/api/v1/items') `POST`
	    - Required Params: {name: "name", description: "description", unit_price: unit_price}
    -   Edit an item ('/api/v1/items/{item_id}') `PATCH`
	    - Optional Params: {name: "name", description: "description", unit_price: unit_price}
    -   Delete an item ('/api/v1/items/{item_id}') `DELETE`
	    -   Get the merchant data for a given item ID ('/api/v1/items/{item_id}/merchant
	-   Search for Item ('/api/v1/items/find_all') `GET`
		- Optional Params: {name: "name", min_price: price , max_price: price}
		- Can only utilize name/ min_price/min_price + max_price/max_price
---
## Local Use
	- WARNING WITHOUT PROPER DB SETUP/ SEED SETUP, THIS PORTION WILL NOT WORK.


For full install instructions visit [HERE](https://backend.turing.edu/module3/projects/rails_engine_lite/)



### Install

```sh
git clone git@github.com:bwbolt/rails-engine.git

cd rails-engine

bundle install

rails db:create
```

### Local Usage

```sh
rails s (starts the server)
```

### Run tests

```sh
bundle exec rspec
```

## Author

👤 **Bryce Wein**

* Website: https://bwbolt.github.io/brycewein.com/
* Twitter: [@BryceWein1](https://twitter.com/BryceWein1)
* Github: [@bwbolt](https://github.com/bwbolt)
* LinkedIn: [@bryce-wein](https://linkedin.com/in/bryce-wein)

## Show your support

Give a ⭐️ if this project helped you!
