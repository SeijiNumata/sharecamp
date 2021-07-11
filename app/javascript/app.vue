<template>
  <div id="app">
    <!-- <p :style="{color: color}"> {{ message }}</p> -->
    <h1> {{ code }}</h1>
  </div>
</template>

<script>
export default {
  props:{
    code: { type: String },
    // color: { type: String }
  },
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
