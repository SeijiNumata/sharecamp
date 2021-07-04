<template>
<div>
<p>{{items}}</p>
  <form>
 <ul>
        <li v-for="(item, index) in items" :key="item.id">
          <!-- 各入力ボックス -->
          <input v-model="items[index].name">
          <input type="number" name="num01" min="0" v-model="items[index].need_number">
          
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
      pageUrl:{
        type: String
      }
    },
    data() {
      return {
        updateItems:[],
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
    },
    computed: {},
    methods: {
      setUrl() {
        const url = location.href
        this.setItemRequestUrl(url)
        this.setEditUrl(url)
      },
      setItemRequestUrl(url){
        const requestEventURLIndexFront = 21 // /events/IDを取得する
        const requestEventUrlIndexBack = 44
        this.getItemRequestUrl = (url.slice(requestEventURLIndexFront)).slice( 0, requestEventUrlIndexBack )

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
           for (const item of this.items){
             console.log("----")
            console.log(item.name)
           }
            console.log(this.items)
            this.eventName = response.data.name
          }, (error) => {
            console.log(error, response);
          });
      },
      addInput() {
        this.items.push(''); // 配列に１つ空データを追加する
      },
      updateItems(){
        
      }
    }
  }


</script>

