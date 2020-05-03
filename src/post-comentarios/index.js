const AWS = require('aws-sdk');
const uuid = require('uuid');
const docClient = new AWS.DynamoDB.DocumentClient({region: 'us-east-1'});

const groupValues = function(arr, key) {
  const mapped = {}
  arr.forEach(el => {
      const actualKey = el[key]
      if(!mapped.hasOwnProperty(actualKey)) mapped[actualKey] = []

      mapped[actualKey].push(el)
  })
  return Object.keys(mapped).map(el => mapped[el])
}

exports.handler = function(event, context, callback) {
  const apiKey = process.env.api_key;
  console.log('processing event data: ' + JSON.stringify(event.body, null, 2));

  // X-API-Key
  if(event.headers['X-API-Key'] == undefined){
    callback(null, {
      "statusCode": 401,
      "headers": {
        "Content-Type": "application/json"
      },
      "body": JSON.stringify({code: "API_KEY_NOT_FOUND", reason: "Parametro X-API-Key nao informado.", detail: ""})
    });
  }
  if(event.headers['X-API-Key'] != apiKey){
    callback(null, {
      "statusCode": 401,
      "headers": {
        "Content-Type": "application/json"
      },
      "body": JSON.stringify({code: "API_KEY_INVALID", reason: "Parametro X-API-Key invalido.", detail: ""})
    });
  }
  var requestData = JSON.parse(event.body);
  console.log('Request data is : ' + JSON.stringify(requestData));

  let newItem =  {
    Item: {
      id: uuid.v1(),
      materia: requestData.materia,
      email: requestData.email,
      comentario: requestData.comentario,
      timestamp: new Date().toISOString()
    },
    TableName: 'Comentarios'
  };

  console.log('Putting item in database : ' + JSON.stringify(newItem.Item));
  docClient.put(newItem, function(err,data){
    if(err) {
      callback(err, null)
    }else{
      let response = {
        "statusCode": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "body": JSON.stringify(newItem.Item)
      };
      callback(null, response);
    }
  });
}