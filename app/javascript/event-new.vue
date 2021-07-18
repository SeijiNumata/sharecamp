<template>
  <div id="event-new">
    <h1>新規作成</h1>
    <div class="event-name">
      <p>イベント名<span class="event-name-error">{{ eventsNameNullError }}</span></p>
      <input
        v-model.trim="newEventsName"
        placeholder="○○大学卒業キャンプ"
      >
    </div>
    <div class="event-content">
      <p>誰かに持ってきて欲しいもの</p>
      <p
        v-if="newItemsNullError"
        class="event-item-null-error"
      >
        {{ newItemsNullError }}
      </p>
      <p
        v-if="newItemsNumberNullError"
        class="event-item-null-error"
      >
        {{ newItemsNumberNullError }}
      </p>
      <form>
        <ul>
          <li
            v-for="(item, index) in items"
            :key="item.id"
          >
            <input
              v-model.trim="newItems[index]"
              class="item"
              type="text"
              :placeholder="itemsPlaceholders[index]"
            >
            <select
              v-model="newItemsNumber[index]"
              class="item-number"
              name="new-items-number"
            >
              <option
                value=""
                selected
              >
                数
              </option>
              <option
                v-for="n of 20"
                :key="n"
                :value="n"
              >
                {{ n }}
              </option>
            </select>
          </li>
        </ul>
        <button
          class="add-button"
          type="button"
          @click="addInput"
        >
          + 追加
        </button>

        <button
          class="create-button"
          type="button"
          @click="createItem"
        >
          この内容で登録
        </button>
        <div class="messasge-container">
          <p class="message">
            内容は後で変更ができます
          </p>
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
        newItemsNumber: [],
        newEventsName: '',
        itemsPlaceholders: ["テント", "タープ", "寝袋"],
        eventsNameNullError: "",
        newItemsNullError: "",
        newItemsNumberNullError: ""
      }
    },
    methods: {
      addInput() {
        this.items.push(""); // 配列に１つ空データを追加する
        this.newItemsNumber.push("")
      },
      createItem() {
        if (this.isFormNullCheck()) {
          return
        }
        let self = this
        this.newItemsNumber = this.newItemsNumber.filter(Boolean)

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
          const status = JSON.stringify(response.status)
          if (status == '201') {
            const url = JSON.stringify(response.data.id)
            const url_rep = url.replace(/\"/g, "")
            const redirectURL = ("users/new?e=" + url_rep)
            location.href = redirectURL
          }
        }, (error) => {
          console.log(error, response);
        });
      },
      isFormNullCheck() {
        if (this.newEventsName == '') {
          this.eventsNameNullError = "※イベント名を入力してください"
          return true
        } else {
          this.eventsNameNullError = ""
        }
        if (this.newItems.length == 0) {       
          this.newItemsNumberNullError = "※持ち物を入力してください"
          return true
        } else {
          for (let i = 0; i < this.newItemsNumber.length; ++i) {
            if (!this.newItems[i] && this.newItemsNumber[i]) {
              this.newItemsNumberNullError = "※持ち物を入力してください"
              return true
            }
          }
          for (let i = 0; i < this.newItems.length; ++i) {
            if (this.newItems[i] && !this.newItemsNumber[i]) {
              this.newItemsNumberNullError = "※持ち物の数を入力してください"
              return true
            }
          }
          return false
        }
      }
    }
  }
</script>
