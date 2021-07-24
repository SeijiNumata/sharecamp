<template>
  <div class="event-show-item">
    <div class="item-and-input">
      <p class="item-name-and-number">
        {{ itemName }} <span>({{ bringSum }}/{{ needNumber }})</span>
      </p>
      <div class="event-show-item-input">
        <select
          v-show="needNumber!=1"
          v-model="selectedNumber"
          class="number-select"
          name="select-number"
          :disabled="isCurrentUserItem||needNumber-bringSum<=0"
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
            v-for="n of Math.max(needNumber-bringSum, 0)+1"
            :key="n"
          >
            {{ n-1 }}
          </option>
        </select>
        <div class="stamp-button-component">
          <button
            class="bring-button"
            type="button"
            :disabled="isCurrentUserItem||needNumber-bringSum<=0"
            @click="createUserBringItems(item,selectedNumber)"
          >
            持っていく
          </button>
          <p
            v-if="noNumberErrorMessage"
            class="no-number-error"
          >
            {{ noNumberErrorMessage }}
          </p>
          <p />
          <div
            v-if="needNumber-bringSum<=0"
            class="postmark-decide"
          >
            決まり
          </div>
          <div
            v-if="isCurrentUserItem"
            class="postmark-bring"
          >
            持っていく
          </div>
        </div>
      </div>
    </div>
    <ul class="event-show-item-user">
      <li
        v-for="(bring_item,index) in bringItems"
        :key="bring_item.id"
      >
        <p :class="{'bring-item-current-user-name':isCurrentUserBringItem(bring_item.user_id)}">
          {{ bring_item.name }}({{ bring_item.bring_number }})
        </p>
        <button
          v-show="isCurrentUser(bring_item)"
          type="button"
          @click="deleteUserBringItem(bring_item)"
        >
          ×
        </button>
        <p v-if="bringItems[index+1]!=null">
          ,
        </p>
      </li>
    </ul>
  </div>
</template>

<script>
/* eslint-disable camelcase */
/* eslint-disable no-undef */

import axios from 'axios'
export default {
  props: {
    itemName: { type: String, default: '' },
    needNumber: { type: Number, default: 0 },
    item: { type: Object, default: () => ({ }) },
    currentUserId: { type: String, default: '' }
  },
  data () {
    return {
      selectedNumber: '',
      bringItems: [],
      isCurrentUserItem: false,
      bringSum: 0,
      noNumberErrorMessage: ''
    }
  },
  mounted () {
    this.getUserBringItem()
  },
  methods: {
    getUserBringItem () {
      axios.get('/api/items/' + this.item.id + '.json')
        .then((response) => {
          this.bringItems = response.data.bring_item_names
          this.checkItemCurrentUserBring()
          this.sumBringNumber()
        }, (error) => {
          console.log(error, response)
        })
    },
    deleteUserBringItem (bringItem) {
      axios.delete('/api/user_bring_items/' + bringItem.user_bring_item_id, {
        bringItem
      }).then(() => {
        this.getUserBringItem()
        this.bringSum -= Number(bringItem.bring_number)
      }, (error) => {
        console.log(error, response)
      })
    },
    createUserBringItems (item, selectedNumber) {
      if (this.needNumber === 1) {
        selectedNumber = 1
      }
      if (this.isNumberNullCheck(selectedNumber)) {
        return
      }
      axios.post('/api/user_bring_items', {
        item: item,
        bring_number: selectedNumber
      }).then(() => {
        this.getUserBringItem()
      }, (error) => {
        console.log(error, response)
      })
    },
    checkItemCurrentUserBring () {
      if (this.bringItems.length === 0) {
        this.isCurrentUserItem = false
        return
      }
      for (var i = 0; i < this.bringItems.length; i++) {
        if (Number(this.bringItems[i].user_id) === Number(this.currentUserId)) {
          this.isCurrentUserItem = true
          return
        }
        this.isCurrentUserItem = false
      }
    },
    isCurrentUser (bringItem) {
      return bringItem.user_id === Number(this.currentUserId)
    },
    sumBringNumber () {
      this.bringSum = 0
      for (var i = 0; i < this.bringItems.length; i++) {
        this.bringSum += Number(this.bringItems[i].bring_number)
      }
    },
    isCurrentUserBringItem (userId) {
      return Number(this.currentUserId) === userId
    },
    isNumberNullCheck (selectedNumber) {
      if (selectedNumber === '') {
        this.noNumberErrorMessage = '※数を入力してください'
        return true
      } else if (Number(selectedNumber) === 0) {
        this.noNumberErrorMessage = '※数が０の場合登録できません'
        return true
      } else {
        this.noNumberErrorMessage = ''
        return false
      }
    }
  }
}
</script>
