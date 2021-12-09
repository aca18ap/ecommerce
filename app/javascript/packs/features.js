
document.addEventListener('DOMContentLoaded', () => {
    var features_list = document.getElementById('features-list').children;
    var features = [];
    for (let i=0; i< features_list.length; i++){
        setTimeout(()=>{
            features_list[i].visibility = "visible";
            console.log(features_list[i]);
        }, 1000)
    }
        
})