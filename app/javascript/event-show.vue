<template>

  <div id="event_show">
        <h1>{{fromCreate}}</h1>
      <h1>{{fromCreate}}</h1>
        <h1>{{fromCreate}}</h1>
          <h1>{{fromCreate}}</h1>
    <h1>{{eventName}}</h1>
    <button>内容変更</button>

<a :href="eventEditUrl">edit</a>
    <ul class="tabs">
      <li v-on:click="change('1')" v-bind:class="{'active': isActive === '1'}">持ってきてほしいもの</li>
      <li v-on:click="change('2')" v-bind:class="{'active': isActive === '2'}">自分が持っていくもの</li>
      <li v-on:click="change('3')" v-bind:class="{'active': isActive === '3'}">参加者を呼ぶ</li>
    </ul>

    <ul class="contents">
      <li v-if="isActive === '1'">
       <h1>持ってきて欲しいもの</h1>
        <event-show-item 
        v-for="(item) in items" 
        v-bind:key="item.id" 
        v-bind:item-name="item.name"
        v-bind:needNumber="item.need_number" 
        v-bind:item="item" 
        v-bind:currentUserId="currentUserId">
        </event-show-item>
      </li>
      <li v-else-if="isActive === '2'">
        <event-show-current-user-item
        v-for="(item) in items"
        v-bind:key="item.id"
        v-bind:item="item" 
        v-bind:currentUserId="currentUserId"
        >
        </event-show-current-user-item>コンテンツ2コンテンツ2コンテンツ2コンテンツ2</li>
      
      <li v-else-if="isActive === '3'">
        <div id="copy" value="a">
        <p>{{message}}</p>
         </div>
       <button @click="cp()">コピー</button>
      </li>
     
    </ul>

    <div>

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
      pageUrl:{
        type: String
      },
      fromCreate:{
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
         getItemRequestUrl:"",
         eventEditUrl:""
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
      setItemRequestUrl(url){
        const requestEventURLindex = 21 // /events/IDを取得する
        this.getItemRequestUrl = url.slice(requestEventURLindex);
        console.log("agaegaega"+this.getItemRequestUrl)

      },
      setEditUrl(url){
        const eventIdIndex = 29
        const eventId=url.slice(eventIdIndex)
        this.eventEditUrl=eventId+"/edit"
      },
      getItems() {
        console.log(this.getItemRequestUrl + ".json")
        axios.get(this.getItemRequestUrl+ ".json")
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
      inviteMessage(){

  this.message="「"+this.eventName+"」で誰かに持ってきてもらいたいものリストはこちら\n"+this.pageUrl+"\n持ってきてくれる人募集中です！"
      },
      addInput() {
        console.log("追加すすr")
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
      cp(){
        console.log("coy")
      
       this.$copyText(this.message).then(function (e) {
                console.log(e)
            }, function (e) {
                console.log(e)
            })
      },
      modal(){
       const modal= window.sessionStorage.getItem("fromCreate")
       console.log(modal)
        
      }

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
  input {
    display: block;

  }

  ul {
    margin: 0;
    padding: 0;
  }

  li {
    list-style: none;
  }

  .tabs {
    overflow: hidden;
  }

  .tabs li,
  .tabs label {
    float: left;
    padding: 10px 20px;
    border: 1px solid #ccc;
    cursor: pointer;
    transition: .3s;
  }

  .tabs li:not(:first-child),
  .tabs label:not(:first-of-type) {
    border-left: none;
  }

  .tabs li.active,
  .tabs :checked+label {
    background-color: #000;
    border-color: #000;
    color: #fff;
    cursor: auto;
  }

  .contents {
    overflow: hidden;
    margin-top: -1px;
  }

  .contents li {
    width: 1000px;
    padding: 20px;
    border: 1px solid #ccc;
  }

  contents li {
    display: none;
  }

  .contents li.active {
    display: block;
    color: red;
    background-color: red;
  }

  .vue_radio input {
    display: none;
  }
  .textarea {
     display: inline-block;
     width: 100%; /* 幅：横いっぱいに */
  height: 90px; /* 高さ */
  }
  p{
    white-space: pre-line;
    word-wrap:break-word
  }
</style>
