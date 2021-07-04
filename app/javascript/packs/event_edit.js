import Vue from 'vue'
import EventEdit from '../event-edit.vue'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
      render: h => h(EventEdit)
    }).$mount()
    document.body.appendChild(app.$el)
  
    console.log(app)
  })
