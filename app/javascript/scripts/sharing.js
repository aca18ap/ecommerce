function getTwitterLink(text){
    let tmp = ''
    ' '.split(text).forEach(e => {
        tmp += e + '%20'
    });
    return tmp
}

