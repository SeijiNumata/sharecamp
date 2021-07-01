<template>

  <div id="event_show">

    <ul class="tabs">
      <li v-on:click="change('1')" v-bind:class="{'active': isActive === '1'}">持ってきてほしいもの</li>
      <li v-on:click="change('2')" v-bind:class="{'active': isActive === '2'}">自分が持っていくもの</li>
      <li v-on:click="change('3')" v-bind:class="{'active': isActive === '3'}">参加者を呼ぶ</li>
    </ul>

    <ul class="contents">
      <li v-if="isActive === '1'">コンテンツ1コンテンツ1コンテンツ1コンテンツ1</li>
      <li v-else-if="isActive === '2'">コンテンツ2コンテンツ2コンテンツ2コンテンツ2</li>
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
    <ul>
      <li v-for="(item, index) in items" :key="item.id">
        <!-- <input type="checkbox" v-model="item.is_done" v-on:click="update(item.id, index)"> -->
        <span v-bind:class="{name: item.name}">{{ item.name }}</span>
        <span>{{ item.need_number}}</span>
        <!-- <label class="form-label" for="typeNumber">Number input</label>
         <input type="number" id="typeNumber" name="num01"  step="1" placeholder="1" min="0"> -->
        <!-- <select v-model="selectedNumber" name="example">
          <option value='' disabled selected style='display:none;'>数</option>
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="4">4</option>
          <option value="5">5</option>
          <option value="6">6</option>
          <option value="7">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option value="10">10</option>
        </select> -->

        <select v-model="selectedNumber" name="example">
          <option value='数' disabled selected style='display:none;'>数</option>
          <option v-for="n of item.need_number" :key="n" >{{n}}</option>
           </select>

        <p>{{items[index]}}</p>
        <!-- <p>{{selectedNumber[index]}}</p> -->
        <button type="button"  @click="createUserBringItems(item,selectedNumber)">持っていく</button>
        </br>
      </li>
    </ul>
    {{items}}
   <item  v-for="(item) in items" 
   v-bind:key="item.id"
   v-bind:name="item.name"
   v-bind:needNumber="item.need_number" 
   v-bind:item="item"
   v-bind:currentUserId="currentUserId">
   </item>
   <h1 > {{ currentUserId }}</h1>
  </div>

</template>

<script>
  import axios from 'axios';
  import Item from './item.vue'

  export default {
    components:{
      item: Item
    },
      props:{
    currentUserId: { type: String },
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
    width: 320px;
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
