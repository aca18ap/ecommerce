/* console.log('hi')
$(document).on("page:load turbolinks:load", function(){
    $("#materials a.add_fields").
        data("association-insertion-position", "before").
        data("association-insertion-node", "this")
    
    $('#materials').bind('cocoon:after-insert',
        function(e, material){
            console.log('inserting new material ...')
            $(".products-material-fields a.add-material").
                data("association-insertion-position", 'after').
                data("association-insertion-node", 'this')
            $(this).find('.products-material-field').bind('cocoon:after-insert',
                function(){
                    console.log('insert new material ...');
                    console.log($(this));
                    $(this).find("material_from_list").remove()
                    $(this).find("a.add_fields").hide()

            })
        })
    $('.product-material-fields').bind('cocoon:after-insert',
            function(e) {
                console.log('replace material tag ...');
                e.stopPropagation()
                console.log($(this));
                $(this).find(".material_from_list").remove()
                $(this).find("a.add_fields").hide()
    
            })

}) */