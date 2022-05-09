setupListeners()
const weights = {
    "Light": 0.5,
    "Medium": 1,
    "Heavy": 1.5
}

$(document).ready(function(){
    setupFormSteps()

    $('.materials-section').on('click', function(e){
        setupListeners()
        checkPercentagesSum()
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
    Array.from(percentages).forEach(function(e){
        if (e.offsetParent !== null){
            tmp -= parseInt(e.value) || 0

        }
    })
    $('#sum').text(tmp)
}
function setupFormSteps(){

    var navListItems = $('.setup-panel a'),
        allWells = $('.setup-content'),
        allNextBtn = $('.nextBtn'),
        allPrevBtn = $('.prevBtn');

    allWells.hide();

    navListItems.click(function (e) {
        e.preventDefault();
        var $target = $($(this).attr('href')),
            $item = $(this);

        if (!$item.hasClass('disabled')) {
            navListItems.removeClass('btn-success').addClass('btn-default');
            $item.addClass('btn-success');
            allWells.hide();
            $target.show();
            $target.find('input:eq(0)').focus();
        }
    });

    allNextBtn.click(function () {
        var curStep = $(this).closest(".setup-content"),
            curStepBtn = curStep.attr("id"),
            nextStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().next().children("a"),
            curInputs = curStep.find("input[type='text'],input[type='url']"),
            isValid = true;

        $(".form-group").removeClass("has-error");
        for (var i = 0; i < curInputs.length; i++) {
            if (!curInputs[i].validity.valid) {
                isValid = false;
                $(curInputs[i]).closest(".form-group").addClass("has-error");
            }
        }

        if (isValid) nextStepWizard.removeAttr('disabled').trigger('click');
    });

    allPrevBtn.click(function(){
        var curStep = $(this).closest(".setup-content"),
            curStepBtn = curStep.attr("id"),
            prevStepWizard = $('div.setup-panel div a[href="#' + curStepBtn + '"]').parent().prev().children("a"),
            curInputs = curStep.find("input[type='text'],input[type='url']"),
            isValid = true;

        $('.form-group').removeClass("has-error");
        for (var i = 0; i < curInputs.length; i++){
            if (!curInputs[i].validity.valid){
                isValid = false;
                $(curInputs[i]).closest(".form-group").addClass("has-error")
            }
        }

        if (isValid) prevStepWizard.removeAttr('disabled').trigger('click');
    });
    $('div.setup-panel div a.btn-success').trigger('click');
}

$('.weight').on('click', (e)=>{
    $('#mass').val(weights[e.target.innerHTML])
    $('.weight').removeClass("active")
    $(e.currentTarget).addClass("active")
})

$(function(){
    $('#image_input').on('change', function(e){
        console.log('triggered')
        let file = e.target.files[0]
        let reader = new FileReader()
        reader.onload = function(file){
            let img = new Image()
            console.log(file)
            img.src = file.target.result
            $('#image_preview').html(img)
        }
        reader.readAsDataURL(file)
    })
})

