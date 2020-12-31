module.exports = {
  purge: {
    enabled: process.env.NODE_ENV === 'production',
    content: [
      './index.html',
      './src/**/*.vue',
      './src/**/*.js',
      './src/**/*.ts',
    ],
  },
  theme: {
    extend: {
      opacity: {
        10: '0.1',
      },
      colors: {
        primary: {
          100: '#91C4D7',
          200: '#65ACC8',
          300: '#4FA0C0',
          400: '#4091B1',
          500: '#387F9B',
          600: '#306D85',
          700: '#285B6F',
          800: '#204959',
          900: '#183642',
        },
      },
    },
  },
}
