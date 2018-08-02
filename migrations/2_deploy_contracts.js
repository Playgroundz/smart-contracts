var xlsx = require('node-xlsx');
var fs = require('fs');
var token = artifacts.require("./IOGToken.sol");


function readFile(path) {
    //parse
    var obj = xlsx.parse(path);
    var excelObj = obj[0].data;

    var data = [];
    for (var i in excelObj) {
      var arr = [];
      var value = excelObj[i];

      for (var j in value) {
        arr.push(value[j]);
      }

      data.push(arr);
    }

    return data;
}


module.exports = function(deployer) {
  console.log("start");
  let xlsData = readFile("./disribution.xlsx");
  console.log("readFile:"+ xlsData.length);

  let addressArr = [];
  let tokenAmountArr = [];
  let lockedPeriodArr = [];

  for (let i = 0; i < xlsData.length; i++) {
    if (i === 0) {
        continue;
    }

    let arr = xlsData[i];
    let address = arr[0];
    let amount = arr[1];
    let lockedPeriod = arr[2];
    
    if (address.length === 42) {
      addressArr.push(address);
      tokenAmountArr.push(amount);
      lockedPeriodArr.push(lockedPeriod);
    }
    else {
      console.log("invalid adress:" + address);
    }
  }

  // log
  for (let i = 0; i < addressArr.length; i++) {
    console.log(addressArr[i] + ":" + tokenAmountArr[i] + " (locked:" + lockedPeriodArr[i] + ")");
  }

  // deploy
  deployer.deploy(token, addressArr, tokenAmountArr, lockedPeriodArr);
};
