<template>
  <div
    v-if="bringItemId!=0"
    class="self-bring-item"
  >
    <input
      id="checkbox"
      v-model="bringChecked"
      type="checkbox"
      @change="changeBringCheckBox"
    >
    <p>{{ itemName }}({{ bringNumber }})</p>
  </div>
</template>

<script>
/* eslint-disable camelcase */
/* eslint-disable no-undef */

import axios from 'axios'
export default {
  props: {
    item: { type: Object, default: () => ({ }) },
    currentUserId: { type: String, default: '' }
  },
  data () {
    return {
      selectedNumber: '',
      bringItems: [],
      isCurrentUserItem: false,
      bringSum: 0,
      needNumberCopy: 0,
      currentUserBringItems: [],
      itemName: '',
      bringNumber: 0,
      bringItemId: 0,
      bringChecked: false
    }
  },
  mounted () {
    this.getUserBringItem()
    this.needNumberCopy = this.needNumber
  },
  methods: {
    getUserBringItem () {
      axios.get('/api/items/' + this.item.id + '.json')
        .then((response) => {
          this.bringItems = response.data.bring_item_names
          this.currentUserBringItems = []
          for (var i = 0; i < this.bringItems.length; i++) {
            if (Number(this.bringItems[i].user_id) === Number(this.currentUserId)) {
              this.itemName = this.bringItems[i].item_name
              this.bringNumber = this.bringItems[i].bring_number
              this.bringItemId = this.bringItems[i].user_bring_item_id
              this.bringChecked = this.bringItems[i].bring_check
            }
          }
          this.HasBringItemsUser()
          this.sumBringNumber()
        }, (error) => {
          console.log(error, response)
        })
    },
    deleteUserBringItem (bringItem) {
      axios.delete('/api/user_bring_items/' + bringItem.user_bring_item_id, {
        bringItem
      }).then((response) => {
        this.getUserBringItem()
        this.bringSum -= Number(bringItem.bring_number)
      }, (error) => {
        console.log(error, response)
      })
    },
    createUserBringItems (item, selectedNumber) {
      axios.post('/api/user_bring_items', {
        item: item,
        selectedNumber: selectedNumber

      }).then(() => {
        this.getUserBringItem()
      }, (error) => {
        console.log(error, response)
      })
    },
    HasBringItemsUser () {
      if (this.bringItems.length === 0) {
        this.isCurrentUserItem = false
        return
      }
      for (var i = 0; i < this.bringItems.length; i++) {
        if (Number(this.bringItems[i].user_id) === Number(this.currentUserId)) {
          this.isCurrentUserItem = true
        }
        this.isCurrentUserItem = false
        return
      }
    },
    isCurrentUser (bringItem) {
      if (bringItem.user_id === Number(this.currentUserId)) {
        return true
      } else {
        return false
      }
    },
    sumBringNumber () {
      this.bringSum = 0
      for (var i = 0; i < this.bringItems.length; i++) {
        this.bringSum += Number(this.bringItems[i].bring_number)
      }
    },
    changeBringCheckBox () {
      var params
      if (this.bringChecked) {
        params = {
          check: true,
          id: this.bringItemId
        }
      } else {
        params = {
          check: false,
          id: this.bringItemId
        }
      }
      axios.patch('/api/user_bring_items/' + this.bringItemId, params)
        .then(() => {

        }, (error) => {
          console.log(error, response)
        })
    },
    checkedBringItem () {
      axios.patch('/api/user_bring_items/' + this.bringItemId, {
        check: true,
        id: this.bringItemId
      }).then(() => {

      }, (error) => {
        console.log(error, response)
      })
    },
    uncheckedBringItem () {
      axios.patch('/api/user_bring_items/' + this.bringItemId, {
        check: false,
        id: this.bringItemId
      }).then(() => {

      }, (error) => {
        console.log(error, response)
      })
    }

  }
}
</script>

<style scoped>
  input {
    display: inline-block;
  }

  p {
    display: inline-block;

  }
</style>
