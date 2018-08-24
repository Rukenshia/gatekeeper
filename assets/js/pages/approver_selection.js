import 'regenerator-runtime/runtime';
import { MDCList } from '@material/list';

const app = new Vue({
  el: '#app',
  data: {
    loading: true,
    members: [],
    selected: [],
  },
  async mounted() {
    const { data } = await axios.get(`/api/teams/${window.vueData.teamId}/members`);

    this.members = data;

    setTimeout(() => {
      this.loading = false;
    }, 500);
  },
  methods: {
    toggle(member) {
      const idx = this.selected.indexOf(member);

      if (idx != -1) {
        this.selected.splice(idx, 1);
      } else {
        this.selected.push(member);
      }
    },
  },
});
