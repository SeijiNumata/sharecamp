<template>
  <div class="event-edit">
    <h1>内容変更</h1>
    <p>イベント名<span class="event-name-error">{{ eventsNameNullError }}</span></p>
    <input
      v-model="eventName"
      class="event-name"
    >
    <form>
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
      <ul>
        <li
          v-for="(neededItemInfo, index) in neededItemInfos"
          :key="neededItemInfo.id"
        >
          <!-- 各入力ボックス -->
          <input
            v-model="neededItemInfo.name"
            class="item-name"
            :readonly="neededItemInfo.readonly"
            :disabled="neededItemInfo.readonly"
            :class="{readonly:neededItemInfo.readonly}"
          >
          <!-- <input class="item-number" type="number" name="num01" min="0" v-model="neededItemInfos[index].need_number"> -->
          <select
            v-model="neededItemInfos[index].need_number"
            class="item-number"
            name="example"
          >
            <option
              value=""
              disabled
              selected
              style="display:none;"
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
            class="delete-button"
            type="button"
            @click="deleteItems(neededItemInfo.item_id,index)"
          >
            削除
          </button>
        </li>
      </ul>
      <button
        class="add-button"
        type="button"
        @click="addInput"
      >
        追加する
      </button>
      <button
        class="create-button"
        type="button"
        @click="updateItems"
      >
        この内容で登録
      </button>
    </form>
  </div>
</template>

<script>
  import axios from 'axios';

  export default {

    props: {
      currentUserId:{type: String, default: '',},
      pageUrl: { type: String, default:'',},
      fromCreate: { type: String, default:''},
    },
    data() {
      return {
        isActive: '1',
        message: 'EventNew!',
        eventName: '',
        items: [],
        newItem: '',
        newEventsName: '',
        selectedNumber: "",
        eventEditUrl: "",
        getItemRequestUrl: "",
        neededItemInfos: [],
        eventsNameNullError: "",
        newItemsNullError: "",
        newItemsNumberNullError: ""
      }
    },
    computed: {},
    mounted() {
      this.setUrl();
      this.getItems()
    },
    methods: {
      setUrl() {
        const url = location.href
        this.setItemRequestUrl(url)
        this.setEditUrl(url)
      },
      setItemRequestUrl(url) {
        const requestEventURLIndexFront = 21 // "/events/ID"を取得する
        const requestEventUrlIndexBack = 44
        this.getItemRequestUrl = (url.slice(requestEventURLIndexFront)).slice(0, requestEventUrlIndexBack)

      },
      setEditUrl(url) {
        const eventIdIndex = 29
        const eventId = url.slice(eventIdIndex)
        this.eventEditUrl = eventId + "/edit"
      },
      getItems() {
        axios.get(this.getItemRequestUrl + ".json")
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
            console.log(error, response);
          });
      },
      deleteItems(item_id, index) {
        if (item_id == undefined) {
          this.neededItemInfos.splice(index, 1)
        } else if (confirm('この持ち物を削除すると、他ユーザーの「持っていく」に登録中の情報も削除されます。\n本当によろしいですか？')) {
          axios.delete('/api/items/' + item_id, {
            item_id
          }).then((response) => {
            console.log(response.data)
            this.neededItemInfos.splice(index, 1)
          }, (error) => {
            console.log(error, response);
          });
        } else {
          return;
        }
      },
      addInput() {
        this.neededItemInfos.push({
          name: "",
          need_number: ""
        }); // 配列に１つ空データを追加する
      },
      updateItems() {
        console.log("チェック" + this.checkForm())
        if (this.checkForm() == false) {
          return
        }
        const eventsID = this.getItemRequestUrl.slice(8)
        const requestPath = "/api/events/" + eventsID
        axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest'
        axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
        axios.patch(requestPath, {
            items: this.neededItemInfos,
            eventName: this.eventName
          })
          .then((response) => {
            const status = JSON.stringify(response.status)
            const showPath = "/events/" + eventsID
            location.href = showPath
          }, (error) => {
            console.log(error, response);
          });
      },
      checkForm() {

        if (this.eventName == '') {
          this.eventsNameNullError = "※イベント名を入力してください"
          return false
        } else {
          this.eventsNameNullError = ""
        }

        for (let i = 0; i < this.neededItemInfos.length; ++i) {
          if (!this.neededItemInfos[i].name && this.neededItemInfos[i].need_number) {
            this.newItemsNullError = "※持ち物を入力してください"
            return false
          }
        }

        for (let i = 0; i < this.neededItemInfos.length; ++i) {
          if (this.neededItemInfos[i].name && !this.neededItemInfos[i].need_number) {
            this.newItemsNumberNullError = "※持ち物の数を入力してください"
            console.log("※持ち物の数を入力してください")
            return false
          }
        }
      }
    }
  }
</script>
