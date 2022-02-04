document.addEventListener('DOMContentLoaded', () => {
  const pageVisitedFrom = Date.now();
  const CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
  var latitude; // Declare, but undefined so needs handling
  var longitude; // Declare, but undefined so needs handling

  // Request location permissions
  getLocation()

  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(showPosition);
    } else { 
      // Diagnostic message 
      console.log("Geolocation is not supported or permitted by this browser.");
    }
  }

  // Set latitude and longitude
  function showPosition(position) {
    latitude = position.coords.latitude;
    longitude = position.coords.longitude;
  }

  // Bind listener to the visibilitychange event instead of unload, find out more at:
  // https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon#sending_analytics_at_the_end_of_a_session
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'hidden') {
      let metrics = new FormData();

      // Attach data to metrics object
      metrics.append('pageVisitedFrom', pageVisitedFrom);
      metrics.append('pageVisitedTo', Date.now());
      metrics.append('path', window.location.pathname);
      metrics.append('authenticity_token', CSRFToken);

      // Only add metrics if they have been set by geolocator lazily
      if (typeof latitude !== 'undefined') {
        metrics.append('latitude', latitude)
        metrics.append('longitude', longitude)
      }

      // navigator.sendBeacon is the easist way to send a request to the server when a page is unloading.
      // The browser will keep this request alive even if the page that started the request is unloaded already.
      // sendBeacon() will use POST method, and you cannot change this.
      navigator.sendBeacon('/metrics', metrics);
    }
  })
});