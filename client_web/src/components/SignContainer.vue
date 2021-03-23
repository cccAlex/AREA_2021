<template>
  <div class="signContainer">
    <div class="signSplit signSplitLeft">
      <div class="descriptionContainer">
        <!-- <img class="signLogo" :src="logoLight" /> -->
        <br />
        <span class="text-white h3 font-weight-bold">Welcome to AREA !</span>
        <br /><br /><br />
        <span class="text-white h4 text-justify">Connect your apps and automate workflows Easy automation for busy people. AREA moves info between your web apps automatically, so you can focus on your most important work.</span>
      </div>
    </div>
    <div class="signSplit signSplitRight">
      <div class="descriptionContainerMini pb-3">
        <span class="text-white h3 font-weight-bold"><!-- <img class="signLogoMini" :src="logoLight" /> -->Welcome to AREA !</span>
        <br /><br />
        <span class="text-white h4 text-justify">Texte à afficher</span>
      </div>
      <slot>Hello</slot>
    </div>
  </div>
</template>

<script>
import logoLight from "@/assets/google_logo.png";

export default {
  logoLight,
  name: "SignContainer",
};
</script>

<style>
.signContainer {
  min-height: 100vh;
  background: linear-gradient(to top right, #002FFF, #FF5520);
}
.descriptionContainer {
  padding-left: 200px;
  width: 500px;
}
.signLogo {
  width: 200px;
  height: auto;
}
.signLogoMini {
  width: 100px;
  height: auto;
  float: left;
  padding-right: 10px;
}
.signSplit {
  top: 0;
  width: 50%;
  height: 100%;
  position: fixed;
  overflow: hidden;
  background: rgba(255, 0, 0 ,0);
}
.signSplitLeft {
  left: 0;
  padding-left: 35px;
  padding-top: 5%;
}
.signSplitRight {
  right: 0;
  min-height: 100vh;
  padding-top: 10%;
}
.descriptionContainerMini {
  width: 300px;
  margin-left: auto;
  margin-right: auto;
}

@media screen and (min-width: 1050px) {
  .descriptionContainerMini {
    display: none
  }
}

@media screen and (max-width: 1050px) {
  .signSplit {
    top: auto;
    width: auto;
    position: static;
    margin-left: 75px;
    margin-right: 75px;
  }
  .signSplitLeft {
    display: none;
  }
  .signSplitRight {
    right: auto;
  };
}

@media screen and (max-width: 550px) {
  .signSplit {
    margin-left: 35px;
    margin-right: 35px;
  }
}

@media screen and (max-height: 600px) {
  .signContainer {
    height: 800px;
    width: 400px;
    overflow: auto;
  }
}

</style>