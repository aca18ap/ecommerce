$('.delete_product').bind('ajax:success', function() {
    let productId = $(this).attr('data-deleted-product-id');
    $(`#product-${productId}-partial`).fadeOut();
});