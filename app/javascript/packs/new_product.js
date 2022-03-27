console.log('doc changed')


setupListeners()


$(document).ready(function(){
    $('.materials-section').on('click', function(e){
        setupListeners()
        checkPercentagesSum()
        console.log('Setup listeners again')
    })
    $('.materials-section').on('cocoon:after-insert', (e) => {
        setupListeners()
        checkPercentagesSum()
    })
    $('.materials-section').on('cocoon:after-remove', (e) => {
        setupListeners()
        checkPercentagesSum()
    })   
    $('.materials-section').on('cocoon:before-insert', (e) => {
        setupListeners()
        checkPercentagesSum()
    })
    $('.materials-section').on('cocoon:before-remove', (e) => {
        setupListeners()
        checkPercentagesSum()
    })
})


function setupListeners(){
    $('.product_material_fields:hidden').off('input', checkPercentagesSum())
    $('.product_material_fields:visible').on('input', checkPercentagesSum())
   
}

$(function() {
    checkPercentagesSum()
})

function checkPercentagesSum(){
    let percentages = document.getElementsByClassName('percentage')
    let tmp = 100
    console.log("Check percentage called")
    Array.from(percentages).forEach(function(e){
        console.log(e.offsetParent)
        if (e.offsetParent !== null){
            console.log(parseInt(e.value))
            tmp -= parseInt(e.value) || 0

        }
    })
    $('#sum').text(tmp)
    console.log(tmp)
}

/* $('.materials-section').on('click', function(e){
    setupListeners()
    checkPercentagesSum()
    console.log('Setup listeners again')
}) */