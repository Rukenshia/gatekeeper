import 'regenerator-runtime/runtime';

const app = new Vue({
  el: '#app',
  data: {
    team: {
      id: null,
      members: [],
    },
    users: [],
    loading: true,
  },
  async mounted() {
    this.team = {
      ...this.team,
      ...window.vueData,
    };

    const { data } = await axios.get(`/api/v1/teams/${this.team.id}/members`);

    this.team.members = data.map(m => ({ ...m.user, role: m.role }));

    setTimeout(() => {
      this.loading = false;
    }, 500);
  },
  filters: {
    capitalize: function (value) {
      if (!value) {
        return '';
      }
      return value.toString().charAt(0).toUpperCase() + value.slice(1)
    },
  },
});
