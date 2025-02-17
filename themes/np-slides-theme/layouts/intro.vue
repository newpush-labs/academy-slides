<template>
  <div class="slidev-layout intro">
    <img src="../images/np_logo_white.png" class="logo" />
    <div class="my-auto">
      <slot />
    </div>
  </div>
</template>

<style>
.slidev-layout.intro {
  background-color: #1C63B7;
  color: white;
  font-family: 'Roboto', sans-serif;
  font-size: 36px;
  position: relative;
}

.logo {
  position: absolute;
  top: 20px;
  right: 20px;
  width: 120px;
  height: auto;
}

h1 {
  color: white;
  font-family: 'Roboto', sans-serif !important;
  text-decoration: none !important;
}

</style>