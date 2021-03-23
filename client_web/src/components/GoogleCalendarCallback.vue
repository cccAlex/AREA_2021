<template>
    <div>
    </div>
</template>

<script>

export default {
    name: 'GoogleCalendarCallback',
    mounted() {
        const { state, code } = this.$route.query;

        this.$store.dispatch('area/signWithGoogleCalendar', { state, code })
            .then(() => {
                if (state == 'first') {
                    var firstService = {
                        name: null,
                        serviceName: 'Google Calendar',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setFirstService", firstService);
                } if (state == 'second') {
                    var secondService = {
                        name: null,
                        serviceName: 'Google Calendar',
                        serviceParams: {},
                        params: {},
                        isLogged: true,
                    }
                    this.$store.dispatch("area/setSecondService", secondService);
                }
                this.$router.push({ name: 'TheHome', params: {success: 'success', service: 'Google Calendar', state: state}});
            })
            .catch(() => this.$router.push({ name: 'TheHome', params: {error: 'connection to google calendar failed', service: 'google calendar', state: state}}));
    },
};
</script>
