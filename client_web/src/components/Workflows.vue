<template>
    <div>
        <b-list-group v-for="(item, key) in currentWorkflows" :key="item.id">
            <b-list-group-item class="container-workflow">
                <div class="central-elem">
                    <img
                        :src="servicesLogo[item.action]"
                        width="90px"
                        height="90px"
                        class="logos"
                    />
                    <img
                        :src="WorkflowIcon"
                        width="30px"
                        height="30px"
                        class="logos"
                    />
                    <img
                        :src="servicesLogo[item.reaction]"
                        width="90px"
                        height="90px"
                        class="logos"
                    />
                    <div class="area-text">
                        {{ item.text }}
                    </div>
                </div>
                <div class="right-side">
                    <b-button pill variant="outline-danger" class="delete-area" v-on:click="deleteAREA(key, item._id)">Delete</b-button>
                    <b-button v-if="item.active == 'false'" variant="secondary" class="start-area" v-on:click="startAREA(key, item._id)">Start</b-button>
                    <b-button v-if="item.active == 'true'" variant="danger" v-on:click="stopAREA(key, item._id)">Stop</b-button>
                </div>
            </b-list-group-item>
        </b-list-group>
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
import WorkflowIcon from '@/assets/workflow_icon.png';
import NodemailerLogo from '@/assets/email_logo.png';

export default {
    name: "MyWorkflows",
    data() {
        return {
            error:false,
            currentWorkflows: [],
            servicesLogo: {
            Spotify: SpotifyLogo,
            Discord: DiscordLogo,
            'Google Calendar' : GoogleCalendarLogo,
            "Google Drive" : GoogleDriveLogo,
            'Google Gmail': GoogleGmailLogo,
            Youtube : YoutubeLogo,
            Weather : WeatherLogo,
            'Mail': NodemailerLogo,
            },
            WorkflowIcon,
        }
    },
    methods: {
        deleteAREA(index, id) {
            axios.post("/removeArea", { areaID : id} ,{ headers: { Authorization: this.$store.getters["user/getBearerToken"],},})
            .then(({data : {data}}) => {
                (data)
                this.currentWorkflows.splice(index, 1);
            })
            .catch((err) => {
                console.warn(err);
            });
        },
        startAREA(index, id) {
            axios.post("/runArea", { areaID : id} ,{ headers: { Authorization: this.$store.getters["user/getBearerToken"],},})
            .then(() => {
            })
            .catch((err) => {
                console.warn(err);
            });
            this.currentWorkflows[index].active = "true";
            
        },
        stopAREA(index, id) {
            axios.post("/stopArea", { areaID : id} ,{ headers: { Authorization: this.$store.getters["user/getBearerToken"],},})
            .then(() => {
            })
            .catch((err) => {
                console.warn(err);
            });
            this.currentWorkflows[index].active = "false";
            
        }
    },
    mounted() {
        axios.get("/area", { headers: {Authorization: this.$store.getters["user/getBearerToken"],},})
        .then(({data: {data}}) => {
            this.currentWorkflows = data.map(
                ({ _id, active, action, reaction }) => ({ _id, active, action: action.serviceName, reaction: reaction.serviceName })
            );
        })
        .catch((err) => {
            console.warn(err);
        })
    }
};
</script>

<style scoped>
.container-workflow {
    border-width: 1px;
}
.right-side {
    text-align: right;
}

.delete-area {
  position:absolute;
   top:15px;
   right:20px;
}

.start-area {
  background-color: #16166f
}

.area-text {
  font-weight: bold;
  font-size: 18px
  
}
</style>