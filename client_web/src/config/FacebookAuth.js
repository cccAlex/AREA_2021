import axios from '../plugins/axios';
// /global FB/
/* eslint-disable */
export const initFbsdk = async () => {
    const { data: { data: { clientID } } } = await axios.get('/getFacebookClientID');

    window.fbAsyncInit = function () {
        FB.init({
            appId: clientID,
            cookie: true,
            xfbml: true,
            version: 'v2.8'
        });
        FB.AppEvents.logPageView();
    };
    (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
};