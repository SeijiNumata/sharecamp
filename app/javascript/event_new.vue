<template>
  <div id="event_show">
    <p>イベント名</p>
    <input v-model="newEventsName">
    <p>誰かに持ってきて欲しいもの</p>
    <form>
      <ul>

        <li v-for="(item, index) in items" :key="item.id">
          <!-- 各入力ボックス -->
          <input type="text" v-model="newItems[index]">
          <input type="number" name="num01" v-model="newItemsNumber[index]" placeholder="数" min="0">
        </li>
      </ul>
      <button type="button" @click="addInput">追加する</button>
      <button type="button" @click="createItem">この内容で登録</button>
    </form>

    <p>内容は後で変更ができます</p>
    {{newItems}}
    {{newItems[0]}}
  </div>


</template>

<script>
  import axios from 'axios';

  export default {
    data() {
      return {
        items: ["", "", ""],
        newItems: [],
        newItemsNumber: [],
        newEventsName: ''
      }
    },
    methods: {
      addInput() {
        this.items.push(''); // 配列に１つ空データを追加する
      },
      createItem() {
        let self = this
        console.log(this.newItems)
        if (this.newItems == '') return;
        axios.post('/api/items', {
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
  input {
    display: block;
  }

  button {
    display: block;
  }
</style>
