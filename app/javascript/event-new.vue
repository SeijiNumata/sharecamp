<template>
  <div class="event-new">
    <h1 class="event-new-title">
      持ち物分担リスト作成
    </h1>
    <form>
      <div class="event-new-event-name">
        <label>イベント名

        </label>
        <p class="event-new-event-name-error">
          {{ eventsNameNullError }}
        </p>
        <input
          v-model.trim="newEventsName"
        >
        <p class="event-new-event-name-example">
          イベントの名称を入力してください（例）〇〇大学卒業キャンプ
        </p>
      </div>
      <div class="event-new-event-content">
        <label class="someone-bring-items">誰かに持ってきて欲しい物
        </label>
        <p class="describe-someone-bring-items">
          グループで各自が持ってくる必要はない、誰かが持ってくればいい物を入力してください。<br>
          例えばキャンプの場合、まな板や鍋は誰かが持ってくれば良い持ち物なので入力しましょう。<br>
        </p><p
          v-if="newItemsNullError"
          class="event-new-event-item-null-error"
        >
          {{ newItemsNullError }}
        </p>
        <p
          v-if="newItemsNumberNullError"
          class="event-item-null-error"
        >
          {{ newItemsNumberNullError }}
        </p>

        <ul>
          <li
            v-for="(item, index) in items"
            :key="item.id"
          >
            <div class="input-container">
              <input
                v-model.trim="newItems[index]"
                class="item-new"
                type="text"
              >
              <select
                v-model="newItemsNumber[index]"
                class="item-number-new"
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
            </div>
            <p class="event-new-bring-item-example">
              {{ itemsExamples[index] }}
            </p>
          </li>
        </ul>
        <button
          class="event-new-add-button"
          type="button"
          @click="addInput"
        >
          + 追加
        </button>

        <button
          class="event-new-create-button"
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
      </div>
    </form>
    </label>
  </div>
  </div>
</template>

<script>
/* eslint-disable camelcase */
/* eslint-disable no-undef */

import axios from 'axios'

export default {
  data () {
    return {
      items: ['', '', ''],
      newItems: [],
      newItemsNumber: ['', '', ''],
      newEventsName: '',
      itemsExamples: ['(例)まな板', '(例)鍋', '(例)トランプ'],
      eventsNameNullError: '',
      newItemsNullError: '',
      newItemsNumberNullError: ''
    }
  },
  methods: {
    addInput () {
      this.items.push('')
      this.newItemsNumber.push('')
    },
    createItem () {
      if (this.isFormNullCheck()) {
        return
      }
      const self = this
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
        self.items.unshift(response.data)
        this.newItems = ''
        const status = JSON.stringify(response.status)
        if (status === '201') {
          const url = JSON.stringify(response.data.id)
          const urlRep = url.replace(/\"/g, '')
          const redirectURL = ('users/new?e=' + urlRep)
          location.href = redirectURL
        }
      }, (error) => {
        console.log(error, response)
      })
    },
    isFormNullCheck () {
      if (this.newEventsName === '') {
        this.eventsNameNullError = '※イベント名を入力してください'
        return true
      } else {
        this.eventsNameNullError = ''
      }
      if (this.newItems.length === 0) {
        this.newItemsNumberNullError = '※持ち物を入力してください'
        return true
      } else {
        for (let i = 0; i < this.newItemsNumber.length; ++i) {
          if (!this.newItems[i] && this.newItemsNumber[i]) {
            this.newItemsNumberNullError = '※持ち物を入力してください'
            return true
          }
        }
        for (let i = 0; i < this.newItems.length; ++i) {
          if (this.newItems[i] && !this.newItemsNumber[i]) {
            this.newItemsNumberNullError = '※持ち物の数を入力してください'
            return true
          }
        }
        return false
      }
    }

  }
}
</script>
