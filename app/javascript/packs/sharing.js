function getTwitterLink(text){
    let tmp = ''
    ' '.split(text).forEach(e => {
        tmp += e + '%20'
    });
    return tmp
}

$(function(){
    const CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
    $('.share').each((idx, e)=>{
        $(e).on(
            'click',
            function(){
                sendData(e.id, window.location.pathname)
            }
        )
    })
})

function sendData(social, feature){
    console.log(social)
    let share = new FormData();

    share.append('social', social)
    share.append('feature', feature)
    console.log(social + "  " + feature) 
    navigator.sendBeacon('/shares', share);

} 