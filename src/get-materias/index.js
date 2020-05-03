const AWS = require('aws-sdk');
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
  console.log(`Processing Event: ${JSON.stringify(event)}`);
  
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

  let scanningParameters = {
    TableName: 'Comentarios',
    AttributesToGet: [
      'id',
      'materia'
    ]
  };

  docClient.scan(scanningParameters, function (err, data) {
    if (err) {
      callback(err, null);
    } else {
      console.log(JSON.stringify(data));
      let list = data.Items;
      let groupedList = groupValues(list,'materia');
    let result = [];
    [...groupedList].forEach(materia => {
      result.push({"materia": materia[0].materia, "totalComentarios": materia.length});
    });
    var response = {
      "statusCode": 200,
      "headers": {
        "Content-Type": "application/json"
      },
      "body": JSON.stringify(result)
    };
    callback(null, response);
  }
  });
}