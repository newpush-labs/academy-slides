<script setup lang="ts">
import { defineComponent } from 'vue'
import { useNav } from '@slidev/client'

const nav = useNav()
</script>

<template>
  <div class="slidev-layout roadmap h-full">
    <div class="grid grid-cols-3 h-full">
      <!-- Left column with shape and title -->
      <div class="relative col-span-1">
        <div class="shape absolute inset-0" />
        <div class="title-container relative z-10">
          <h1 class="whitespace-pre-line"><slot name="title" /></h1>
        </div>
      </div>

      <!-- Right column with content -->
      <div class="col-span-2 relative">
        <!-- Logo -->
        <img src="../images/np_logo_labs.png" class="logo absolute" />
        
        <!-- Main content -->
        <div class="main-content">
          <slot />
        </div>
        
        <!-- Page number -->
        <div class="page-number absolute">{{ nav.currentPage }}</div>
      </div>
    </div>
  </div>
</template>

<style>
.slidev-layout.roadmap {
  @apply !p-0;
  @keyframes shapeAnimation {
    0% {
      clip-path: polygon(0 0, 100% 0, 100% 15%, 80% 85%, 50% 100%, 0 100%);
    }
    50% {
      clip-path: polygon(0 0, 100% 0, 100% 20%, 85% 80%, 55% 100%, 0 100%);
    }
    100% {
      clip-path: polygon(0 0, 100% 0, 100% 15%, 80% 85%, 50% 100%, 0 100%);
    }
  }
  .shape {
    background-color: var(--slidev-theme-primary);
    animation: shapeAnimation 8s ease-in-out infinite;
    clip-path: polygon(0 0, 100% 0, 100% 15%, 80% 85%, 50% 100%, 0 100%);
  }

  .title-container {
    @apply px-8 pt-[15%];

    h1 {
      @apply text-5xl font-bold leading-tight text-white;
      text-decoration: none !important;
      margin: 0 !important;
      padding-top: 1rem !important;
    }
  }

  .logo {
    @apply top-4 right-4;
    width: 120px;
  }

  .main-content {
    @apply p-12 pt-16;

    ul {
      @apply space-y-8;

      li {
        @apply text-2xl;
        list-style-type: none;
        position: relative;

        &::before {
          content: "•";
          position: absolute;
          left: -1.5em;
          color: var(--slidev-theme-primary);
        }

        >p {
          @apply text-[var(--slidev-theme-primary)];
        }

        ul {
          @apply mt-2 ml-6 space-y-2;

          li {
            @apply text-gray-700;
          }
        }
      }
    }
  }

  .page-number {
    @apply bottom-4 right-4 text-gray-500;
  }
}
</style>
