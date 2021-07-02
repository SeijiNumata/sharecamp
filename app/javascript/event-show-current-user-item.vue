<template>
    <div>
        <h1>持ってきて欲しいもの</h1>
        <p>{{currentUserId}}</p>
        <p>{{currentUserBringItems}}</p>
        <p>{{this.itemName}}</p>
        <p>{{this.bringNumber}}</p>
        <p>{{this.bringItemId}}</p>



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
                bringSum:0,
                needNumberCopy: 0,
                currentUserBringItems: [],

                itemName:"",
                bringNumber:0,
                bringItemId:0
            }
        },
        mounted() {
            this.getUserBringItem();
            this.needNumberCopy=this.needNumber
        },
        methods: {
            getUserBringItem() {
                axios.get("/api/items/" + this.item.id + ".json")
                    .then((response) => {
                        const bring_items = response.data.bring_item_names
                        this.bring_items = bring_items
                        this.currentUserBringItems=[]
                    for (var i = 0; i < this.bring_items.length; i++) {
                    if (Number(this.bring_items[i].user_id) === Number(this.currentUserId)) {
                       
                        this.itemName=this.bring_items[i].item_name
                        this.bringNumber=this.bring_items[i].bring_number
                        this.bringItemId=this.bring_items[i].user_bring_item_id
                    }
                }
                        this.HasBringItemsUser()
                        this.sumBringNumber()
                    }, (error) => {
                        console.log(error, response);
                    });

            },
            deleteUserBringItem(bring_item){
                axios.delete('/api/user_bring_items/'+bring_item.user_bring_item_id,{
                    bring_item
              }).then((response) => {
                    this.getUserBringItem()
                    this.bringSum-=Number(bring_item.bring_number)
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
                if(this.bring_items.length===0){
                   return this.isCurrentUserItem = false;
                }
                for (var i = 0; i < this.bring_items.length; i++) {
                    if (Number(this.bring_items[i].user_id) === Number(this.currentUserId)) {
                        return this.isCurrentUserItem = true;
                    }
                    this.isCurrentUserItem = false;
                }
            },
            isCurrentUser(bring_item){
                if(bring_item.user_id===Number(this.currentUserId)){
                    return true
                }else{
                    return false
                }

            },
            sumBringNumber(){
                this.bringSum=0
                for (var i = 0; i < this.bring_items.length; i++) {
                    this.bringSum+=Number(this.bring_items[i].bring_number)
                }
            },
        }
    }
</script>
