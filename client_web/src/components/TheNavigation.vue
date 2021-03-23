<template>
  <div id="navigation">
    <b-navbar id="navbar" type="light" toggleable="sm" class="fixed-top">

    <b-sidebar
      id="sidebar-backdrop"
      backdrop
      shadow
    >
      <div class="px-3 py-2">
        <!-- TODO add -->
      </div>
    </b-sidebar>
    <b-navbar-brand class="cursor-pointer font-weight-bold" @click="goTo('TheHome')"> AREA</b-navbar-brand> <!-- TODO add logo -->
      <b-collapse id="nav-collapse" is-nav>
        <b-navbar-nav class="ml-auto">
          <b-nav-item @click="goTo('UserProfile')" class="mx-2"><b-icon icon="person-fill" font-scale="1.5"></b-icon></b-nav-item>
          <b-nav-item @click="signOut" class="mx-2"><b-icon icon="power" class="text-danger" font-scale="1.5"></b-icon></b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
    <b-card id="navigation-card" class="mt-5 mb-3 border-0">
        <div id="navigation-card-body" class="p-4">
            <slot>Bonjour !</slot>
        </div>
    </b-card>
  </div>
</template>

<script>

export default {
  name: "TheNavigation",
  data() {
    return {
      items: [
        { title: "Home", icon: "mdi-view-dashboard" },
        { title: "About", icon: "mdi-forum" },
      ],
    };
  },
  methods: {
    goTo(name) {
      if (this.$router.currentRoute.name !== name)
        this.$router.push({ name });
    },
    signOut() {
      this.$store.dispatch('user/signOut');
      this.$router.push({ name: 'SignIn' });
    }
  },
  computed: {
    title() {
      return this.$route.meta.title;
    }
  }
};
</script>

<style>
.logo {
  width: 30px;
  height: auto;
}
.addWidgetsBtn {
  border-radius: 10px;
  width: 135px;
  height: 80%;
  background: linear-gradient(to top right, #002FFF, #FF5520);
}
#navbar {
  background-color: #fff;
  border-bottom: solid 1px silver;
}
#navigation-card {
  background-color: #dddce1;
  min-height: 100vh;
}
#navigation-card-body {
  background-color: #fff;
}
#navbar-brand-logo {
  width: 36px;
  height: 36px;
}

@media screen and (max-width: 600px) {
  #navigation-card-body {
    min-width: 450px;
  }
}
</style>