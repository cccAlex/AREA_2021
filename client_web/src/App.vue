<template>
  <TheNavigation v-if="navbar">
    <router-view :key="$route.path" />
  </TheNavigation>
  <router-view v-else :key="$route.path" />
</template>

<script>
import TheNavigation from "./components/TheNavigation.vue";

export default {
  name: "App",
  components: {
    TheNavigation,
  },
  computed: {
    navbar() {
      return this.$route.meta.navigation;
    },
  },
};
</script>

<style>
.cursor-pointer {
  cursor: pointer;
}
.line {
  border-bottom: 1px solid grey;
}
.borderRounded {
  border-radius: 50px !important;
}
.borderless {
  border-width: 0 !important;
}
</style>