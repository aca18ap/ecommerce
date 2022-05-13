#ECOmmerce

## Project Info

### URLs
Demo site is currently live at:
https://team04.demo1.genesys.shefcompsci.org.uk/

### Customer Contact
For any issues, please contact one of us at our email address listed below:

* Chris Berisford (developer) - cjbersford1@sheffield.ac.uk
* Marcy Brook (developer) - mbrook1@sheffield.ac.uk
* Vineet Gupta (developer) - vkgupta1@sheffield.ac.uk
* Alberto Pia (developer) - apia1@sheffield.ac.uk
* Liam Thorne (developer) - wthorne1@sheffield.ac.uk

### Description
The current state of fast fashion is leaving a devastating trail of destruction on the environment. In an attempt to combat the throwaway culture of clothing and the mass scale environmental impacts of textiles imports, we propose to advertise environmentally sustainable alternatives to unsustainable products. We collect a database of products from our users, giving the product, the manufacturer, the materials and the country of production and use that to calculate a number of metrics to inform other user's future purchases. We calculate the CO<sub>2</sub> produced for each product based on the component material CO<sub>2</sub> produced during production, in addition to the CO<sub>2</sub> produced in transport. These metrics combine to give a summary of a user's purchase history to help inform users of where they can improve and see the positive impact they make over time by choosing more environmentally sustainable options.

## Development

### Significant Features / Technology

* [GeoCoder](https://github.com/alexreisner/geocoder) is used to retrieve locations from IP addresses and store them in our system for use in representing site usage metrics
* [GeoJSON](https://geojson.org/) is used to render the locations of visitors and registrations in the UK
* [Gon](https://github.com/gazay/gon) is used to pass Ruby controller variables to JS directly 
* [Chartkick/Highcharts](https://chartkick.com/#highcharts) is used to graph our system metrics and customer data
* [groupdate](https://github.com/ankane/groupdate) is used to make efficient db queries got time based metrics
* [ancestry](https://github.com/stefankroes/ancestry) is used to create nested product categories
* [cocoon](https://github.com/nathanvda/cocoon) is used by the product form to deal with nested attributes for materials.
* [ransack](https://activerecord-hackery.github.io/ransack/) is used to search products in the database
* [countries](https://github.com/countries/countries) is used along a csv file that stores sea distances between countries stored in alpha3


### Getting Started
Clone the project, then:
1) `rvm install <ruby-version>` (see `.ruby-version`)
2) `bin/setup`
3) `bin/start`
4) `rails s`
5) `bin/webpack-dev-server` for live reloading.
6) Visit `127.0.0.1:3000` to view the site

### Testing
* Run specs with `rspec`
* Run Jest tests with `yarn test`
* Run static analysis with `brakeman`
* **Run all of the above with `rake`**

### CI
The CI Pipeline will fail if any of the following conditions are not met:
1) Any RSpec tests fail
2) Any Jest tests fail
3) Any RuboCop offenses
4) Brakeman finds a "medium" issue
5) Bundler-audit fails
6) Yarn-audit fails

### Style Guide
An adaptation of the standard [Ruby Style Guide](https://rubystyle.guide/) and extended [Rails Style Guide](https://github.com/rubocop/rails-style-guide) are employed and enforced using RuboCop. Some modifications have been made to better suit the project and our agreed programming style. A summary of these modifications can be found here:
1) Line width increased to 120 characters
2) Maximum block length increased to 40
3) Maximum method length increased to 20
4) ABC Size metric increased to 20
5) Enforcing class and module children format disabled

Most style expectations are skipped for spec files as it was seen to cause excessive delay in development and decrease overall productivity. 

### Deployment with the Epi-Deploy Gem
More detailed instructions can be found [here](https://info.shefcompsci.org.uk/genesys/demos/team04.html)

1) Set appropriate contents for `config/deploy.rb` and `config/deploy/demo.rb`
2) Commit any changes to the main branch
3) Execute the deployment with: `bundle exec epi_deploy release -d demo`
4) Seed the database with: `bundle exec cap demo deploy:seed`

*QA -> Demo -> Production* using the `epi-deploy` gem.
