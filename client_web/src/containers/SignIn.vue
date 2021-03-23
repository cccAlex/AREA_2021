<template>
  <SignContainer>
    <div class="signInContainer text-center mx-auto">
      <b-card title="Sign in">
        <b-card-text class="pt-3">
          <b-form-input class="borderless" v-model="username" placeholder="Username" />
          <div class="line"></div>
          <b-form-input class="borderless" v-model="password" placeholder="Password" type="password" />
        </b-card-text>
        <b-card-text v-if="error.length > 0">
          <p class="text-danger">{{ error }}</p>
        </b-card-text>
        <b-button class="mx-auto" variant="primary"  :disabled="!username || !password" @click="signIn"> <!-- here -->
          Sign in
        </b-button>
        <b-card-text class="text-center pt-2">OR</b-card-text>
        <div class="mx-auto">
          <FacebookLogin />
          <GoogleLogin />
          <b-card-text class="pt-3">
            Not registered yet ? <span class="text-primary cursor-pointer" @click="signUp">Sign up here</span> <!-- here -->
          </b-card-text>
        </div>
      </b-card>
    </div>
  </SignContainer>
</template>

<script>
import GoogleLogin from "@/components/GoogleLogin.vue";
import FacebookLogin from "@/components/FacebookLogin.vue";
import SignContainer from '../components/SignContainer.vue';


export default {
  name: "SignIn",
  components: {
    GoogleLogin,
    FacebookLogin,
    SignContainer,
  },
  data() {
    return {
      username: '',
      password: '',
      error: this.$route.params?.err?.message || '',
    };
  },
  methods: {
    signIn() {

      this.loading = true;
      this.$store.dispatch('user/signIn', { username: this.username, password: this.password })
        .then(() => {
          this.$router.push({ name: 'TheHome' })
        })
        .catch((err) => this.error = err)
        .finally(() => this.loading = false);
    },
    signUp() {
      this.$router.push({ name: 'SignUp', query: this.$route.query });
    }
  },
};
</script>

<style scoped>
.signInContainer {
  width: 300px;
}
</style>