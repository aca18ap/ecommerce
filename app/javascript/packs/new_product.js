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
    let percentages = document.getElementsByClassName('percentage')
    let tmp = 100
    console.log("Check percentage called")
    Array.from(percentages).forEach(function(e){
        console.log(parseInt(e.value))
        tmp -= parseInt(e.value) || 0
    })
    $('#sum').text(tmp)
    console.log(tmp)
}

$('.materials-section').on('click', function(e){
    setupListeners()
    console.log('Setup listeners again')
})