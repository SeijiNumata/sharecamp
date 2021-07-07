<template>
  <div id="event-show">
    <div class=event_head>
      <h1 class=event_title>{{eventName}}</h1>

      <a :href="eventEditUrl"> 内容変更</a>
    </div>
    <div class="show_component">
      <ul class="tabs">
        <li v-on:click="change('1')" v-bind:class="{'active': isActive === '1'}">持ってきてほしいもの</li>
        <li v-on:click="change('2')" v-bind:class="{'active': isActive === '2'}">自分が持っていくもの</li>
        <li v-on:click="change('3')" v-bind:class="{'active': isActive === '3'}">参加者を呼ぶ</li>
      </ul>

      <ul class="contents">
        <li v-if="isActive === '1'">
          <h2>誰か持ってきて</h2>
          <event-show-item v-for="(item) in items" v-bind:key="item.id" v-bind:item-name="item.name"
            v-bind:needNumber="item.need_number" v-bind:item="item" v-bind:currentUserId="currentUserId">
          </event-show-item>
        </li>
        <li class="self-brings-contents" v-else-if="isActive === '2'">
          <h2>自分の持ち物</h2>
          <event-show-current-user-item v-for="(item) in items" v-bind:key="item.id" v-bind:item="item"
            v-bind:currentUserId="currentUserId">
          </event-show-current-user-item>
        </li>
        <li class="invite" v-else-if="isActive === '3'">

          <p class="invite_message_title">以下の文章を参加者に伝え、誰かに持ってきてもらおう！！</p>
          <p class="invite_message_content">{{message}}</p>

          <button @click="cp()">コピー</button>
        </li>

      </ul>
    </div>
    <div>
      <modal class=modal name="modal-message-from-create" width=650px>
        <div class="modal-header">
          <h2>以下の文章を参加者に伝え、誰かに持ってきてもらおう！！</h2>
        </div>
        <div class="modal-body">
          <div class="modal-body-text">
            <p>「{{eventName}}」で誰かに持ってきてもらいたいものリストはこちら</p>
            <p>{{pageUrl}}</p>
            <p>持ってきてくれる人募集中です！</p>
          </div>
          <div class="modal-body-button">
            <button @click="cp()">コピー</button>
            <button @click="hide">閉じる</button>

          </div>
        </div>
      </modal>
    </div>
    <!-- <event-show-item v-for="(item) in items" v-bind:key="item.id" v-bind:item-name="item.name"
      v-bind:needNumber="item.need_number" v-bind:item="item" v-bind:currentUserId="currentUserId">
    </event-show-item>
    <h1> {{ currentUserId }}</h1> -->
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
      },
      fromCreate: {
        type: String
      },
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
        message: 'Copy These Text',
        eventEditUrl: "",
        getItemRequestUrl: "",
        eventEditUrl: ""
      }
    },
    mounted() {
      // this.fetchItems();
      this.setUrl();
      this.getItems()
      this.modal()
    },
    computed: {},
    methods: {
      setUrl() {
        const url = location.href
        this.setItemRequestUrl(url)
        this.setEditUrl(url)
      },
      setItemRequestUrl(url) {
        const requestEventURLindex = 21 // /events/IDを取得する
        this.getItemRequestUrl = url.slice(requestEventURLindex);

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
            this.eventName = response.data.name
            this.inviteMessage();
          }, (error) => {
            console.log(error, response);
          });
      },
      change(num) {
        this.isActive = num
      },
      inviteMessage() {

        this.message = "「" + this.eventName + "」で誰かに持ってきてもらいたいものリストはこちら\n" + this.pageUrl + "\n" + "持ってきてくれる人募集中です！"
      },
      addInput() {
        console.log("追加する")
        //fetchする
      },
      createUserBringItems(item, selectedNumber) {
        //todo putと分ける
        console.log(selectedNumber)
        axios.post('/api/user_bring_items', {
          item: item,
          selectedNumber: selectedNumber

        })
      },
      cp() {
        this.$copyText(this.message)
        this.hide()
        
      },
      modal() {
        
        if (this.fromCreate == "fromCreate") {
          this.show()
        }

      },
      show: function () {
        this.$modal.show('modal-message-from-create');
      },
      hide: function () {
        this.$modal.hide('modal-message-from-create');
      },

      //  fetchItems(){
      //    axios.get('/api/items.json')
      //    .then((response)=>{
      //        let self = this
      //      for(let i = 0; i < response.data.items.length; i++) {
      //           self.items.push(response.data.items[i]);
      //         }
      //       }, (error) => {
      //         console.log(error, response);
      //       });
      //     },
      //   createItem() {
      //       if(this.newItem == '') return;
      //       axios.post('/api/items', { item: { name: this.newItem } }).then((response) => {
      //         this.items.unshift(response.data);
      //         this.newItem = '';
      //       }, (error) => {
      //         console.log(error, response);
      //       });
      //     }
    }
  }
</script>

<style scoped>

</style>
