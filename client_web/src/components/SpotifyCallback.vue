<template>
    <div>
    </div>
</template>

<script>

export default {
    name: 'SpotifyCallback',
    mounted() {
        const { state, code } = this.$route.query;
        this.$store.dispatch('area/signWithSpotify', { state, code })
            .then(() => {
                if (state == 'first') {
                    var firstService = {
                        name: null,
                        serviceName: 'Spotify',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setFirstService", firstService);
                } if (state == 'second') {
                    var secondService = {
                        name: null,
                        serviceName: 'Spotify',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setSecondService", secondService);
                }
                this.$router.push({ name: 'TheHome' });
            })
            .catch(() => {
                this.$router.push({ name: 'TheHome' });
            });
    },
};
</script>
