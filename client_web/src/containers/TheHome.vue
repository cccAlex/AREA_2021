<template>
  <div>
      <b-container fluid>
        <b-row class="text-center border">


          <b-col class="border-right">
            <div>
              <b-navbar-brand @click="setSelectedComponent('Home')" style="width: 100%"><b-button block variant :class="['shadow', isSelected('Home') ? 'button-style' : 'button-style-unactive']">Home</b-button></b-navbar-brand>
            </div>
            <div>
              <b-navbar-brand @click="setSelectedComponent('MyWorkflows')" style="width: 100%"><b-button block variant :class="['shadow', isSelected('MyWorkflows') ? 'button-style' : 'button-style-unactive']">My workflows</b-button></b-navbar-brand>
            </div>
            <div>
              <b-navbar-brand @click="setSelectedComponent('MyServices')" style="width: 100%"><b-button block variant :class="['shadow', isSelected('MyServices') ? 'button-style' : 'button-style-unactive']">My services</b-button></b-navbar-brand>
            </div>
            <div>
              <b-navbar-brand @click="setSelectedComponent('Help')" style="width: 100%"><b-button block variant :class="['shadow', isSelected('Help') ? 'button-style' : 'button-style-unactive']">Help</b-button></b-navbar-brand>
            </div>
          </b-col>

          <b-col cols="9">
            <component :is="Components[selectedComponent]">{selectedComponent}</component>
          </b-col>


        </b-row>
      </b-container>
  </div>
</template>

<script>
import Home from "@/components/TheHome";
import Services from "@/components/Services";
import Workflows from "@/components/Workflows";
import Help from "@/components/Help";

export default {
  name: 'TheHome',
  components: {
    Home,
  },
  data() {
    return {
      selectedComponent: "Home",
      Components: {
        "Home": Home,
        "MyServices": Services,
        "MyWorkflows": Workflows,
        "Help": Help,
      },
    }
  },
  mounted() {
    const { error } = this.$route.params;
    if (error) {
      this.error = true;
    }
  },
  methods: {
    isSelected(selected) {
      return this.selectedComponent == selected ? true: false;
    },
    setSelectedComponent(selected) {
      this.selectedComponent = selected;
    },
  }
};
</script>

<style>
</style>