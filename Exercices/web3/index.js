const Web3 = require('web3')
require('dotenv').config();

const rpcURL = 'https://goerli.infura.io/v3/' + `${process.env.INFURA_ID}`;
const web3 = new Web3(rpcURL)

deployedAdress =

    web3.eth.getBalance("0x4b984D560387C22f399B76a38edabFE52903E599", (err, wei) => {
        balance = web3.utils.fromWei(wei, 'ether'); // convertir la valeur en ether
        console.log(balance);
    });

const abi = [
    {
        "inputs": [],
        "name": "get",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "x",
                "type": "uint256"
            }
        ],
        "name": "set",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

const SSaddress = "0x4b984D560387C22f399B76a38edabFE52903E599";
const simpleStorage = new web3.eth.Contract(abi, SSaddress);
simpleStorage.methods.get().call((err, data) => {
    console.log(data);
});

const abi2 =
    [
        {
            "inputs": [],
            "name": "get",
            "outputs": [
                {
                    "internalType": "uint256",
                    "name": "",
                    "type": "uint256"
                }
            ],
            "stateMutability": "view",
            "type": "function"
        }
    ]

const addr2 = "0xfA95935932ECcd000765C772CF8A731B1E215d06";
const simpleStorage2 = new web3.eth.Contract(abi2, addr2);
simpleStorage2.methods.get().call((err, data) => {
    console.log(data);
}); 