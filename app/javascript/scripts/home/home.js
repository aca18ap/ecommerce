$(function () {
    $('[data-toggle="popover"]').popover()
  })

$('#scroll_down').on('click', ()=>{
    let next = document.getElementById('next')
    next.scrollIntoView(true)
})

