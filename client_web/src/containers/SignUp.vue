<template>
  <SignContainer>
    <div class="signUpContainer text-center mx-auto">
      <b-card title="Sign up">
        <b-card-text class="pt-3">
          <b-form-input class="borderless" v-model="username" placeholder="Username" />
          <div class="line"></div>
          <b-form-input class="borderless" v-model="email" placeholder="Email" />
          <div class="line"></div>
          <b-form-input class="borderless" v-model="password" placeholder="Password" type="password" />
          <div class="line"></div>
          <b-form-input class="borderless" v-model="confirmPassword" placeholder="Confirm password" type="password" />
        </b-card-text>
        <b-card-text v-if="error.length > 0">
          <p class="text-danger">{{ error }}</p>
        </b-card-text>
        <b-button class="mx-auto" variant="primary" @click="signUp"  :disabled="!username || !email || !password || !confirmPassword || password !== confirmPassword">
          Sign up
        </b-button>
        <b-card-text class="text-center pt-2">OR</b-card-text>
        <div class="mx-auto">
          <b-button class="borderRounded" variant="outline-primary" @click="getGoogleAuthURL">
            <img :src="googleLogo" class="googleLogo mb-1" />
            Sign up with Google
          </b-button>
          <b-card-text class="pt-3">
            Already registred ? <span class="text-primary cursor-pointer" @click="signIn">Sign in here</span>
          </b-card-text>
        </div>
      </b-card>
    </div>
  </SignContainer>
</template>

<script>
import SignContainer from '../components/SignContainer.vue';

import googleLogo from '../assets/google_logo.png';

export default {
  name: "SignUp",
  components: {
    SignContainer,
  },
  data() {
    return {
      googleLogo,
      username: '',
      email: '',
      password: '',
      confirmPassword: '',
      error: '',
    };
  },
  methods: {
    signUp() {
      if (this.password === this.confirmPassword) {
        this.loading = true;
        this.$store.dispatch('user/signUp', { username: this.username, email: this.email, password: this.password })
          .then(() => this.$router.push({ name: 'TheHome' }))
          .catch((err) => this.error = err)
          .finally(() => this.loading = false);
      } else
        this.error = 'Passwords have to be the same.';
    },
    getGoogleAuthURL() {
      const { redirectURL } = this.$route.query;

      this.$store.dispatch('user/getGoogleAuthURL', redirectURL)
        .then((url) => window.location = url)
        .catch((err) => this.error = err);
    },
    signIn() {
      this.$router.push({ name: 'SignIn', query: this.$route.query });
    }
  },
};
</script>

<style>
.signUpContainer {
  width: 300px;
  height: 500px;
}
.googleLogo {
  width: 20px;
  height: 100%;
}
</style>