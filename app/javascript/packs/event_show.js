import Vue from 'vue'
import EventShow from '../event_show.vue'

document.addEventListener('DOMContentLoaded', () => {
  const eventShow = new Vue({
    render: h => h(EventShow)
  }).$mount()
  document.body.appendChild(eventShow.$el)

  console.log(eventShow)
})
