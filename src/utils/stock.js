const rp = require('request-promise')

const url = 'http://hq.sinajs.cn/list='

const getStockInfo = (codes) => {
  rp(url + codes)
    .then((htmlString) => {
      console.log(htmlString)
    })
    .catch((err) => {
      console.log(err)
    })
}

module.exports.getStockInfo = getStockInfo
