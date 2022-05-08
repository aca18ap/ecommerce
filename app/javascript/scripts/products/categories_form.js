let categories;
let path; 


$(function(){
    if(gon){
        categories = gon.categories
        path = gon.cat_path
        console.log(path)
    }
    initParents()
    $('.category_parent').hide()
    $('.category_child').hide()
    $('.category_grandchild').hide()

    if(path.length !== 0){
        console.log('Initializing categories')
        initCategory()
    }
})

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
    parent_node = categories[0].children.find((category) => {
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
        console.log(path[i].id)
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