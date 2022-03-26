console.log('doc changed')
setupListeners()


function setupListeners(){
    $('.percentage').on('input', function(){
        checkPercentagesSum()
    })
}

$(function() {
    checkPercentagesSum()
})

function checkPercentagesSum(){
    let materials = document.getElementsByClassName('percentage')
    let tmp = 100
    console.log("Check percentage called")
    Array.from(materials).forEach(function(e){
        console.log(parseInt(e.value))
        tmp -= parseInt(e.value) || 0
    })
    $('#sum').text(tmp)
    console.log(tmp)
}

$('.form-inputs').on('click', function(e){
    setupListeners()
})