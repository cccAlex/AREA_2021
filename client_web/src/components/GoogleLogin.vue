<template>
  <div>
    <b-button
      class="borderRounded"
      variant="outline-primary"
      @click.prevent="loginWithGoogle"
    >
      <!-- here -->
      <img :src="googleLogo" class="googleLogo mb-1" />
      Sign in with Google
    </b-button>
  </div>
</template>

<script>
import googleLogo from "../assets/google_logo.png";

import axios from "@/plugins/axios";
export default {
  name: "GoogleLogin",
  data() {
    return {
      googleLogo,
    };
  },
  methods: {
    loginWithGoogle() {
        axios
        .get("/getGoogleAuthURL", { params: { redirectURL: this.$route.query.redirectURL || "/" } })
        .then(
          ({
            data: {
              data: { url },
            },
          }) => {
            window.open(url, "_self");
          }
        )
        .catch((err) => {
          console.warn(err);
        });
    },
  },
};
</script>
<style>
.googleLogo {
  width: 20px;
  height: 100%;
}
</style>
