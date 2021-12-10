function getTwitterLink(text){
    let tmp = ''
    ' '.split(text).forEach(e => {
        tmp += e + '%20'
    });
    return tmp
}

$/* (function(){
    $('.share').each((i)=>{
        $(this).on(
            'click',
            function(){
                sendData(this.id)
            }
        )
    })
})

function sendData(social){
    console.log(social)
    let metrics = new FormData();

    metrics.append('social', social)
    navigator.sendBeacon('/metrics', metrics);

} */