/**
 * Generate query text 
 */
function getQueryText(text){
    let tmp = ""
    ' '.split(text).forEach(e => {
        tmp += e + '%20'
    });
    return tmp
}


fetch("posts.json")
    .then(response.json())
    .then(json => {
        json.forEach(p => {
            let posts = $('#'+p).children
            
        })
    })


$(function(){
    const CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
    $('.share').each((idx, e)=>{
        $(e).on(
            'click',
            function(){
                let mainCard = (e.parentNode.parentNode.parentNode.parentNode);
                //let f = mainCard.getElementsByClassName("featureName")[0].textContent.replace(/(\r\n|\n|\r)/gm," ").trim()
                sendData(e.id, mainCard.getElementsByClassName("featureName")[0].id);
            }
        )
    })
})

function sendData(social, feature){
    const share = {
        social,
        feature,
    };
    const headers = {
    type: 'application/json',
    };

    const blob = new Blob([JSON.stringify(share)], headers);

    navigator.sendBeacon('/shares', blob );
} 