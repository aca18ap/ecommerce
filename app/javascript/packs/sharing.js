/**
 * Each feature's post description
 */
const posts = {
    "Unlimited suggestions": "Get unlimited greener shopping suggestions, only on @ecommerce",
    "One-click Visit retailer": "Easy access to green providers when shopping online on @ecommerce",
    "24/7 Support": "Support available 24/7, only on @ecommerce",
    "One-click access": "View the impact your shopping has on environment, always on @ecommerce",
    "View purchase history": "Quick access to your carbon footprint, save the planet click by click on @ecommerce",
    "Family purchase history": "Watch you and your family destroy the world at x4 the speed! On @ecommerce",
    "View carbon footprint": "Quick access to your carbon footprint, save the planet click by click on @ecommerce",
    "Carbon Footprint Viewer": "View an estimate of your cabon footprint and understand your impact on the environment, thanks to @ecommerce",
    "Crowdsourced Data": "@ecommerce is powered by YOU! Help us populating our crowdsourced database and save the planet click by click",
    "Browser Extension": "Easy access to green retailers when shopping thanks to @ecommerce 's browser extension"
}

const website_url = "team04.demo1.genesys.shefcompsciorg.uk"


/**
 * Given a social and a feature, this function visits that social with prefilled text
 * for that feature
 * @param social
 * @param feature
 */
function socialFormatter(social, feature) {
    //Getting post text based on the feature
    let post_text = posts[feature]

    if (post_text === undefined){
        post_text = '@ecommerce recommends ' + feature
    }
    //Encoding post text in uri query form
    let query_post = encodeURIComponent(post_text)
    let url
    //Each social requires a different uri format
    if (social === "twitter") {
        url = "https://twitter.com/intent/tweet?text=" + query_post
    } else if (social === "email") {
        url = "mailto:?subject=" + feature + "&body=" + query_post
    } else if (social === "facebook") {
        //Facebook doesn't allow text to be prefilled for a post, only links can be shared
        //hence why the url is passed
        url = "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2F" + website_url + "%2F%23&src=sdkpreparse"
    }
    //The generated post link replaces the current website page (mainly to aid testing)
    return window.open(url, '_blank')

}


/**
 * Listener for clicks on share icons. On click the feature and social are extracted
 * through the DOM.
 */
$(function () {
    const CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
    $('.share').each((idx, e) => {
        $(e).on(
            'click',
            function () {
                let mainCard = (e.parentNode.parentNode.parentNode.parentNode);
                let feature = mainCard.getElementsByClassName("featureName")[0].textContent.replace(/(\r\n|\n|\r)/gm, " ").trim()
                let social = e.id

                //sending data to record shares statistics
                sendData(social, feature)

                //Opening social page with prefilled feature text
                socialFormatter(social, feature)

            }
        )
    })
})


/**
 * Given a social and a feature, this function sends this data to the rails server
 * so that statistics on shares can be recorded.
 * @param social
 * @param feature
 */
function sendData(social, feature) {


    const share = {
        social,
        feature,
    };
    const headers = {
        type: 'application/json',
    };

    const blob = new Blob([JSON.stringify(share)], headers);

    navigator.sendBeacon('/shares', blob);
} 


