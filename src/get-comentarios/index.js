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
  if(event.queryStringParameters == undefined || event.queryStringParameters.materia == undefined){
    callback(null, {
      "statusCode": 400,
      "headers": {
        "Content-Type": "application/json"
      },
      "body": JSON.stringify({code: "QUERY_PARAMETER_MISSING", reason: "Parametro Materia nao informado.", detail: ""})
    });
  }
  let materia = event.queryStringParameters.materia;
  let offset;
  if(event.queryStringParameters.offset == undefined){
    offset = new Date().toISOString();
  }
  else{
    offset = event.queryStringParameters.offset;
  }
  let scanningParameters = {
    TableName: 'Comentarios',
    KeyConditionExpression: 'materia = :materia AND #timestamp < :offset',
    ExpressionAttributeNames: { "#timestamp": "timestamp" },
    ScanIndexForward: false,
    ExpressionAttributeValues: {
        ':materia': materia,
        ':offset': offset,
    },
    Limit: '20'
  };

  docClient.query(scanningParameters, function (err, data) {
    if (err) {
      callback(err, null);
    } else {
      console.log(JSON.stringify(data));
      // let sortedArray = data.Items.sort((a,b) => {
      //     return a.id > b.id ? -1 : a.id < b.id ? 1 : 0;
      // });
      var response = {
        "statusCode": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "body": JSON.stringify(data)
      };
      callback(null, response);
    }
  });
}