<template>
  <div>
    <h4>HELP</h4>
    <p style="text-align: left">Welcome to AREA's guide, we will help you here to use all
    the functionalities of the application. Learn how to connect applications
    that you know from creating workflows, automating tasks
    and all this while saving time. This guide is for personal use
    technical and non-technical, to new users and anyone else
    wanting to learn more about AREA.</p>
    <h4>Create your workflow</h4><br/>
    <p style="text-align: left">We have set up many services that you can use
    quickly with your personal accounts. Here's how to make a workflow:<br/><br/>

    <strong>Step 1:</strong> Go to the home page then select the name of the
    services you want to solicit for your workflow.<br/><br/>
    <img :src="first" />

    <strong>Step 2:</strong> Press the Login button for you
    Login to your service account. <br/><br/>
    <img :src="second" />

    <strong>Step 3:</strong> Select an action for your workflow, a
    action is an event that will trigger your workflow. For example, you
    can choose "Love spotify music" from the spotify service as action.<br/><br/>
    <img :src="third" />

    <strong>Step 4:</strong> Select a response for your workflow, a
    reaction is an event that will be triggered when the action is taken.
    done. For example, you can choose "Send a Discordant Message" from the
    Discord service as a reaction.<br/><br/>
    <img :src="fourth" />

    <strong>Step 5:</strong> Finally, choose a refresh rate of
    your workflow and press the Create AREA button to create your workflow.</p><br/>
    <img :src="fifth" />
    <h4>Manage your Workflows</h4><br/>
    <h5 style="text-align: left">Supprimer ses Workflows : </h5>

    <p style="text-align: left">Press the "Delete" button to delete your workflow.</p><br/><br/>

  </div>
</template>

<script>
import first from "@/assets/1.png";
import second from "@/assets/2.png";
import third from "@/assets/3.png";
import fourth from "@/assets/4.png";
import fifth from "@/assets/5.png";

export default {
  name: "TheHome",
  data() {
    return {
      first,
      second,
      third,
      fourth,
      fifth
    }
  }
}

</script>

<style scoped>
img {
  width: 93vh;
  margin-bottom: 20px;
}
</style>