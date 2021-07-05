<template>
  <div>
    <p>{{items}}</p>
    <form>
      <ul>
        <li v-for="(neededItemInfo, index) in neededItemInfos" :key="neededItemInfo.id">
          <!-- 各入力ボックス -->
          <input v-model="neededItemInfo.name" :readonly="neededItemInfo.readonly"
            :class="{readonly:neededItemInfo.readonly}">
          <input type="number" name="num01" min="0" v-model="neededItemInfos[index].need_number">

        </li>

      </ul>
      <button type="button" @click="addInput">追加する</button>
      <button type="button" @click="updateItems">この内容で登録</button>
    </form>
  </div>
</template>

<script>
  import axios from 'axios';
  import eventShowItem from './event-show-item.vue'
  import eventShowCurrentUserItem from './event-show-current-user-item.vue'

  export default {
    components: {
      "event-show-item": eventShowItem,
      "event-show-current-user-item": eventShowCurrentUserItem
    },
    props: {
      currentUserId: {
        type: String
      },
      pageUrl: {
        type: String
      }
    },
    data() {
      return {
        isActive: '1',
        message: "EventNew!",
        eventName: "",
        items: [],
        newItem: '',
        newEventsName: '',
        selectedNumber: "",
        eventEditUrl: "",
        getItemRequestUrl: "",
        eventEditUrl: "",
        neededItemInfos: []
      }
    },
    mounted() {
      // this.fetchItems();
      this.setUrl();
      this.getItems()
    },
    computed: {},
    methods: {
      setUrl() {
        const url = location.href
        this.setItemRequestUrl(url)
        this.setEditUrl(url)
      },
      setItemRequestUrl(url) {
        const requestEventURLIndexFront = 21 // /events/IDを取得する
        const requestEventUrlIndexBack = 44
        this.getItemRequestUrl = (url.slice(requestEventURLIndexFront)).slice(0, requestEventUrlIndexBack)

      },
      setEditUrl(url) {
        const eventIdIndex = 29
        const eventId = url.slice(eventIdIndex)
        this.eventEditUrl = eventId + "/edit"
      },
      getItems() {
        console.log(this.getItemRequestUrl + ".json")

        axios.get(this.getItemRequestUrl + ".json")
          .then((response) => {
            console.log("items" + response.data.item)
            this.items = response.data.item
            console.log(response.data)
            console.log(this.items)
            for (const item of this.items) {
              console.log("----")
              console.log(item.name + "" + item.need_number)
              this.neededItemInfos.push({
                name: item.name,
                need_number: item.need_number,
                readonly: true
              })
              console.log(this.neededItemInfos)
            }
            console.log(this.items)
            this.eventName = response.data.name
          }, (error) => {
            console.log(error, response);
          });
      },
      addInput() {
        this.neededItemInfos.push({
          name: " ",
          need_number: ""
        }); // 配列に１つ空データを追加する
      },
      updateItems() {
        const eventsID = this.getItemRequestUrl.slice(8)
        console.log("URKRR" + eventsID)
        console.log(this.neededItemInfos)
        const requestPath = "/api/events/" + eventsID
        axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest'
        axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
        axios.patch(requestPath, {
            items: this.neededItemInfos
          })
          .then((response) => {
            const status = JSON.stringify(response.status)
            console.log(requestPath)

            const showPath = "/events/" + eventsID

            location.href = showPath

          }, (error) => {
            console.log(error, response);
          });
      }
    }
  }
</script>
