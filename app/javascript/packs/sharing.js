function getTwitterLink(text){
    let tmp = ''
    ' '.split(text).forEach(e => {
        tmp += e + '%20'
    });
    return tmp
}

function recordShare(social){
    let metrics = new FormData();
    metrics.append('social', social)
    navigator.sendBeacon('/metrics', metrics);

}