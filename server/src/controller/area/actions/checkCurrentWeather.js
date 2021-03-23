const axios = require('axios');

const client_id = process.env.WEATHER_API_KEY;

const checkCurrentWeather = async (areaID, {params, serviceParams }) => {
    try {
        const { data } = await axios.get('https://api.openweathermap.org/data/2.5/weather?q='+params.city+'&appid='+client_id, {
            headers: { 'Content-Type': 'application/json'}
        });

        const str = data.weather[0].description;
	    const list = ["rain", "thunderstorm", "snow"];
	    let check = false;

        for (var i = 0, ln = list.length; i < ln; i++) {
            if (str.indexOf(list[i]) !== -1) {
                check = true;
                break;
            }
        }
        return check ? { status: true, data: data.weather[0].description } : { status: false, data: null };
         
    } catch(err) {
        console.log(err.message);
        return { status: false, data: null };
    }
};

module.exports = checkCurrentWeather;