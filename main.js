'use strict'

exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
    },
    body: '<p>ようこそTerraformの世界へ！test</p>',
  }
  callback(null, response)
}
