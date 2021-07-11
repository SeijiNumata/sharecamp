<template>
  <div class=self-bring-item v-if="this.bringItemId!=0">
    <input type="checkbox" id="checkbox" v-model="bringChecked" v-on:change="changeBringCheckBox">
    <p>{{this.itemName}}({{this.bringNumber}})</p>

  </div>
</template>
<script>
  import axios from 'axios';
  export default {
    props: {
      item: Object,
      currentUserId: String
    },
    data() {
      return {
        selectedNumber: "",
        bring_items: [],
        isCurrentUserItem: false,
        bringSum: 0,
        needNumberCopy: 0,
        currentUserBringItems: [],
        itemName: "",
        bringNumber: 0,
        bringItemId: 0,
        bringChecked: false
      }
    },
    mounted() {
      this.getUserBringItem();
      this.needNumberCopy = this.needNumber
    },
    methods: {
      getUserBringItem() {
        axios.get("/api/items/" + this.item.id + ".json")
          .then((response) => {
            const bring_items = response.data.bring_item_names
            this.bring_items = bring_items
            this.currentUserBringItems = []
            for (var i = 0; i < this.bring_items.length; i++) {
              if (Number(this.bring_items[i].user_id) === Number(this.currentUserId)) {

                this.itemName = this.bring_items[i].item_name
                this.bringNumber = this.bring_items[i].bring_number
                this.bringItemId = this.bring_items[i].user_bring_item_id
                console.log(JSON.stringify(this.bring_items[i]))
                this.bringChecked = this.bring_items[i].bring_check
                console.log("ほし")
                console.log(this.bringChecked)
                console.log("ほし")
              }
            }
            this.HasBringItemsUser()
            this.sumBringNumber()
          }, (error) => {
            console.log(error, response);
          });

      },
      deleteUserBringItem(bring_item) {
        axios.delete('/api/user_bring_items/' + bring_item.user_bring_item_id, {
          bring_item
        }).then((response) => {
          this.getUserBringItem()
          this.bringSum -= Number(bring_item.bring_number)
        }, (error) => {
          console.log(error, response);
        });

      },
      createUserBringItems(item, selectedNumber) {
        axios.post('/api/user_bring_items', {
          item: item,
          selectedNumber: selectedNumber

        }).then(() => {
          this.getUserBringItem()
        }, (error) => {
          console.log(error, response);
        });
      },
      HasBringItemsUser() {
        if (this.bring_items.length === 0) {
          return this.isCurrentUserItem = false;
        }
        for (var i = 0; i < this.bring_items.length; i++) {
          if (Number(this.bring_items[i].user_id) === Number(this.currentUserId)) {
            return this.isCurrentUserItem = true;
          }
          this.isCurrentUserItem = false;
        }
      },
      isCurrentUser(bring_item) {
        if (bring_item.user_id === Number(this.currentUserId)) {
          return true
        } else {
          return false
        }

      },
      sumBringNumber() {
        this.bringSum = 0
        for (var i = 0; i < this.bring_items.length; i++) {
          this.bringSum += Number(this.bring_items[i].bring_number)
        }
      },
      changeBringCheckBox() {
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
            console.log(error, response);
          });
      },
      checkedBringItem() {
        axios.patch('/api/user_bring_items/' + this.bringItemId, {
          check: true,
          id: this.bringItemId
        }).then(() => {

        }, (error) => {
          console.log(error, response);
        });
      },
      uncheckedBringItem() {
        axios.patch('/api/user_bring_items/' + this.bringItemId, {
          check: false,
          id: this.bringItemId
        }).then(() => {

        }, (error) => {
          console.log(error, response);
        });
      },

    }
  }
</script>

<style scoped>
  input {
    display: inline-block;
    /* vertical-align:1px; */
  }

  p {
    display: inline-block;

  }
</style>
