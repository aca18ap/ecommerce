import { Loader } from "@googlemaps/js-api-loader";

// Create the script tag, set the appropriate attributes

const loader = new Loader({
    apiKey: "AIzaSyCSUnN_KPnlZn8o2FXoWY4AdpLTMR-uN0Y",
    version: "weekly"
})

let map;

loader.load().then(()=>{
    map = new google.maps.Map(document.getElementById("map"), {
      center: { lat: -34.397, lng: 150.644 },
      zoom: 8,
    });
})
