<template>
    <div class="service-container">
        <p class="service-container-title">My services</p>
        <div class="each-service border border-dark">
          <b-container>
            <b-row v-for="(service, index) in services" :key="service.name + index" class="row">
              <b-col class="icon"><img :src="servicesLogo[service.name]" width="50px" height="50px" class="logos"/></b-col>
              <b-col>
                <p v-if="service.params.display_name" class="text" >Logged in as <b>{{ service.params.display_name }}</b></p>
                <p v-else class="text">Logged in</p>
              </b-col>
            </b-row>
          </b-container>
        </div><br><br>

    </div>
</template>
<script>
import axios from "@/plugins/axios";
import SpotifyLogo from '@/assets/spotify_logo.png';
import DiscordLogo from '@/assets/discord_logo.png';
import GoogleCalendarLogo from '@/assets/google_calendar_logo.png';
import GoogleDriveLogo from '@/assets/google_drive_logo.png';
import GoogleGmailLogo from '@/assets/gmail_logo.png';
import YoutubeLogo from '@/assets/youtube_logo.png';
import WeatherLogo from '@/assets/weather_logo.png';

export default {
    name: "MyServices",
    data() {
      return ({
        services: [],
        servicesLogo: {
            Spotify: SpotifyLogo,
            Discord: DiscordLogo,
            'Google Calendar' : GoogleCalendarLogo,
            "Google Drive" : GoogleDriveLogo,
            'Google Gmail': GoogleGmailLogo,
            Youtube : YoutubeLogo,
            Weather : WeatherLogo,
            },
        error: '',
      })
    },
    mounted() {
      axios.get('/services', {headers: {'Authorization': this.$store.getters['user/getBearerToken']}})
        .then(({data : {status, data}}) => {
          if (!status) throw new Error(data);
          this.services = data;
        })
        .catch((err) => this.error = err.message);
    }
}
</script>

<style scoped>
.service-container {
  margin: 2%;
  border-width: 1px;
  color: #16166f;
}

.service-container-title {
  font-size: 30px;
  font-weight: bold;
  border-bottom: 1px solid black;
  padding-left: 2%;
  padding-bottom: 10px
}

.each-service-title {
  padding: 0 2% 0 2%;
  font-weight: bold;
  font-size: 18px;
  letter-spacing: 3px;
}

.each-service {
    border-radius: 25px;
    padding: 0 2% 0 2%;
}

.row {
    margin-top: 10px;
}
.icon {
    text-align: right;
    border-right: 2px solid black;
    margin-top: 3px;
}

.text {
    margin-top: 12px;
    margin-left: 10px;
    font-weight: bold;
    font-size: 20px;
}

.button {
  margin-top: 7px;
  background: #f54242;
  font-size: 15px;
  font-weight: bold;
  padding: 10px 25px;
  border-color: red;
  border-radius: 25px;
}

.add-account {
    text-align: center;
    color: lightgray
}
</style>