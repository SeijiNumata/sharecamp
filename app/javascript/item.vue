<template>
    <div>
        <p>aaaaaaaa</p>
        <p>{{name}}</p>
        <span>{{ needNumber}}</span>

        <select v-model="selectedNumber" name="example">
            <option value='' disabled selected style='display:none;'>数</option>
            <option v-for="n of needNumber" :key="n">{{n}}</option>
        </select>
        <button type="button" v-bind:disabled="isDisabled"
            @click="createUserBringItems(item,selectedNumber)">持っていく</button>
        <p>{{bring_items[0]}}</p>
        <p>ww{{currentUserId}}</p>
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
                isDisabled: false
            }
        },
        mounted() {
            this.getUserBringItem();
        },
        methods: {
            getUserBringItem() {
                console.log("やってみよう")
                console.log(this.item.id)
                axios.get("/api/items/" + this.item.id + ".json")
                    .then((response) => {
                        console.log(response.data.bring_item_names)
                        const bring_items = response.data.bring_item_names
                        //   const obj={
                        //     //   name: response.data.bring_item_names.name,
                        //       bring_items: bring_items
                        //   }
                        //   console.log("obj"+JSON.stringify(obj))
                        console.log("g" + JSON.stringify(bring_items))
                        //     this.bring_items.push(obj)
                        //   console.log(this.bring_items)
                        this.bring_items = bring_items
                        //   return bring_items
                        //   }).then((obj)=>{
                        //       console.log("ツアが"+JSON.stringify(obj))
                        //       this.bring_items.push(obj)
                        //       console.log("afa"+JSON.stringify(this.bring_items)
                    }, (error) => {
                        console.log(error, response);
                    });

            },
            createUserBringItems(item, selectedNumber) {
                console.log(selectedNumber)
                axios.post('/api/user_bring_items', {
                    item: item,
                    selectedNumber: selectedNumber

                }).then((response) => {
                    console.log("a")
                    console.log(this.bring_items[0])
                    const obj = {
                        "user_id": Number(this.currentUserId)
                    }
                   
                    this.HasBringItemsUser()

                }, (error) => {
                    console.log(error, response);
                });
            },
            HasBringItemsUser(){
                  for (var i = 0; i < this.bring_items.length; i++) {
                        console.log("a"+[i])
                        console.log(Number(this.bring_items[i].user_id))
                        console.log(Number(this.currentUserId))
                        if (Number(this.bring_items[i].user_id) === Number(this.currentUserId)) {
                            console.log("true")
                            return this.isDisabled = true;
                        }
                        console.log("false")
                        return this.isDisabled = false;
                    }
            }
        }
    }
</script>
