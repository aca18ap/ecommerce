// external js: flickity.pkgd.js

$(function () {
    $('[data-toggle="popover"]').popover()
  })

$('#scroll_down').on('click', ()=>{
    let next = document.getElementById('next')
    next.scrollIntoView(true)
})


$(".testimonial-carousel").slick({
  infinite: true,
  slidesToShow: 1,
  slidesToScroll: 1,
  autoplay: false,
  arrows: true,
  prevArrow: $(".testimonial-carousel-controls .prev"),
  nextArrow: $(".testimonial-carousel-controls .next")
});


