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





$(function(){
    const CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
    $('.share').each((idx, e)=>{
        $(e).on(
            'click',
            function(){
                let mainCard = (e.parentNode.parentNode.parentNode.parentNode);
                let f = mainCard.getElementsByClassName("featureName")[0].textContent.replace(/(\r\n|\n|\r)/gm," ").trim()
                sendData(e.id, f);
            }
        )
    })
})

function sendData(social, feature){
    let share = new FormData();

<<<<<<< Updated upstream
    share.append('social', social)
    share.append('feature', feature)
    navigator.sendBeacon('/shares', share);
} 
=======
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
>>>>>>> Stashed changes
