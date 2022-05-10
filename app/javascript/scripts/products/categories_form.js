let categories;
let path; 
let flattened_categories;

$(function(){
    if(gon){
        categories = gon.categories
        path = gon.cat_path
        flattened_categories = gon.all_cat_flat
    }
    initParents()
    $('.category_parent').hide()
    $('.category_child').hide()
    $('.category_grandchild').hide()

    if(path){
        initCategory()
    }

    $('#search_category').on('input', ()=>{
        updateResults()
    })
})

function updateResults(){
    let query = $('#search_category').val().toLowerCase()
    let result = flattened_categories.filter(o => o.name.toLowerCase().includes(query))
    $('#search_results').empty()
    if (query !== ''){
        result.forEach(r =>{
            $('#search_results').append(`<p id=${r.id} font-size=0.5>` + r.name + '</p>')
            $(`#${r.id}`).on('click',(e)=>{
                setPath(r.ancestry, r.id)
                initCategory()
            })
        })
    }
}

function setPath(ancestry, selected_option_id){
    path = []
    let categories_ids = []
    if (ancestry !== null){
        categories_ids = ancestry.split('/')
    }
    categories_ids.push(selected_option_id)
    categories_ids.forEach(id =>{
        path.push(flattened_categories.find(c => c.id === parseInt(id)))
    })

}


$('#product_form').on('submit', function(){
    fillCategory()
})



function initParents(){
    categories.forEach(c=>{
        $('.category_grandparent').append(new Option(c.name, c.id))
    })
    $('.category_grandparent').on('click', (e) => {
        updateParent($(e.target).val())
    })
}

function updateParent(grandparent_id){
    let grandparent_node

    $('.category_parent').html('')
    $('.category_child').hide()
    $('.category_grandchild').hide()

    grandparent_node = categories.find((category)=> {
        if(category.id == grandparent_id){
            return category
        }
    })
    if (grandparent_node.children !== []){
        grandparent_node.children.forEach(c=>{
            $('.category_parent').append(new Option(c.name, c.id))
        })
        $('.category_parent').on('click', e=>{
            updateChildren($(e.target).val())
        })
    }
    if($('.category_parent').has('option').length === 0){
        $('.category_parent').hide()
    }else{
        $('.category_parent').show()
    }

}


function updateChildren(parent_id){
    let parent_node

    $('.category_child').html('')
    $('.category_grandchild').hide()
    let grandparent_id = $('.category_grandparent').val()
    parent_node = categories.find(x => x.id === parseInt(grandparent_id)).children.find((category) => {
        if(category.id == parent_id){
            return category
        }
    })
    if (parent_node.children !== []){
        parent_node.children.forEach(c=>{
            $('.category_child').append(new Option(c.name, c.id))
        })
        $('.category_child').on('click', (e) => {
            updateGrandchildren($(e.target).val())
        })
    }
    if($('.category_child').has('option').length === 0){
        $('.category_child').hide()
    }else{
        $('.category_child').show()
    }
}

function updateGrandchildren(child_id){

    $('.category_grandchild').html('')
    $('.category_grandchild').show()

    let grandparent_id = parseInt($('.category_grandparent').val())
    let parent_id = parseInt($('.category_parent').val())

    let grandparent = categories.find(x => {
        if(x.id == grandparent_id){
            return x
        }
    })

    let parent = grandparent.children.find(y => {
        if(y.id === parent_id){
            return y
        }
    })

    let child = parent.children.find(z => {
        if(z.id === parseInt(child_id)){
            return z
        }
    })

        
    if (child.children){
        child.children.forEach(c=>{
            $('.category_grandchild').append(new Option(c.name, c.id))
        })
    }
    if($('.category_grandchild').has('option').length === 0){
        $('.category_grandchild').hide()
    }
}


function fillCategory(){
    let gc = $('.category_grandchild').val()
    let c = $('.category_child').val()
    let p = $('.category_parent').val()
    let gp = $('.category_grandparent').val()
    if(gc){
        $('#product_category_id').val(gc)
    }else if(c){
        $('#product_category_id').val(c)
    }else if(p){
        $('#product_category_id').val(p)
    }else{
        $('#product_category_id').val(gp)
    }
}


function initCategory(){
    for(let i=0; i < path.length; i++){
        if(i==0){
            $('.category_grandparent').val(path[i].id)
            updateParent(path[i].id)
        }else if(i==1){
            $('.category_parent').val(path[i].id).show()
            updateChildren(path[i].id)
        }else if(i==2){
            $('.category_child').val(path[i].id).show()
            updateGrandchildren(path[i].id)
        }else if(i==3){
            $('.category_grandchild').val(path[i].id).show()
        }
    }
}