<template>
  <div id="event_show">
    <p>{{ message }}</p>
      <p>イベント名</p>
       <input v-model="newEventsName">
       <p>"誰かに持ってきて欲しいもの"</p>
       <input v-model="newItem" placeholder="to doを追加して下さい">

      <div v-on:click="createItem">
        
        <i>追加</i>
        </div>
     <ul>
      <li v-for="(item, index) in items" :key="item.id">
        <input type="checkbox" v-model="item.is_done" v-on:click="update(item.id, index)">
        <span v-bind:class="{name: item.name}">{{ item.name }}</span>
        <button v-on:click="deleteTask(item.id, index)">削除</button>
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
      message: "EventNew!",
      items: [],
      newItem:'',
      newEventsName: ''
    }
  },
  mounted(){
        this.fetchItems();
  },
  methods: {
   fetchItems(){
     axios.get('/api/items')
     .then((response)=>{
         let self = this
       for(let i = 0; i < response.data.items.length; i++) {
            self.items.push(response.data.items[i]);
          }
        }, (error) => {
          console.log(error, response);
        });
      },
    createItem() {
        if(this.newItem == '') return;
        axios.post('/api/items', { item: { name: this.newItem } }).then((response) => {
          this.items.unshift(response.data);
          this.newItem = '';
        }, (error) => {
          console.log(error, response);
        });
      }
  }
}
</script>

<style scoped>
input{
  display: block;

}
</style>
