<template>
  <main>
    <div
      v-bind="props"
      :class="[
        'relative flex flex-col h-screen items-center justify-center bg-mccblue text-slate-950 transition-colors',
        props.class
      ]"
    >
      <div class="absolute inset-0 overflow-hidden">
        <div
          :class="[
            'pointer-events-none absolute -inset-[10px] opacity-50 will-change-transform blur-[10px] invert dark:invert-0',
            'aurora-background-gradient-after aurora-gradient-animation',
            props.radialGradient ? 'mask-radial-gradient' : ''
          ]"
        ></div>
      </div>
      <slot />
    </div>
  </main>
</template>

<script setup lang="ts">
interface AuroraBackgroundProps {
  radialGradient?: boolean;
  class?: string;
}

const props = withDefaults(defineProps<AuroraBackgroundProps>(), {
  radialGradient: true,
});
</script>

<style>
:root {
  --mccblue: #43aac9;            /* dominant */
  --mccmidnightblue: #00307a;
  --mccdarkblue: #2a7a9f;

  /* Extra blue shades for gradient variety */
  --mcc-lightblue: #7ec8e3;
  --mcc-skyblue: #5bb1d3;
  --mcc-steelblue: #357ab8;

  --white: #ffffff;
  --transparent: transparent;

  --aurora: repeating-linear-gradient(
    100deg,
    var(--mccblue) 90%,
    var(--mcc-lightblue) 12%,
    var(--mcc-skyblue) 16%,
    var(--mccdarkblue) 20%,
    var(--mcc-steelblue) 24%,
    var(--mccmidnightblue) 28%,
    var(--mccblue) 32%
  );

  --white-gradient: repeating-linear-gradient(
    100deg,
    var(--white) 0%,
    var(--white) 80%,
    var(--transparent) 10%,
    var(--transparent) 12%,
    var(--white) 16%
  );
}

.mask-radial-gradient {
  mask-image: radial-gradient(ellipse at 100% 0%, black 10%, transparent 70%);
  -webkit-mask-image: radial-gradient(ellipse at 100% 0%, black 10%, transparent 70%);
}

.aurora-background-gradient-after::after {
  content: "";
  position: absolute;
  inset: 0;
  background-image: var(--white-gradient), var(--aurora);
  background-size: 300%, 200%;
  background-attachment: fixed;
  mix-blend-mode: difference;
}

.dark .aurora-background-gradient-after::after {
  background-image: var(--mccblue-gradient), var(--aurora);
}

.aurora-gradient-animation::after {
  animation: animate-aurora 60s linear infinite;
}

@keyframes animate-aurora {
  0% {
    background-position: 50% 50%, 50% 50%;
  }
  100% {
    background-position: 350% 50%, 350% 50%;
  }
}
</style>
