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
The current state of fast fashion is leaving a devastating trail of destruction on the environment. In an attempt to combat the throwaway culture of clothing and the mass scale environmental impacts of textiles imports, we propose to advertise environmentally sustainable alternatives to unsustainable products while browsing. We collect a database of products from our users, giving the product, the manufacturer, the materials and the country of production and use that to calculate a number of metrics to inform other user's future purchases. We provide a brand score over their catalog, a £/KgCO<sub>2</sub> rating for individual products and other useful metrics. These metrics combine to give a summary of a user's purchase history to help inform users of where they can improve and see the positive impact they make over time by choosing more environmentally sustainable options.

Additionally, we partner with environmentally sustainable brands to suggest alternatives to fast fashion vendors online. You can trust these brands as they meet out [NUMBER] criteria and have been manually verified:
1) CRITERIA 1
2) CRITERIA 2

## Development

### Significant Features / Technology

* [GeoCoder](https://github.com/alexreisner/geocoder) is used to retrieve locations from IP addresses and store them in our system for use in representing site usage metrics
* [GeoJSON](https://geojson.org/) is used to render the locations of visitors and registrations in the UK
* [Gon](https://github.com/gazay/gon) is used to pass Ruby controller variables to JS directly 
* ADD MORE IN THE FUTURE AS THEY ARE PRESENT

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
TODO: Fail if RSpec / Jest tests fail or if Brakeman finds a "medium" issue.

### Style Guide
The standard [Ruby Style Guide](https://rubystyle.guide/) is employed and enforced using RuboCop. Most common standards are:
1) Symbols, Methods and Variables using `snake_case` format
2) Two-space indentations
3) Maximum line length of 80 
4) One expression per line
5) No trailing whitespaces
6) Indentation alignment for multiline statements (e.g. as hashmap declarations) that overrun 80 characters

### Deployment with the Epi-Deploy Gem
More detailed instructions can be found [here](https://info.shefcompsci.org.uk/genesys/demos/team04.html)

1) Set appropriate contents for `config/deploy.rb` and `config/deploy/demo.rb`
2) Commit any changes to the main branch
3) Execute the deployment with: `bundle exec epi_deploy release -d demo`
4) Seed the database with: `bundle exec cap demo deploy:seed`

*QA -> Demo -> Production* using the `epi-deploy` gem.
