<template>
  <div class="event-edit">
    <div class="event-edit-component">
      <h1 class="event-edit-title">
        持ち物分担リスト<br class="br-sp">内容変更
      </h1>
      <form>
        <p>イベント名<span class="event-edit-event-name-error">{{ eventsNameNullError }}</span></p>
        <input
          v-model.trim="eventName"
          class="event-edit-event-name"
        >

        <p>誰かに持ってきて欲しい物</p>
        <p
          v-if="newItemsNullError"
          class="event-edit-event-item-null-error"
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
            v-for="(neededItemInfo, index) in neededItemInfos"
            :key="neededItemInfo.id"
          >
            <input
              v-model.trim="neededItemInfo.name"
              class="event-edit-item-name"
              :readonly="neededItemInfo.readonly"
              :disabled="neededItemInfo.readonly"
              :class="{readonly:neededItemInfo.readonly}"
            >
            <select
              v-model="neededItemInfos[index].need_number"
              class="event-edit-item-number"
              name="item-number"
            >
              <option
                value=""
                :disabled="neededItemInfo.readonly"
                selected
                :style="neededItemInfo.readonly ? display: ''"
              >
                数
              </option>
              <option
                v-for="n of 20"
                :key="n"
              >
                {{ n }}
              </option>
            </select>
            <button
              class="event-edit-delete-button"
              type="button"
              @click="deleteItems(neededItemInfo.item_id,index)"
            >
              削除
            </button>
          </li>
        </ul>
        <button
          class="event-edit-add-button"
          type="button"
          @click="addInput"
        >
          +追加
        </button>
        <button
          class="event-edit-create-button"
          type="button"
          @click="updateItems"
        >
          この内容で登録
        </button>
      </form>
    </div>
  </div>
  </div>
</template>

<script>
/* eslint-disable camelcase */
/* eslint-disable no-undef */

import axios from 'axios'

export default {

  props: {
    currentUserId: {
      type: String,
      default: ''
    },
    pageUrl: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      isActive: '1',
      eventName: '',
      items: [],
      getItemRequestUrl: '',
      neededItemInfos: [],
      eventsNameNullError: '',
      newItemsNullError: '',
      newItemsNumberNullError: '',
      display: {
        display: 'none'
      }
    }
  },
  computed: {},
  mounted () {
    this.setUrl()
    this.getItems()
  },
  methods: {
    setUrl () {
      const url = location.href
      this.setItemRequestUrl(url)
    },
    setItemRequestUrl (url) {
      const requestEventURLIndexFront = -49 // "/events/ID"を取得する
      const requestEventUrlIndexBack = -5
      this.getItemRequestUrl = (url.slice(requestEventURLIndexFront)).slice(0, requestEventUrlIndexBack)
    },
    getItems () {
      axios.get(this.getItemRequestUrl + '.json')
        .then((response) => {
          this.items = response.data.item
          this.neededItemInfos = []
          for (const item of this.items) {
            this.neededItemInfos.push({
              name: item.name,
              need_number: item.need_number,
              readonly: true,
              item_id: item.id
            })
          }
          this.eventName = response.data.name
        }, (error) => {
          console.log(error, response)
        })
    },
    deleteItems (itemId, index) {
      if (itemId === undefined) {
        this.neededItemInfos.splice(index, 1)
      } else if (confirm('この持ち物を削除すると、他ユーザーの「持っていく」に登録中の情報も削除されます。\n本当によろしいですか？')) {
        axios.delete('/api/items/' + itemId, {
          itemId
        }).then((response) => {
          this.neededItemInfos.splice(index, 1)
        }, (error) => {
          console.log(error, response)
        })
      } else {
        return
      }
    },
    addInput () {
      this.neededItemInfos.push({
        name: '',
        need_number: ''
      })
    },
    updateItems () {
      if (this.checkForm() === false) {
        return
      }
      const eventsID = this.getItemRequestUrl.slice(8)
      const requestPath = '/api/events/' + eventsID
      // Can't verify CSRF token authenticityのエラーが出るためheardersに値を設定する
      axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest'
      axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')

      axios.patch(requestPath, {
        items: this.neededItemInfos,
        eventName: this.eventName
      })
        .then((response) => {
          const showPath = '/events/' + eventsID
          location.href = showPath
        }, (error) => {
          console.log(error, response)
        })
    },
    checkForm () {
      if (this.eventName === '') {
        this.eventsNameNullError = '※イベント名を入力してください'
        return false
      } else {
        this.eventsNameNullError = ''
      }

      for (let i = 0; i < this.neededItemInfos.length; ++i) {
        if (!this.neededItemInfos[i].name && this.neededItemInfos[i].need_number) {
          this.newItemsNullError = '※持ち物を入力してください'
          return false
        }
      }

      for (let i = 0; i < this.neededItemInfos.length; ++i) {
        if (this.neededItemInfos[i].name && !this.neededItemInfos[i].need_number) {
          this.newItemsNumberNullError = '※持ち物の数を入力してください'
          return false
        }
      }
    }
  }
}
</script>
