'use strict'


exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
    },
    body: '<p>ようこそ本当に素晴らしいTerraformの世界へ！</p>',
  }
  callback(null, response)
}
