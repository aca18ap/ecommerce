// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import { Loader } from "@googlemaps/js-api-loader";
import "bootstrap";
import '../scripts/metrics';
import './features';
import './sharing';
import './admin';
import './new_product';
import './show_product';
import "@nathanvda/cocoon";

Rails.start();