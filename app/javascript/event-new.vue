<template>
  <div id="event-new">
    <h1>新規作成</h1>
    <div class="event-name">
    <p>イベント名</p>
    <input placeholder="○○大学卒業キャンプ" v-model="newEventsName">
    </div>
    <div class="event-content">
    <p>誰かに持ってきて欲しいもの</p>
    <form>
      <ul>
        <li v-for="(item, index) in items" :key="item.id">
          <!-- 各入力ボックス -->
          <input class="item" type="text" v-model="newItems[index]" :placeholder="itemsPlaceholders[index]">

          <!-- <input class="item-number" type="number" name="num01" v-model="newItemsNumber[index]" placeholder="数" min="0"> -->
         <select class="item-number" name="example" v-model="newItemsNumber[index]">
            <option value='' disabled selected style='display:none;'>数</option>
            <option v-for="n of 20" :key="n">{{n}}</option>
        </select>
        </li>
      </ul>
      <button class="add-button" type="button" @click="addInput">+ 追加</button>
     
      <button class="create-button" type="button" @click="createItem">この内容で登録</button>
      <div class="messasge-container">
    <p class="message">内容は後で変更ができます</p>
  </div>
    </form>
</div>

  </div>


</template>

<script>
  import axios from 'axios';

  export default {
    data() {
      return {
        items: ["", "", ""],
        newItems: [],
        newItemsNumber: ["","",""],
        newEventsName: '',
        itemsPlaceholders:["テント","タープ","寝袋"]
      }
    },
    methods: {
      addInput() {
        this.items.push(""); // 配列に１つ空データを追加する
        this.newItemsNumber.push("")
      },
      createItem() {
        let self = this
        console.log(this.newItems)
        if (this.newItems == '') return;
        // axios.post('/api/items', {
          axios.post('/api/events', {
          item: {
            name: this.newItems,
            need_number: this.newItemsNumber
          },
          event: {
            name: this.newEventsName
          }
        }).then((response) => {
          self.items.unshift(response.data);
          this.newItems = '';
          // window.location.replace = '/';
          const status = JSON.stringify(response.status)
          console.log(status)
          if (status == '201') {
            console.log("aa" + JSON.stringify(response.data.id))
            const url = JSON.stringify(response.data.id)
            var url_rep = "";
            url_rep = url.replace(/\"/g, "")
            console.log("wtha"+url_rep)
            const redirectURL=("users/new?e="+url_rep)
            //const redirectURL=("users/new")
            console.log(redirectURL)
            location.href = redirectURL
          }

        }, (error) => {
          console.log(error, response);
        });
      }
    }
  }
</script>

<style scoped>

</style>
