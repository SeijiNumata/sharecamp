import Vue from 'vue'
import EventNew from '../event_new.vue'

document.addEventListener('DOMContentLoaded', () => {
  const eventNew = new Vue({
    render: h => h(EventNew)
  }).$mount()
  document.body.appendChild(eventNew.$el)

  console.log(eventNew)
})
