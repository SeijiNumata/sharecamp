<template>
    <div>
        <p>------------------------------</p>
        <p>{{name}}        <span>({{bringSum}}/{{ needNumber}})</span></p>


        <select v-model="selectedNumber" name="example">
            <option value='' disabled selected style='display:none;'>数</option>
            <option v-for="n of needNumberCopy" :key="n">{{n}}</option>
        </select>
        <button type="button" v-bind:disabled="isDisabled||needNumber-bringSum<=0"
            @click="createUserBringItems(item,selectedNumber)">持っていく</button>
        <!-- <p>{{bring_items}}</p>
        <p>ww{{currentUserId}}</p> -->
        <ul id="example-1">
            <li v-for="bring_item in bring_items" :key="bring_item.id">
                {{ bring_item }}
               <button type="button" v-show="IsUser(bring_item)" @click="deleteUserBringItem(bring_item)">❌</button>
            </li>
        </ul>
    </div>
</template>

<script>
    import axios from 'axios';
    export default {
        props: {
            name: String,
            needNumber: Number,
            item: Object,
            currentUserId: String
        },
        data() {
            return {
                selectedNumber: "",
                names: [],
                bring_items: [],
                isDisabled: false,
                isUser:false,
                bringSum:0,
                needNumberCopy: 0,
            }
        },
        mounted() {
            this.getUserBringItem();
            this.needNumberCopy=this.needNumber
        },
        methods: {
            getUserBringItem() {
                console.log("やってみよう")
                console.log(this.item.id)
                axios.get("/api/items/" + this.item.id + ".json")
                    .then((response) => {
                        console.log(response.data.bring_item_names)
                        const bring_items = response.data.bring_item_names
                        console.log("g" + JSON.stringify(bring_items))
                        //     this.bring_items.push(obj)
                        //   console.log(this.bring_items)
                        console.log("エラー出てry"+this.bring_items)
                        this.bring_items = bring_items
                        console.log("おかしいな")
                        console.log("あ"+this.bring_items)
                        this.HasBringItemsUser()

                        console.log("this.bring_items"+this.bring_items)
                        this.sumBringNumber()
                        // this.sumSelectedNumber()
                        //   return bring_items
                        //   }).then((obj)=>{
                        //       console.log("ツアが"+JSON.stringify(obj))
                        //       this.bring_items.push(obj)
                        //       console.log("afa"+JSON.stringify(this.bring_items)
                    }, (error) => {
                        console.log(error, response);
                    });

            },
            deleteUserBringItem(bring_item){
                console.log("delete")
                console.log(bring_item.bring_number)
                axios.delete('/api/user_bring_items/'+bring_item.user_bring_item_id,{
                    bring_item
              }).then((response) => {
                    console.log(response)
                    this.getUserBringItem()
                    console.log("bringSUm"+this.bringSum)
                    this.bringSum-=Number(bring_item.bring_number)
                }, (error) => {
                    console.log(error, response);
                });

            },
            createUserBringItems(item, selectedNumber) {
                console.log(selectedNumber)
                axios.post('/api/user_bring_items', {
                    item: item,
                    selectedNumber: selectedNumber

                }).then(() => {
                    console.log("a")
                    console.log(this.bring_items[0])
                    const obj = {
                        "user_id": Number(this.currentUserId)
                    }

                    this.getUserBringItem()

                }, (error) => {
                    console.log(error, response);
                });
            },
            HasBringItemsUser() {
                console.log("HasBringItemsUse")
                console.log(this.bring_items)
                if(this.bring_items.length===0){
                    console.log("nukkda")
                   return this.isDisabled = false;
                }
                console.log("this.bring_items.length"+this.bring_items.length)
                for (var i = 0; i < this.bring_items.length; i++) {
                    console.log("a" + [i])
                    console.log(Number(this.bring_items[i].user_id))
                    console.log(Number(this.currentUserId))
                    if (Number(this.bring_items[i].user_id) === Number(this.currentUserId)) {
                        console.log("true")
                        return this.isDisabled = true;
                    }
                    console.log("false")
                    this.isDisabled = false;
                }
            },
            IsUser(bring_item){
                console.log("----------------------------------------------------------------")
                console.log(bring_item.user_id)
                console.log(this.currentUserId)
                console.log("----------------------------------------------------------------")
                if(bring_item.user_id===Number(this.currentUserId)){
                    console.log("true")
                    return true
                }else{
                     console.log("false")
                    return false
                }

            },
            sumBringNumber(){
                this.bringSum=0
                for (var i = 0; i < this.bring_items.length; i++) {
                    console.log("bbb"+ JSON.stringify(this.bring_items[i]))
                    console.log("aaa"+JSON.stringify(this.bring_items[i].bring_number))
                    console.log("ccc"+this.bringSum)
                    this.bringSum+=Number(this.bring_items[i].bring_number)
                    console.log("ddd"+this.bringSum)
                }
            },
        }
    }
</script>
