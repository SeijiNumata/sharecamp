<template>
  <div id="event-show">
    <div class="event_head">
      <h1 class="event_title">
        {{ eventName }}
      </h1>
      <a
        :href="eventEditUrl"
        class="edit-button"
      > 内容変更</a>
    </div>
    <div class="show_component">
      <ul class="tabs">
        <li
          :class="{'active': isActive === '1'}"
          class="need-items-tab"
          @click="changeTab('1')"
        >
          持ってきて<br class="br-sp">ほしいもの
        </li>
        <li
          :class="{'active': isActive === '2'}"
          class="current-user-bring-item-tab"
          @click="changeTab('2')"
        >
          自分が<br class="br-sp">持っていくもの
        </li>
        <li
          :class="{'active': isActive === '3'}"
          class="invite-message-tab"
          @click="changeTab('3')"
        >
          参加者を呼ぶ
        </li>
      </ul>

      <ul class="contents">
        <li v-if="isActive === '1'">
          <h2>誰か持ってきて</h2>
          <event-show-item
            v-for="(item) in items"
            :key="item.id"
            :item-name="item.name"
            :need-number="item.need_number"
            :item="item"
            :current-user-id="currentUserId"
          />
        </li>
        <li
          v-else-if="isActive === '2'"
          class="self-brings-contents"
        >
          <h2>自分の持ち物</h2>
          <event-show-current-user-item
            v-for="(item) in items"
            :key="item.id"
            :item="item"
            :current-user-id="currentUserId"
          />
        </li>
        <li
          v-else-if="isActive === '3'"
          class="invite"
        >
          <p class="invite-message-title">
            以下の文章を参加者に伝え、<br class="br-sp">誰かに持ってきてもらおう！！
          </p>
          <p class="invite-message-content">
            {{ message }}
          </p>
          <button @click="cp()">
            コピー
          </button>
        </li>
      </ul>
    </div>
    <div>
      <modal
        class="modal"
        name="modal-message-from-create"
        width="80%"
        :max-width="630"
        :adaptive="true"
      >
        <div class="modal-header">
          <h2>以下の文章を参加者に伝え、<br class="br-sp">誰かに持ってきてもらおう！！</h2>
        </div>
        <div class="modal-body">
          <div class="modal-body-text">
            <p>「{{ eventName }}」で誰かに持ってきてもらいたいものリストはこちら</p>
            <p>{{ url }}</p>
            <p>持ってきてくれる人募集中です！</p>
          </div>
          <div class="modal-body-button">
            <button @click="cp()">
              コピー
            </button>
            <button @click="hide">
              閉じる
            </button>
          </div>
        </div>
      </modal>
    </div>
  </div>
</template>

<script>
/* eslint-disable no-undef */
import axios from 'axios'
import eventShowItem from './event-show-item.vue'
import eventShowCurrentUserItem from './event-show-current-user-item.vue'

export default {
  components: {
    'event-show-item': eventShowItem,
    'event-show-current-user-item': eventShowCurrentUserItem
  },
  props: {
    currentUserId: {
      type: String,
      default: ''
    },
    fromCreate: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      isActive: '1',
      eventName: '',
      items: [],
      selectedNumber: '',
      message: '',
      getItemRequestUrl: '',
      eventEditUrl: '',
      url: ''
    }
  },
  mounted () {
    this.setUrl()
    this.getItems()
    this.modal()
  },
  methods: {
    setUrl () {
      this.url = location.href
      this.setItemRequestUrl(this.url)
      this.setEditUrl(this.url)
    },
    setItemRequestUrl (url) {
      const requestEventURLindex = -44 // /events/IDを取得する
      this.getItemRequestUrl = url.slice(requestEventURLindex)
    },
    setEditUrl (url) {
      const eventIdIndex = -36
      const eventId = url.slice(eventIdIndex)
      this.eventEditUrl = eventId + '/edit'
    },
    getItems () {
      axios.get(this.getItemRequestUrl + '.json')
        .then((response) => {
          this.items = response.data.item
          this.eventName = response.data.name
          this.inviteMessage()
        }, (error) => {
          console.log(error, response)
        })
    },
    changeTab (num) {
      this.isActive = num
    },
    inviteMessage () {
      this.message = '「' + this.eventName + '」で誰かに持ってきてもらいたいものリストはこちら\n' + this.url + '\n' + '持ってきてくれる人募集中です！'
    },
    createUserBringItems (item, selectedNumber) {
      axios.post('/api/user_bring_items', {
        item: item,
        selectedNumber: selectedNumber
      })
    },
    cp () {
      this.$copyText(this.message)
      this.hide()
    },
    modal () {
      if (this.fromCreate === 'from_create') {
        this.show()
      }
    },
    show: function () {
      this.$modal.show('modal-message-from-create')
    },
    hide: function () {
      this.$modal.hide('modal-message-from-create')
    }
  }

}
</script>
