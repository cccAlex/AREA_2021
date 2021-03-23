<template>
    <div>
    </div>
</template>

<script>

export default {
    name: 'YoutubeCallback',
    mounted() {
        const { state, code } = this.$route.query;

        this.$store.dispatch('area/signWithYoutube', { state, code })
            .then(() => {
                if (state == 'first') {
                    var firstService = {
                        name: null,
                        serviceName: 'Youtube',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setFirstService", firstService);
                } if (state == 'second') {
                    var secondService = {
                        name: null,
                        serviceName: 'Youtube',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setSecondService", secondService);
                }
                this.$router.push({ name: 'TheHome', params: {success: 'success', service: 'Youtube', state: state}});
            })
            .catch(() => this.$router.push({ name: 'TheHome', params: {error: 'connection to youtube failed', service: 'youtube', state: state}}));
    },
};
</script>
