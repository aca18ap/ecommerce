let categories;

$(function(){
    if(gon){
        categories = gon.categories
    }
    initParents()
    $('.category_child').hide()
    $('.category_grandchild').hide()
})

$('#product_form').on('submit', function(){
    fillCategory()
})

function initParents(){
    console.log(categories)
    categories[0].children.forEach(c=>{
        $('.category_parent').append(new Option(c.name, c.id))
    })
    $('.category_parent').on('click', (e) => {
        updateChildren($(e.target).val())
    })
}

function updateChildren(parent_id){
    let parent_node

    $('.category_child').html('')
    $('.category_grandchild').hide()
    parent_node = categories[0].children.find((category) => {
        if(category.id == parent_id){
            return category
        }
    })
    if (parent_node.children !== []){
        parent_node.children.forEach(c=>{
            $('.category_child').append(new Option(c.name, c.id))
        })
        $('.category_child').on('change', (e) => {
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
    let parent_node
    $('.category_grandchild').html('')
    $('.category_grandchild').show()
    child = categories[0].children.find(c=>{
        if (c.id == $('.category_parent').val()){
            return c
        }
    })
    parent_node = child.children.find(gc => {
        if (gc.id == child_id){
            return gc
        }
    })
    
    if (parent_node.children !== []){
        parent_node.children.forEach(c=>{
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
    if(gc){
        $('#product_category_id').val(gc)
    }else if(c){
        $('#product_category_id').val(c)
    }else{
        $('#product_category_id').val(p)
    }
}