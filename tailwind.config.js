import defaultTheme from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';

/** @type {import('tailwindcss').Config} */
export default {
    content: [
        './vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
    ],

    theme: {
        extend: {
            fontFamily: {
                sans: ['Figtree', ...defaultTheme.fontFamily.sans],
            },
            colors: {
                mccblue: '#43aac9',
                mcclightblue: '#85cee8',
                mccmediumblue: '#69c3e3',
                mccdarkblue: '#2a7a9f',
                mccmidnightblue: '#00307a',
                offwhite: '#f9fafc',    // subtle offwhite with a slight blue tint
                whitebg: '#f9fafb',
            },
            backgroundImage: {
                'mcc-gradient': 'linear-gradient(to bottom, #43aac9, #f9fafc)',
            },
            animation: {
                'bg-pan': 'bg-pan 25s ease infinite',
                'slide-in-left': 'slide-in-left 0.5s ease-out forwards',
                'slide-in-right': 'slide-in-right 0.5s ease-out forwards',
                'slide-in-top': 'slide-in-top 0.5s ease-out forwards',
            },
            keyframes: {
                'bg-pan': {
                '0%': { backgroundPosition: '0% 0%' },
                '50%': { backgroundPosition: '0% 100%' },
                '100%': { backgroundPosition: '0% 0%' },
                },
                'slide-in-left': {
                '0%': {
                    opacity: '0',
                    transform: 'translateX(-30px)',
                },
                '100%': {
                    opacity: '1',
                    transform: 'translateX(0)',
                },
                },
                'slide-in-right': {
                '0%': {
                    opacity: '0',
                    transform: 'translateX(30px)',
                },
                '100%': {
                    opacity: '1',
                    transform: 'translateX(0)',
                },
                },
                'slide-in-top': {
                '0%': {
                    opacity: '0',
                    transform: 'translateY(-30px)',
                },
                '100%': {
                    opacity: '1',
                    transform: 'translateY(0)',
                },
                },
            },
        },
    },

    plugins: [forms],
};
