# Aust

This project is an e-commerce in a SaaS model.

### Dependencies

You need this:

* **ImageMagick**: on Mac, `brew install imagemagick`
* **phantomjs**: on Mac, `brew install phantomjs`
* **PostgreSQL**: on Mac,
`brew install postgresql && initdb /usr/local/var/postgres -E utf8 && initdb store && pg_ctl -D store -l ~/.logfile start`

### Using subdomains locally

The app requires subdomains. To be able to develop in the local machine, follow
these steps:

  1. Edit the /etc/hosts file (you have to use sudo) `$ sudo vim /etc/hosts`

  2. Add the following lines:
  ````
  127.0.0.1 store.i
  127.0.0.1 www.store.i
  127.0.0.1 mystore.store.i
  127.0.0.1 choose_a_store_name.store.i
  127.0.0.1 petshop.com
  127.0.0.1 www.petshop.com
  127.0.0.1 test.petshop.com
  127.0.0.1 lvh.com
  127.0.0.1 mystore.lvh.com
  127.0.0.1 example.com
  ````

  The first line above is going to tunnel `http://store.i:3000` to `http://localhost:3000`.

  The last two lines are a way to mimic more closely how a URL would be typed in the browser. For that case, you have to login into your store and enter `petshop.com.br` as an accepted login.

  **Note:** don't forget about `example.com` and `lvh.com`. They're used by Capybara Javascript driver. If a company is created with handle mystore, mystore.lvh.me will be used.

  3. If you're on a Mac, it might be necessary to run in some cases to flush the cache `$ dscacheutil -flushcache`

From now on, instead of using `http://localhost:3000`, use
`http://mystore.store.i:3000` (given you have a company with handle='mystore').

You can add as many lines to the /etc/hosts file as you want. Remember to match
the subdomain with the store you have locally.

On Rails, you can read the current subdomain in a controller via
`request.subdomain`.


### Testing

To test the POS with QUnit, just start the server and access `localhost:3000/qunit`

### Accessing the mobile site on Chrome

On Google Chrome web browser, go to the menu View -> Developer -> Developer
Tools (Alt+Cmd+I on Mac). On the bottom right of the developer tools panel,
click on the gear icon (settings).

  1. Open the tab called `Override`

  2. Check `User Agent` and select `Other...`. Paste the following in the text
input:
  `Mozilla/5.0 (iPhone; CPU iPhone OS 6_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3` (note iPhone 6_0 in the string; that's the important part)

  3. Now, check `Device metrics` and enter the following values:
  ````
  Screen resolution: 320x470
  Font scale factor: 1
  ````


### Environments

These are the available environments right now:

**Staging:** alestore.com.br (user: gremio, passw: inter)



### Assistence with data

When you setup your store, go to the configurations page and define a Zipcode. When you're checking out, the shipping zipcode (defined in the cart) should be different so that the shipping cost is properly calculated.

Valid zipcode (CEP): 91260000, 96360000.

*Banners*

* lateral (200px wide): use this image for ad banner, ![](http://f.cl.ly/items/232c123s361Y2r2m0r3O/banner_side_1_200x.jpg) (for all pages, right position)
* central (700px wide): http://f.cl.ly/items/3W0P3C0Z2A3W2z2u3B13/natalie_banner.jpg
