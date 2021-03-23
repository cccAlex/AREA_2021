<template>
  <div>
    <b-button
      class="borderRounded"
      variant="outline-primary"
      @click.prevent="loginWithFacebook"
    >
      <!-- here -->
      <img :src="facebookLogo" class="googleLogo mb-1" />
      Sign in with Facebook
    </b-button>
  </div>
</template>

<script>
import facebookLogo from "@/assets/facebook_logo.png";
import axios from "@/plugins/axios";
import { initFbsdk } from "@/config/FacebookAuth";

export default {
  name: "FacebookLogin",
  data() {
    return {
      facebookLogo,
    };
  },
  mounted() {
    initFbsdk();
  },
  methods: {
    async checkFacebookToken(token) {
      if (token) {
        const redirectURL = this.$route.query.redirectURL || "/";
        axios
          .post("/signWithFacebook", {
            access_token: token, params: { redirectURL }
            })
          .then(({ data }) => {
            if (data.status) {
              this.$store.dispatch("user/setUser", data.data);
              this.$router.push(redirectURL);
            } else {
              console.warn(data.data);
            }
          })
          .catch((err) => {
            console.warn(err);
          });
      } else {
        console.warn("Error with facebook authentification!");
      }
    },
    loginWithFacebook() {
      window.FB.login(
        (response) => {
          this.checkFacebookToken(response.authResponse.accessToken);
        },
        { scope: "email" }
      );
    },
  },
};
</script>
<style scoped>
.googleLogo {
  width: 20px;
  height: 100%;
}
</style>