<template>

  <div id="event_show">

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
      <li v-else-if="isActive === '3'">コンテンツ3コンテンツ3コンテンツ3コンテンツ3</li>
    </ul>
    <h1>{{eventName}}</h1>
    <!-- <input v-model="newEventsName">
       <p>"誰かに持ってきて欲しいもの"</p>
       <input v-model="newItem" placeholder="to doを追加して下さい"> -->
    <!-- <div v-on:click="createItem"> -->
    <div>
      <!-- <i>追加</i> -->
    </div>
    <event-show-item v-for="(item) in items" v-bind:key="item.id" v-bind:item-name="item.name"
      v-bind:needNumber="item.need_number" v-bind:item="item" v-bind:currentUserId="currentUserId">
    </event-show-item>
    <h1> {{ currentUserId }}</h1>
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
    },
    data() {
      return {
        isActive: '1',
        message: "EventNew!",
        eventName: "",
        items: [],
        newItem: '',
        newEventsName: '',
        // itemName: '',
        selectedNumber: "",
      }
    },
    mounted() {
      // this.fetchItems();
      this.url();
      this.getItems();
    },
    computed: {},
    methods: {
      url() {
        const url = location.href
        console.log(url)
        const requestURLindex = 21
        const requestURL = url.slice(requestURLindex);
        console.log(requestURL)
        return requestURL
      },
      getItems() {
        console.log(this.url() + ".json")
        axios.get(this.url() + ".json")
          .then((response) => {
            console.log("items" + response.data.item)
            this.items = response.data.item
            console.log(response.data)
            console.log(this.items)
            this.eventName = response.data.name
          }, (error) => {
            console.log(error, response);
          });
      },
      change(num) {
        this.isActive = num
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
</style>
