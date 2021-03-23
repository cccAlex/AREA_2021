<template>
  <div class="home-container">
    <div v-if="error">
      <b-alert  show variant="danger" fade>{{this.errorMsg}}</b-alert><br>
    </div>
    <div v-if="success">
      <b-alert  show variant="success" fade>{{this.successMsg}}</b-alert><br>
    </div>
    <b-form-input v-model="AreaName" placeholder="Name of the AREA" size="sm" type="url"></b-form-input><br>
    <b-row class="text-center">
      <b-col>
        <b-form-select
          v-model="firstService.serviceName"
          :options="servicesOptions"
          size="sm"
        ></b-form-select>
        <div v-for="elem in services" :key="elem.id">
          <div v-if="firstService.serviceName == elem.name">
            <img
              :src="elem.logo"
              width="100px"
              height="100px"
              class="logos"
            /><br />
            <div v-if="firstService.serviceName == 'Weather'"></div>
            <b-button v-else-if="!firstService.isLogged" class="login-service-button" @click="loginServices('first', elem.route)">Log In</b-button>
            <div v-else>
    <p>Logged in with <b>{{firstService.serviceParams.display_name}}</b></p>
    <b-button class="logout-service-button" @click="logoutService('first')">Logout</b-button>
</div>

    <b-form-select v-if="firstService.isLogged || firstService.serviceName == 'Weather'"
      v-model="firstService.name"
      :options="elem.action"
      size="sm"
      class="action-reaction-form"
    ></b-form-select>
    <div v-if="elem.action.find(k => k.value === firstService.name)">
      <br><b-form-input v-if="elem.action.find(k => k.value === firstService.name).params" :placeholder="elem.action.find(k => k.value === firstService.name).params[0].description" v-model="firstService.params[elem.action.find(x => x.value === firstService.name).params[0].name]" size="sm" type="url"></b-form-input>
    </div>
          </div>
        </div>
      </b-col>
      <b-col cols="1">
        <hr class="service-separator" />
      </b-col>
      <b-col>
        <b-form-select
          v-model="secondService.serviceName"
          :options="servicesOptionsTwo"
          size="sm"
        ></b-form-select>
        <div v-for="elem in services" :key="elem.id">
          <div v-if="secondService.serviceName == elem.name">
            <img
              :src="elem.logo"
              width="100px"
              height="100px"
              class="logos"
            /><br />
            <div v-if="secondService.serviceName == 'Discord'">
              <br>
              <b-form-input placeholder="Webhook URL" v-model="secondService.serviceParams['webhookURL']" size="sm" type="url"></b-form-input>
            </div>
            <div v-else-if="secondService.serviceName == 'Mail'"></div>
            <b-button v-else-if="!secondService.isLogged" class="login-service-button" @click="loginServices('second', elem.route)">Log In</b-button>
            <div v-else>
              <p>Logged in with <b>{{secondService.serviceParams.display_name}}</b></p>
              <b-button class="logout-service-button" @click="logoutService('second')">Logout</b-button>
            </div>
            <b-form-select v-if="secondService.isLogged || secondService.serviceName == 'Discord' || secondService.serviceName == 'Mail'"
                v-model="secondService.name"
                :options="elem.reaction"
                size="sm"
                class="action-reaction-form"
            ></b-form-select>
            <div v-if="elem.reaction.find(x => x.value === secondService.name)">
              <br><b-form-input v-if="elem.reaction.find(x => x.value === secondService.name).params" :placeholder="elem.reaction.find(x => x.value === secondService.name).params[0].description" v-model="secondService.params[elem.reaction.find(x => x.value === secondService.name).params[0].name]" size="sm" type="url"></b-form-input>
            </div>
          </div>
        </div>
      </b-col>
    </b-row>
    <div v-if="this.firstService.name && this.secondService.name">
      <br><hr class="service-separator" />
      <b-form-select
        v-model="refreshTime"
        :options="refreshTimes"
        size="sm"
        class="action-reaction-form"
      ></b-form-select>
      <br><br><b-button class="logout-service-button" @click="createAREA()">Create AREA</b-button>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import SpotifyLogo from '@/assets/spotify_logo.png';
import DiscordLogo from '@/assets/discord_logo.png';
import GoogleCalendarLogo from '@/assets/google_calendar_logo.png';
import GoogleDriveLogo from '@/assets/google_drive_logo.png';
import YoutubeLogo from '@/assets/youtube_logo.png';
import MailLogo from '@/assets/email_logo.png';
import WeatherLogo from '@/assets/weather_logo.png';

export default {
  name: "TheHome",
  data() {
    return {
      AreaName: null,
      refreshTime: null,
      refreshTimes: [],
      selectedService1: null,
      selectedService2: null,
      firstService : {
        name: null,
        serviceName: null,
        serviceParams: {},
        params: {},
        isLogged: false,
      },
      secondService : {
        name: null,
        serviceName: null,
        serviceParams: {},
        params: {},
        isLogged: false,
      },
      discordWebhookURL : null,
      servicesOptions: [
        { value: null, text: "Please select a service" },
        { value: "Spotify", text: "Spotify" },
        { value: "Google Calendar", text: "Google Calendar" },
        { value: "Google Drive", text: "Google Drive" },
        { value: "Youtube", text: "Youtube" },
        { value: "Weather", text: "Weather" },
      ],
      servicesOptionsTwo: [
        { value: null, text: "Please select a service" },
        { value: "Discord", text: "Discord" },
        { value: "Spotify", text: "Spotify" },
        { value: "Google Calendar", text: "Google Calendar" },
        { value: "Google Drive", text: "Google Drive" },
        { value: "Youtube", text: "Youtube" },
        { value: "Mail", text: "Mail"}
      ],
      services: {
        Discord: {
          name: "Discord",
          route: "",
          logo: DiscordLogo,
          reaction: [
            { value : null, text: "Please select a reaction" },
            { value : "discordSendMessage", text: "Send a message to discord" },
          ],
        },
        Spotify: {
          name: "Spotify",
          route: "/getSpotifyAuthURL",
          logo: SpotifyLogo,
          action: [
            { value : null, text: "Please select an action" },
            { value : "spotifyLikeSong", text: "Spotify like a song" },
          ],
          reaction: [
            { value : null, text: "Please select a reaction" },
            { value : "spotifyAddToPlaylist", text: "Spotify add to playlist", params:[{ name:'playlistID', description:'Id of the playlist'}] },
          ],
        },
        GoogleCalendar: {
          name: "Google Calendar",
          route: "/getGoogleCalendarAuthURL",
          logo: GoogleCalendarLogo,
          action: [
            { value : null, text: "Please select an action" },
            { value : "GoogleCalendarUpdateEvents", text: "Check if an event is updated" },
            { value : "GoogleCalendarRemoveEvents", text: "Check if an event is deleted" },
          ],
          reaction: [
            { value : null, text: "Please select a reaction" },
            { value : "GoogleCalendarAddEvent", text: "add an event" },
          ],
        },
        GoogleDrive: {
          name: "Google Drive",
          route: "/getGoogleDriveAuthURL",
          logo: GoogleDriveLogo,
          action: [
            { value : null, text: "Please select an action" },
            { value : "getNewFile", text: "Check if a file is created" },
          ],
          reaction: [
            { value : null, text: "Please select a reaction" },
            { value : "createFileDrive", text: "Create file if event is triggered" },
          ],
        },
        Weather: {
          name: "Weather",
          route: "",
          logo: WeatherLogo,
          action: [
            { value : null, text: "Please select an action" },
            { value : "checkCurrentWeather", text: "checkCurrentWeather", params:[{ name:'city', description:'City'}]  },
          ],
          reaction: [
            { value : null, text: "Please select a reaction"},
          ],
        },
        Youtube: {
          name: "Youtube",
          route: "/getYoutubeAuthURL",
          logo: YoutubeLogo,
          action: [
            { value : null, text: "Please select an action" },
            { value : 'youtubeGetSubscribersCount', text: "Each time you reach a milestone of subscribers count", params: [{name: 'subscriber_goal', description: 'Subscriber Goal'}] },
            { value : 'youtubeGetTotalViewsCount', text: "Each time you reach a milestone of total views count", params: [{name: 'views_goal', description: 'Views Goal'}]},
            { value : 'youtubeGetNewestVideo', text: "Get notified everytime a new video is added from a specific channel", params: [{name: 'channelURL', description: 'Channel ID'}]},
            { value : 'youtubeGetNewestVideoFromPlaylist', text: "Get notified everytime a new video is added in a specific playlist", params: [{name: 'playlistID', description: 'Playlist ID'}]},
          ],
          reaction: [
            { value : null, text: "Please select a reaction" },
            { value : 'youtubeLikeVideo', text: "Like youtube video if action sends video url"},
            { value : 'youtubeDislikeVideo', text: "Dislike youtube video if action sends video url"},
          ],
        },
        Mail: {
          name: "Mail",
          route: "",
          logo: MailLogo,
          action: [
            { value : null, text: "Please select an action" },
          ],
          reaction: [
            { value : null, text: "Please select a reaction" },
            { value : 'areaBotMailer', text: "Send an email" },
          ],
        },
      },
      error: false,
      errorMsg: '',
      success: false,
      successMsg: ''
    };
  },
  watch:{
    "firstService.serviceName"() {
      if (this.firstService.serviceName) {
        axios.get("/service",{ headers: { Authorization: this.$store.getters["user/getBearerToken"],}, params: { name: this.firstService.serviceName.charAt(0).toUpperCase() + this.firstService.serviceName.slice(1)}})
        .then(({data : {data}}) => {
          if (data != null) {
            (data)
            this.firstService.isLogged = true
            this.firstService.serviceParams = data.params
          } else {
            this.firstService.isLogged = false
          }
          this.firstService.name = null
          this.$store.dispatch("area/setFirstService", JSON.parse(JSON.stringify(this.firstService)));
        })
        .catch((err) => {
          console.warn(err);
        });
      }
    },
    "secondService.serviceName"() {
      if (this.secondService.serviceName) {
        axios.get("/service",{ headers: { Authorization: this.$store.getters["user/getBearerToken"],}, params: { name: this.secondService.serviceName.charAt(0).toUpperCase() + this.secondService.serviceName.slice(1)}})
        .then(({data : {data}}) => {
          if (data != null) {
            this.secondService.isLogged = true
            this.secondService.serviceParams = data.params
          } else {
            this.secondService.isLogged = false
          }
          this.secondService.name = null
          this.$store.dispatch("area/setSecondService", JSON.parse(JSON.stringify(this.secondService)));
        })
        .catch((err) => {
          console.warn(err);
        });
      }
    },
  },
  mounted() {
    this.firstService = JSON.parse(JSON.stringify(this.$store.getters['area/getFirstService']));
    this.secondService = JSON.parse(JSON.stringify(this.$store.getters['area/getSecondService']));
    axios.get("/getRefreshTime", { headers: { Authorization: this.$store.getters["user/getBearerToken"],},})
    .then(({data : {data}}) => {
      this.refreshTimes = data
      this.refreshTimes.unshift({value: null, text: "Please select the refreshing time"})
    })
    .catch((err) => {
      console.warn(err);
    });
  },
  methods: {
    logoutService(which) {
      var emptyFirstService = {
        name: null,
        serviceName: null,
        serviceParams: {},
        params: {},
        isLogged: false,
      }
      var emptySecondService = {
        name: null,
        serviceName: null,
        serviceParams: {},
        params: {},
        isLogged: false,
      }
      if (which == 'first') {
        axios.post("/removeService", { name : this.firstService.serviceName.charAt(0).toUpperCase()+ this.firstService.serviceName.slice(1)} ,{ headers: { Authorization: this.$store.getters["user/getBearerToken"],},})
        .then(({data : {data}}) => {
          (data)
          this.firstService = {...emptyFirstService}
          this.$store.dispatch("area/setFirstService", emptyFirstService);
        })
        .catch((err) => {
          console.warn(err);
        });
      } else {
        axios.post("/removeService", { name : this.secondService.serviceName.charAt(0).toUpperCase()+ this.secondService.serviceName.slice(1)} ,{ headers: { Authorization: this.$store.getters["user/getBearerToken"],},})
        .then(() => {
          this.secondService = {...emptySecondService}
        this.$store.dispatch("area/setSecondService", emptySecondService);
        })
        .catch((err) => {
          console.warn(err);
        });
      }
    },
    createAREA() {
      if (this.firstService.name == null || this.secondService.name == null || this.refreshTime == null) {
        this.error = true
        this.errorMsg = 'You must choose an action, a reaction and the refresh time to create an AREA ! 😔'
        setTimeout(() => { this.error = false }, 5000);
      } else if (this.AreaName == null) {
        this.error = true
        this.errorMsg = 'You must choose name for the AREA ! 😔'
        setTimeout(() => { this.error = false }, 5000);
      } else {
        const first = {...this.firstService}
        delete first['isLogged']
        const second = {...this.secondService}
        delete second['isLogged']
        var data = {action:first, reaction:second, refreshTime:this.refreshTime}
        if (this.secondService.serviceName == 'Mail') data.reaction.params['email'] = this.$store.getters["user/getEmail"]
        axios.post('/addArea', data, {headers: {Authorization: this.$store.getters["user/getBearerToken"],},})
        .then(({data}) => {
          data.status ? this.success = true : this.error = true;
          data.status ? this.successMsg = this.AreaName + ' created successfully!' : this.errorMsg = 'Error when creating AREA ' + this.AreaName;
          setTimeout(() => { data.status ? this.success = false : this.error = false }, 5000);
          this.refreshTime = null;
          this.AreaName = null;
          this.firstService.serviceName = null;
          this.secondService.serviceName = null;
          this.firstService.name = null;
          this.secondService.name = null;
        })
        .catch((err) => {
         console.warn(err)
        })
      }
    },
    loginServices(which, route) {
      axios.get(route, {headers: {Authorization: this.$store.getters["user/getBearerToken"],},})
      .then(({data: {data: { url },},}) => {
        window.open(url + "&state=" + which, "_self");
      })
      .catch((err) => {
        console.warn(err);
      });
    },
  }
};
</script>

<style>
.button-style {
  background: #16166f;
  height: 60px;
  font-weight: bold;
  border-radius: 25px;
  margin-top: 30px;
}
.button-style:hover {
  background: #6969a2;
}

.button-style-unactive {
  background-color: white;
  height: 60px;
  color: #16166f;
  font-weight: bold;
  border-radius: 25px;
  border-color: #16166f;
  margin-top: 30px;
}
.button-style-unactive:hover {
  background: #6969a2;
}

.home-container {
  margin: 3%;
  border-radius: 25px;
}

.service-separator {
  border-top: 1px solid lightgrey;
}

.logos {
  margin-top: 50px;
}

.login-service-button {
  background: #16166f;
  margin-top: 25px;
  font-size: 15px;
  font-weight: bold;
  padding: 10px 25px;
  border-radius: 25px;
}

.logout-service-button {
  background: #16166f;
  font-size: 15px;
  font-weight: bold;
  padding: 10px 25px;
  border-radius: 25px;
}

.login-service-button:hover {
  background: #6969a2;
}

.action-reaction-form{
  margin-top: 15px;
}

.discord-reaction{
  margin-top: 44px;
}
</style>