<template>
    <div>
        <p>aaaaaaaa</p>
        <p>{{name}}</p>
        <span>{{ needNumber}}</span>

        <select v-model="selectedNumber" name="example">
            <option value='' disabled selected style='display:none;'>数</option>
            <option v-for="n of needNumber" :key="n" >{{n}}</option>
        </select>
        <button type="button" @click="createUserBringItems(item,selectedNumber)">持っていく</button> 
        <p>{{bring_items}}</p>
    </div>
</template>

<script>
  import axios from 'axios';
    export default {
        props: {
            name: String,
            needNumber: Number,
            item :Object
        },
        data() {
            return {
                selectedNumber: "",
                names:[],
                bring_items:[]
            }
        },
         mounted() {
      this.getUserBringItem() ;
    },
        methods:{
    　　 getUserBringItem() {
         console.log("やってみよう")
         console.log(this.item.id)
         axios.get("/api/items/"+this.item.id+".json")
          .then((response) => {
              console.log(response.data.bring_item_names)
              const bring_items=response.data.bring_item_names
            //   const obj={
            //     //   name: response.data.bring_item_names.name,
            //       bring_items: bring_items
            //   }
            //   console.log("obj"+JSON.stringify(obj))
            console.log("g"+JSON.stringify(bring_items))
            //     this.bring_items.push(obj)
            //   console.log(this.bring_items)
            this.bring_items=bring_items
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

            })
        }
        }
    }
</script>
