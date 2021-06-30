<template>
    <div>
        <p>aaaaaaaa</p>
        <p>{{name}}</p>
        <span>{{ needNumber}}</span>

        <select v-model="selectedNumber" name="example">
            <option value='' disabled selected style='display:none;'>数</option>
            <option v-for="n of needNumber" :key="n" value="1">{{n}}</option>
        </select>
        <button type="button" @click="createUserBringItems(item,selectedNumber)">持っていく</button>

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
                selectedNumber: ""
            }
        },
        methods:{
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
