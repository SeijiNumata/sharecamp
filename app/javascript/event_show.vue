<template>
  <div id="event_show">
        <div class="vue">
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
    </div>
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
         <input type="number" name="num01"  placeholder="数" min="0">
        <button type="button" @click="addInput">持っていく</button>
      </li>
    </ul>
    {{items}}
  </div>

</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      isActive: '1',
      message: "EventNew!",
      eventName:"",
      items: [],
      newItem:'',
      newEventsName: ''
    }
  },
  mounted(){
        // this.fetchItems();
        this.url();
        this.getItems();
  },
  computed: {
  },
  methods: {
    url(){
         const url = location.href
         console.log(url)
         const requestURLindex=21
         const requestURL=url.slice(requestURLindex);
         console.log(requestURL)
         return requestURL
    },
    getItems(){
      console.log(this.url()+".json")
      axios.get(this.url()+".json")
    
       .then((response)=>{
         console.log(response.data.item)
         this.items=response.data.item
         console.log(response.data)
         this.eventName=response.data.name
        }, (error) => {
          console.log(error, response);
        });
    },
    change(num){
      this.isActive = num
    },
    addInput(){
      console.log("追加すすr")
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
input{
  display: block;

}
  ul{
    margin: 0;
    padding: 0;
  }
  li{
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
  .tabs :checked + label {
    background-color: #000;
    border-color: #000;
    color: #fff;
    cursor: auto;
  }
  .contents{
    overflow: hidden;
    margin-top: -1px;
  }
  .contents li {
    width: 320px;
    padding: 20px;
    border: 1px solid #ccc;
  }

  contents li{
    display: none;
  }
  .contents li.active {
    display: block;
    color:red;
    background-color: red;
  }

  .vue_radio input{
    display: none;
  }
</style>
