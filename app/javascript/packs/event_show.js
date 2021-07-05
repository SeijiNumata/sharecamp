import Vue from 'vue'
import EventShow from '../event-show.vue'
import VueClipboard from 'vue-clipboard2'
import VModal from 'vue-js-modal'

// document.addEventListener('DOMContentLoaded', () => {
//   const eventShow = new Vue({
//     render: h => h(EventShow)
//   }).$mount()
//   document.body.appendChild(eventShow.$el)
//   console.log(eventShow)
// })

// document.addEventListener('DOMContentLoaded', () => {
//   const selector = '#js-event_show'
//   const announcements = document.querySelector(selector)
//   if (announcements) {
//     new Vue({
//       render: (h) =>
//         h(EventShow, {
//         })
//     }).$mount(selector)
//   }
// })
Vue.use(VueClipboard)
Vue.use(VModal)
document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    render: h => h(EventShow,{ props: document.getElementById("event_show").dataset})
  }).$mount()
  document.body.appendChild(app.$el)

  console.log(app)
})
