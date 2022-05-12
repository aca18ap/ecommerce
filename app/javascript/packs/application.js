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
import "@nathanvda/cocoon";
import "chartkick/highcharts";

Rails.start();

// Full demo here: https://timsilva.com/dm/

var darkmodeactive = localStorage.getItem("darkmode");
console.log("Dark mode is: " + darkmodeactive);
function labelDark() {
  $(".toggle-switch").attr("alt", "Go light");
  $(".toggle-switch").attr("title", "Go light");
}
function goDark() {
  console.log("Dark mode is active");
  labelDark();
  $("body").addClass("dark");
  document.documentElement.setAttribute("color-mode", "dark")
}
function stayDark() {
  goDark();
  localStorage.setItem("darkmode", true);
  darkmodeactive = localStorage.getItem("darkmode");
  console.log("Dark mode is: " + darkmodeactive + " and it will stay dark");
}
function labelLight() {
  $(".toggle-switch").attr("alt", "Go dark");
  $(".toggle-switch").attr("title", "Go dark");
}
function goLight() {
  console.log("Light mode is active");
  labelLight();
  $("body").removeClass("dark");
  document.documentElement.setAttribute("color-mode", "light")
}
function stayLight() {
  goLight();
  localStorage.setItem("darkmode", false);
  darkmodeactive = localStorage.getItem("darkmode");
  console.log("Dark mode is: " + darkmodeactive + " and it will stay light");
}
window.matchMedia("(prefers-color-scheme: dark)").addListener(e => e.matches && stayDark());
window.matchMedia("(prefers-color-scheme: light)").addListener(e => e.matches && stayLight());
$(".toggle-switch").click(function() {
  if ($("body").hasClass("dark")) {
    stayLight();
  } else {
    stayDark();
  }
});
$(".label-light").click(function() {
  if ($("body").hasClass("dark")) {
    stayLight();
  }
});
$(".label-dark").click(function() {
  if (!$("body").hasClass("dark")) {
    stayDark();
  }
});
window.onload=function() {
  if (localStorage.darkmode=="true") {
    console.log("User manually selected dark mode from a past session");
    goDark();
  } else if (localStorage.darkmode=="false") {
    console.log("User manually selected light mode from a past session");
    goLight();
  } else {
    console.log("User hasn't selected dark or light mode from a past session, dark mode has been served by default and OS-level changes will automatically reflect");
    if ($("body").hasClass("dark")) {
      labelDark();
    } else {
      labelLight();
    }
  }
};
function tempDisableAnim() {
  $("*").addClass("disableEasingTemporarily");
  setTimeout(function() {
    $("*").removeClass("disableEasingTemporarily");
  }, 20);
}
setTimeout(function() {
  $(".load-flash").css("display","none");
  $(".load-flash").css("visibility","hidden");
  tempDisableAnim();
}, 20);
$(window).resize(function() {
  tempDisableAnim();
  setTimeout(function() {
    tempDisableAnim();
  }, 0);
});

/* Set the width of the sidebar to 250px and the left margin of the page content to 250px */
function openNav() {
  document.getElementById("mySidebar").style.width = "250px";
  document.getElementById("main").style.marginLeft = "250px";
}

/* Set the width of the sidebar to 0 and the left margin of the page content to 0 */
function closeNav() {
  document.getElementById("mySidebar").style.width = "0";
  document.getElementById("main").style.marginLeft = "0";
} 
