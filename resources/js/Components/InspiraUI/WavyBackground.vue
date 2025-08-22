<template>
  <div :class="cn('h-screen flex flex-col items-center justify-center', props.containerClass)">
    <canvas
      id="canvas"
      ref="canvasRef"
      class="absolute z-0"
      :style="{ filter: isSafari ? `blur(${props.blur}px)` : undefined }"
    ></canvas>
    <div :class="cn('relative z-10', props.class)">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import { createNoise3D } from "simplex-noise";
import { cn } from "@/lib/utils";
import { ref, onMounted, onBeforeUnmount } from "vue";
import { templateRef } from "@vueuse/core";

interface WavyBackgroundProps {
  class?: string;
  containerClass?: string;
  colors?: string[];
  waveWidth?: number;
  blur?: number;
  speed?: "slow" | "fast";
  waveOpacity?: number;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  [key: string]: any;
}

const props = withDefaults(defineProps<WavyBackgroundProps>(), {
  colors: () => ["#43aac9", "#2a7a9f", "#00307a", "#7ec8e3"],
  waveWidth: 35,
  blur: 15,
  speed: "fast",
  waveOpacity: 0.4,
});

const noise = createNoise3D();

let w: number, h: number, nt = 0;
let ctx: CanvasRenderingContext2D | null = null;
let animationId: number;

const canvasRef = templateRef<HTMLCanvasElement | null>("canvasRef");

function getSpeed(): number {
  return props.speed === "slow" ? 0.001 : 0.002;
}

function getGradientOffset(time: number): number {
  const panSpeed = 0.00007;
  return 0.5 + 0.5 * Math.sin(time * panSpeed * 2 * Math.PI); // oscillates between 0 and 1
}


function init() {
  const canvas = canvasRef.value;
  if (canvas) {
    ctx = canvas.getContext("2d");
    if (ctx) {
      const parent = canvasRef.value.parentElement;
      if (parent) {
        w = ctx.canvas.width = parent.clientWidth;
        h = ctx.canvas.height = parent.clientHeight;
      }

      ctx.filter = `blur(${props.blur}px)`;

      window.onresize = () => {
        if (parent && ctx) {
          w = ctx.canvas.width = parent.clientWidth;
          h = ctx.canvas.height = parent.clientHeight;
          ctx.filter = `blur(${props.blur}px)`;
        }
      };

      render();
    }
  }
}

function drawWave(n: number) {
  nt += getSpeed();
  for (let i = 0; i < n; i++) {
    ctx!.beginPath();
    ctx!.lineWidth = props.waveWidth!;
    ctx!.strokeStyle = props.colors[i % props.colors!.length];
    for (let x = 0; x < w; x += 5) {
      const y = noise(x / 800, 0.3 * i, nt) * 100;
      ctx!.lineTo(x, y + h * 0.5);
    }
    ctx!.stroke();
    ctx!.closePath();
  }
}

function render(time = 0) {
  if (!ctx) return;

  const offset = getGradientOffset(time);

  // Gradient simulating bg-mcc-gradient
  const gradient = ctx.createLinearGradient(0, h * -offset, 0, h * (1 - offset));
  gradient.addColorStop(0, "#43aac9");   // mccblue
  gradient.addColorStop(1, "#f9fafc");   // offwhite

  ctx.globalAlpha = 1;
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, w, h);

  ctx.globalAlpha = props.waveOpacity!;
  drawWave(10);

  animationId = requestAnimationFrame(render);
}

onBeforeUnmount(() => {
  cancelAnimationFrame(animationId);
});

const isSafari = ref(false);
onMounted(() => {
  isSafari.value =
    typeof window !== "undefined" &&
    navigator.userAgent.includes("Safari") &&
    !navigator.userAgent.includes("Chrome");

  init();
});
</script>
